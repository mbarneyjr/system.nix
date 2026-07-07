# Claude Global Context

## Communication

- Be terse. Short answers unless depth is explicitly needed.
- Never use emojis unless explicitly asked.
- Do not write code comments unless the WHY is non-obvious (hidden constraint, subtle invariant, workaround for a specific bug).
- Never write explanatory comments for self-evident code.

## Git

Never commit or push, even with explicit instruction.
This applies even when changes are staged or a commit seems like the obvious next step.

## Environment

This machine is managed with Nix (nix-darwin + home-manager).
Projects use nix flakes.
Sometimes a project's flake is a higher-level parent flake.
Development environments are entered via `direnv` (`.envrc` + `devShell`).

Never install tools or runtimes globally.
Do not run `npm install -g`, `pip install` (global), `brew install`, `cargo install`, or any global equivalent.
All tools, language runtimes, and CLI utilities must come from the project's nix devshell.
If something is missing, suggest adding it to the project flake's `devShell` or to the system nix config.
If you need to run a command, use nix run (`nix run nixpkgs#python3`).
