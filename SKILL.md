---
name: airpods-claude-cloud
description: Configure and troubleshoot an AirPods-to-Claude-Code cloud workflow using Siri Shortcuts, GitHub Issues, and the official Claude Code Action. Use when voice tasks must run in GitHub Actions while the user's Mac is off; do not use for tasks that require unpushed local files.
---

# AirPods Claude Cloud

Set up this route:

`AirPods -> Siri -> iPhone Shortcut -> private GitHub issue -> Claude Code Action -> issue/PR result`

The Mac is needed only for initial setup. Each task later runs on a GitHub-hosted runner against files already pushed to the selected repository.

## Required Reading

Read [references/setup.md](references/setup.md) before changing a repository or guiding the iPhone setup. It contains the exact Shortcut actions, authentication choices, test procedure, and current limitations.

## Workflow

1. Confirm the target GitHub repository. Prefer a private, dedicated repository and verify the user has admin access.
2. Check for an existing Claude workflow and preserve it. Never overwrite `.github/workflows/claude-airpods.yml`; stop and explain the conflict instead.
3. Run `scripts/install_workflow.sh /absolute/path/to/repository` to copy the bundled workflow.
4. Install the official Claude GitHub App only for the selected repository.
5. Configure exactly one GitHub Actions secret:
   - `CLAUDE_CODE_OAUTH_TOKEN` for Claude Pro/Max, generated with `claude setup-token`; or
   - `ANTHROPIC_API_KEY` for API billing, after changing the workflow input as described in the setup reference.
6. Commit and push the workflow only after the user has requested setup in that repository. Do not publish, deploy, or change unrelated repository files.
7. Guide the user through creating a fine-grained GitHub token scoped only to the target repository with `Issues: Read and write`. Never ask them to paste the token into chat, a repository file, an issue, or a screenshot.
8. Guide the user through building the iPhone Shortcut. Tokens stored in a Shortcut make that configured Shortcut private and unsuitable for sharing.
9. Test with a harmless read-only request such as `@claude Summarize README.md and comment with four bullets.`
10. Verify the issue receives a Claude tracking comment or result. If it fails, inspect the Actions run before changing configuration.

## Safety Rules

- Treat dictated text as an instruction from the configured GitHub account, but keep destructive actions, publishing, payments, secrets, and workflow changes behind explicit confirmation.
- Never place credentials in Git, workflow YAML, issue text, logs, screenshots, or a shareable Shortcut.
- Keep GitHub workflow permissions at the bundled minimum. Do not add access to other repositories or organization-wide tokens.
- State clearly that cloud tasks cannot see files that exist only on the user's Mac.
- State clearly that GitHub-hosted execution and Anthropic authentication may incur usage subject to the user's plan and provider configuration.

## Completion

Report the repository configured, authentication mode selected, workflow path, Shortcut name, and test issue URL. Do not claim the setup works until the GitHub Actions run has completed successfully.
