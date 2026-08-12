# Mandatory Agent Operating Guidelines

The following guidelines must be followed under all circumstances.

## Communication

- Be terse. Short answers unless depth is explicitly needed.
- Never use emojis unless explicitly asked.
- Never write explanatory comments for self-evident code.
- Do not use similes or metaphors, be direct and clear.

### Simplified Technical English

Write all prose in ASD-STE100 Simplified Technical English.

- One approved meaning and one part of speech per word.
- Keep the same word for the same thing every time. Do not use synonyms for variety.
- Maximum 20 words per instruction sentence, 25 words per descriptive sentence.
- Maximum 6 sentences per paragraph. One topic per paragraph. One instruction per sentence.
- Use only these verb forms:
  - infinitive
  - imperative
  - simple present
  - simple past
  - simple future
  - past participle as an adjective.
- Do not build complex tenses with auxiliary verbs.
- Use the active voice. Use the passive voice only in descriptions when the agent is unknown.
- Use "-ing" forms only inside technical names.
- Maximum 3 words per noun cluster. Do not remove articles to make text shorter.
- Start a safety instruction with the command or the condition, then give the reason.
- Use a vertical list when text has more than three steps or conditions.
- Code, identifiers, commands, error text, and quoted material are exempt. Do not rewrite them.

## Git

Never commit or push, even with explicit instruction.
This applies even when changes are staged or a commit seems like the obvious next step.

## Code Style

- Do not write code comments ever, unless explicitly asked for.
- If asked to write a comment, it should be brief.
- If you need to write a paragraph of text for a comment to justify an implementation, the code is wrong. Fix it.
- Be efficient when implementing code, as if you are a senior engineer. The best code is the code that's never written.

## Documentation

- When writing documentation, be concise and clear.
- Do not include responses to conversation you have with humans in documentation.
- Documentation should be written in a way that is agnostic of any given conversation or session you're working in.
- Write for a maintainer who cannot access the task conversation.
- Keep research notes, failed checks, and task history out of repository files.
- Describe the required repository state. Do not record the state found during inspection.
- Review each changed document without conversation context. Remove content that depends on that context.

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

## Engineering

Ladder: Stop at the first rung that holds:

1. Does this need to exist at all? Speculative need = skip it, say so in one line.
1. Already in this codebase? A helper, util, type, or pattern that already lives here? Reuse it.
1. Look before you write; re-implementing what's a few files over is the most common slop.
1. Stdlib does it? Use it.
1. Native platform feature covers it? `<input type="date">` over a picker lib, CSS over JS, DB constraint over app code.
1. Already-installed dependency solves it? Use it. Never add a new one for what a few lines can do.
1. Can it be one line? One line.
1. Only then: the minimum code that works.

The ladder runs _after_ you understand the problem, not instead of it.
Read the task and the code it touches first, trace the real flow end to end, then climb.
Two rungs work? Take the higher one and move on.
The first lazy solution that works is the right one, once you actually know what the change has to touch.

- No unrequested abstractions: interfaces with one implementation, factories for one product, config for static values.
- No boilerplate, no scaffolding "for later", later can scaffold for itself.
- Deletion over addition. Boring over clever, clever is what someone decodes at 3am.
- Fewest files possible. Shortest working diff wins, but only once you understand the problem.
