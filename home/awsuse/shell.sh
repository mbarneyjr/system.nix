#!/bin/bash
_awsuse_config_file=~/.aws/awsuse/config
_awsuse_credentials_file=~/.aws/awsuse/credentials
_awsuse_console_services_file=${_awsuse_console_services_file:-~/system.nix/home/awsuse/services.txt}
mkdir -p ~/.aws/awsuse

_awsuse-all-profiles () {
  sed -n -r 's/^\[(profile )?([-A-z0-9]+)\]$/\2/p' ~/.aws/*config* ~/.aws/*credentials* | sort
}

_awsuse-squishinate () {
  cat ~/.aws/*config* > ${_awsuse_config_file}
  cat ~/.aws/*credentials* > ${_awsuse_credentials_file}
}

_awsuse-console-services () {
  cat "${_awsuse_console_services_file}"
}

# porcelain commands

awsuse () {
  local profile
  profile=$1
  _awsuse-squishinate

  if [[ ${profile} =~ ^[0-9]{12}:[a-zA-Z0-9+=,.@_-]+$ ]]; then
    profile="arn:aws:iam::${profile%%:*}:role/${profile#*:}"
  fi

  if [[ ${profile} == arn:aws:iam::* ]]; then
    role_arn=${profile}
    session_name="$(whoami)"
    temp_credentials=$(aws sts assume-role --role-arn "${role_arn}" --role-session-name "${session_name}" --output json)
    awsunuse
    AWS_ACCESS_KEY_ID=$(echo "${temp_credentials}" | jq -r '.Credentials.AccessKeyId')
    AWS_SECRET_ACCESS_KEY=$(echo "${temp_credentials}" | jq -r '.Credentials.SecretAccessKey')
    AWS_SESSION_TOKEN=$(echo "${temp_credentials}" | jq -r '.Credentials.SessionToken')
    AWSUSE_PROFILE=$(echo "${temp_credentials}" | jq -r '.AssumedRoleUser.AssumedRoleId')
    AWS_REGION=$(aws configure get region || echo "us-east-1")
    export AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN AWSUSE_PROFILE AWS_REGION
  else
    if grep -q "${profile}\]" ${_awsuse_credentials_file} ${_awsuse_config_file}; then
      export AWSUSE_PROFILE=${profile}
      export AWS_PROFILE=${profile}
      export AWS_CONFIG_FILE=${_awsuse_config_file}
      export AWS_SHARED_CREDENTIALS_FILE=${_awsuse_credentials_file}
    else
      echo "Profile not found in config or credentials file"
    fi
  fi
}

awsunuse() {
  unset AWSUSE_PROFILE
  unset AWS_PROFILE
  unset AWS_DEFAULT_PROFILE
  unset AWS_REGION
  unset AWS_CONFIG_FILE
  unset AWS_SHARED_CREDENTIALS_FILE
  unset AWS_ACCESS_KEY_ID
  unset AWS_SECRET_ACCESS_KEY
  unset AWS_SESSION_TOKEN
}

awsuse-mfa () {
  (
    profile=${1}
    if [ -z "${profile}" ]; then
      echo "Usage: awsuse-mfa PROFILE_NAME"
      return 1
    fi
    mfa_device_arn=${2}
    if [ -z "${mfa_device_arn}" ]; then
      user_arn=$(aws sts get-caller-identity --profile "${profile}" --output text --query Arn)
      echo "User ARN: ${user_arn}"
      mfa_device_arn=${user_arn//:user/:mfa}
    fi
    echo "MFA Device ARN: ${mfa_device_arn}"

    target_credentials_file=~/.aws/awsuse_mfa-credentials
    profile=${1:-PROFILE_NAME}
    echo -n "Enter MFA token: "
    read -r mfa_token

    echo "[${profile}-mfa]" > ${target_credentials_file}
    {
      # shellcheck disable=SC2016
      aws sts get-session-token \
        --profile "${profile}" \
        --serial-number "${mfa_device_arn}" \
        --token-code "${mfa_token}" \
        --output text \
        --query 'Credentials.[join(``, [`aws_access_key_id=`, AccessKeyId, `\naws_secret_access_key=`, SecretAccessKey, `\naws_session_token=`, SessionToken])]'
    } >> "${target_credentials_file}"
  )
}

awsconsole () {
(
  set -e
  set -o pipefail
  service=${1:-console}
  profile=${2:-}
  if [ -n "$2" ]; then
    awsuse "$2"
  fi

  json_temp_credentials=$(aws configure export-credentials --format process | jq -c '{sessionId: .AccessKeyId, sessionKey: .SecretAccessKey, sessionToken: .SessionToken}')
  request_url="https://signin.aws.amazon.com/federation"
  sign_in_token=$(
    curl --data-urlencode "Action=getSigninToken" \
         --data-urlencode "Session=$json_temp_credentials" \
         --silent "${request_url}" | jq -r '.SigninToken'
  )

  if [[ $service = http* ]]; then
    destination=$service
  else
    destination_region=${AWS_REGION:-$(aws configure get region || echo "")}
    destination="https://console.aws.amazon.com/${service}/home?region=${destination_region:-us-east-1}"
  fi

  urlencode_many_printf () {
    string=$1
    while [ -n "$string" ]; do
      tail=${string#?}
      head=${string%"$tail"}
      case $head in
        [-._~0-9A-Za-z]) printf %c "$head";;
        *) printf %%%02x "'$head"
      esac
      string=$tail
    done
    echo
  }

  request_url="https://signin.aws.amazon.com/federation?Action=login&Issuer=&Destination=$(urlencode_many_printf "${destination}")&SigninToken=$sign_in_token"

  if command -v open >/dev/null 2>&1; then
    open -u "$request_url"
  elif command -v xdg-open >/dev/null 2>&1; then
    xdg-open "$request_url"
  elif command -v wslview >/dev/null 2>&1; then
    wslview "$request_url"
  else
    echo "Please open this URL in your browser:"
    echo "$request_url"
  fi
)}

# Shell completion for awsuse
if [[ -n "$ZSH_VERSION" ]]; then
  # zsh completion
  _awsuse_completion() {
    local -a profiles
    # shellcheck disable=SC2296,SC2034
    profiles=("${(@f)$(_awsuse-all-profiles)}")
    _describe 'AWS profiles' profiles
  }
  compdef _awsuse_completion awsuse
elif [[ -n "$BASH_VERSION" ]]; then
  # bash completion
  _awsuse_completion() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    mapfile -t COMPREPLY < <(compgen -W "$(_awsuse-all-profiles)" -- "$cur")
  }
  complete -F _awsuse_completion awsuse
fi

# Shell completion for awsconsole
if [[ -n "$ZSH_VERSION" ]]; then
  # zsh completion
  _awsconsole_completion() {
    # shellcheck disable=SC2034
    local context state line
    _arguments \
      '1:service:->services' \
      '2:profile:->profiles'

    case $state in
      services)
        local -a services
        # shellcheck disable=SC2296,SC2034
        services=("${(@f)$(_awsuse-console-services)}")
        _describe 'AWS console services' services
        ;;
      profiles)
        local -a profiles
        # shellcheck disable=SC2296,SC2034
        profiles=("${(@f)$(_awsuse-all-profiles)}")
        _describe 'AWS profiles' profiles
        ;;
    esac
  }
  compdef _awsconsole_completion awsconsole
elif [[ -n "$BASH_VERSION" ]]; then
  # bash completion
  _awsconsole_completion() {
    local cur="${COMP_WORDS[COMP_CWORD]}"

    case $COMP_CWORD in
      1)
        mapfile -t COMPREPLY < <(compgen -W "$(_awsuse-console-services)" -- "$cur")
        ;;
      2)
        mapfile -t COMPREPLY < <(compgen -W "$(_awsuse-all-profiles)" -- "$cur")
        ;;
    esac
  }
  complete -F _awsconsole_completion awsconsole
fi

# Shell completion for awsuse-mfa
if [[ -n "$ZSH_VERSION" ]]; then
  # zsh completion
  _awsuse_mfa_completion() {
    local -a profiles
    # shellcheck disable=SC2296,SC2034
    profiles=("${(@f)$(_awsuse-all-profiles)}")
    _describe 'AWS profiles' profiles
  }
  compdef _awsuse_mfa_completion awsuse-mfa
elif [[ -n "$BASH_VERSION" ]]; then
  # bash completion
  _awsuse_mfa_completion() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    mapfile -t COMPREPLY < <(compgen -W "$(_awsuse-all-profiles)" -- "$cur")
  }
  complete -F _awsuse_mfa_completion awsuse-mfa
fi
