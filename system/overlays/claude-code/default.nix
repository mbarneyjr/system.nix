final: prev:
let
  inherit (prev.stdenvNoCC.hostPlatform) system;
  gcsBucket = "https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases";
  manifest = prev.lib.importJSON ./manifest.json;
  platforms = {
    x86_64-linux = "linux-x64";
    aarch64-linux = "linux-arm64";
    x86_64-darwin = "darwin-x64";
    aarch64-darwin = "darwin-arm64";
  };
  platform = platforms.${system};
in
{
  claude-code = prev.stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "claude-code";
    version = manifest.version or "unstable";

    src = prev.fetchurl {
      url = "${gcsBucket}/${finalAttrs.version}/${platform}/claude";
      hash = manifest.hashes.${platform} or prev.lib.fakeHash;
    };

    dontUnpack = true;
    dontBuild = true;

    # otherwise the bun runtime is executed instead of the binary
    dontStrip = true;

    nativeBuildInputs = [
      prev.installShellFiles
      prev.makeBinaryWrapper
    ]
    ++ prev.lib.optionals (!prev.stdenvNoCC.isDarwin) [ prev.autoPatchelfHook ];

    installPhase = ''
      runHook preInstall
      installBin $src
      wrapProgram $out/bin/claude \
        --set DISABLE_AUTOUPDATER 1
      runHook postInstall
    '';

    nativeInstallCheckInputs = [
      prev.versionCheckHook
      prev.writableTmpDirAsHomeHook
    ];
    versionCheckKeepEnvironment = [ "HOME" ];
    versionCheckProgramArg = "--version";
    doInstallCheck = true;

    meta = {
      description = "Agentic coding tool that lives in your terminal, understands your codebase, and helps you code faster";
      homepage = "https://github.com/anthropics/claude-code";
      downloadPage = "https://www.npmjs.com/package/@anthropic-ai/claude-code";
      changelog = "https://github.com/anthropics/claude-code/blob/main/CHANGELOG.md";
      license = prev.lib.licenses.unfree;
      maintainers = with prev.lib.maintainers; [ mirkolenz ];
      sourceProvenance = [ prev.lib.sourceTypes.binaryNativeCode ];
      mainProgram = "claude";
      platforms = prev.lib.attrNames platforms;
    };
  });
}
