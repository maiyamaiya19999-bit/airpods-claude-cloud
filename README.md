# AirPods -> Claude Code Cloud

Give Claude Code a task through AirPods while your Mac is off. Siri launches an iPhone Shortcut, the Shortcut creates a private GitHub issue, and the official Claude Code Action completes the task on a GitHub-hosted runner.

## Install the skill

In Claude Code:

```bash
npx skills add maiyamaiya19999-bit/airpods-claude-cloud
```

Then ask:

```text
Use $airpods-claude-cloud to connect my AirPods to Claude Code through GitHub Actions.
```

You can also send Claude Code this repository URL and ask it to install and configure the skill.

## What happens

```text
AirPods
  -> Siri
  -> iPhone Shortcut with Dictate Text
  -> private GitHub issue containing @claude
  -> official Claude Code Action in GitHub Actions
  -> result as an issue comment or pull request
  -> GitHub notification on iPhone / AirPods
```

After one-time setup, the Mac may be turned off. Claude Code works only with files already pushed to the chosen GitHub repository; it cannot see files stored only on the Mac.

## Requirements

- AirPods connected to an iPhone with Siri and Shortcuts enabled.
- A GitHub repository where you have admin access. A private dedicated repository is recommended.
- The official [Claude GitHub App](https://github.com/apps/claude) installed only for that repository.
- Claude authentication through either a Pro/Max OAuth token or an Anthropic API key.
- GitHub Mobile notifications if you want Siri to announce the completion message.

The skill walks through the complete setup and uses the bundled workflow template. Detailed manual steps are in [references/setup.md](references/setup.md).

## Security

The iPhone Shortcut needs a fine-grained GitHub token scoped to one repository with Issues read/write access. Never publish or share the configured Shortcut: a shared copy can expose its token. Keep publication, payments, deletion, secret access, and other serious actions behind manual confirmation.

## Sources

- [Run shortcuts with Siri](https://support.apple.com/guide/shortcuts/apd07c25bb38/ios)
- [Use Siri with AirPods](https://support.apple.com/guide/airpods/devc2c0f438a/web)
- [Claude Code Action](https://github.com/anthropics/claude-code-action)
- [Claude Code Action setup](https://github.com/anthropics/claude-code-action/blob/main/docs/setup.md)

## License

MIT
