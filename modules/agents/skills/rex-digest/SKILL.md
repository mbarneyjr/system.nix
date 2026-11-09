---
name: rex-digest
description: Read the Rex (Superlogical) Discord server in Chrome and write a digest of releases, features, tips, and community projects that apply to the user's Rex setup. Use when the user invokes /rex-digest or asks for a Rex Discord digest.
---

Make a digest of the Rex Discord server since the last digest.

## Inputs

- Digest directory: `~/.local/state/rex-digest/`. Each digest is `YYYY-MM-DD.md`.
- Last run: the date of the newest file in the digest directory. If the directory is empty, read the last 14 days.
- User setup: read all files in `~/system.nix/modules/rex/` before you read Discord.
  - `default.nix` holds the `com.superlogical.rex` defaults that nix manages.
  - `init.lua` and `navigator.lua` hold the Rex Lua configuration.
  - The `*.sh` files are session scripts that the Lua keybindings call.

## Procedure

1. Load the Claude in Chrome tools. Call `tabs_context_mcp`, then open a new tab with `tabs_create_mcp`.
2. Go to `https://discord.com/channels/@me` and open the Rex server from the server list.
3. If Discord asks for a sign-in, stop and tell the user to sign in to Discord in Chrome.
4. List the channels. Read the channels about announcements, releases, changelogs, tips, help, showcase, plugins, and Lua configuration. Skip off-topic channels.
5. In each channel, scroll up until you reach messages older than the last run. Use `get_page_text` to read messages.
6. Keep only items that are useful to the user. Skip greetings, unanswered questions, and bug reports with no workaround.
7. Close the tab.
8. Write the digest to `~/.local/state/rex-digest/<today>.md`.
9. Give the user the absolute path of the digest and the three most useful items.

## Digest format

```markdown
# Rex digest <today> (since <last run>)

## Releases and changes
## New features
## Tips and techniques
## Community projects
## Proposed configuration changes
```

For each item, give:

- A summary in one line.
- How the item applies to the user's setup. Name the file in `~/system.nix/modules/rex/` it affects, if any.
- A link to the Discord message (right-click the message and copy the message link, or use the channel link and date).

In "Proposed configuration changes", give the exact nix or Lua lines to add or change. For a new app setting, give the `com.superlogical.rex` defaults key. If a key name is not posted, write "key unknown" and tell the user to change the setting in the app and diff `defaults read com.superlogical.rex`.

Leave out empty sections. If no items are useful, write one line that says so.

Do not edit repository files. Do not post, react, or send messages in Discord.
