# Setup Reference

Use this reference when configuring the GitHub workflow, authentication, or iPhone Shortcut.

## 1. Choose the repository

Use a private repository that contains the files Claude Code should work with. The user must have admin access because the setup requires a GitHub App, Actions secrets, and a workflow.

Cloud execution sees the checked-out Git commit. It does not see uncommitted or unpushed files from a Mac.

## 2. Install the workflow

From the installed skill directory:

```bash
./scripts/install_workflow.sh /absolute/path/to/target-repository
```

The script creates `.github/workflows/claude-airpods.yml` without overwriting an existing file. Review, commit, and push it.

The workflow listens for new issues containing `@claude`, checks out the repository, and runs `anthropics/claude-code-action@v1`. The official action performs its own author permission check before it acts.

## 3. Configure Claude authentication

Choose exactly one method.

### Claude Pro or Max

Generate an OAuth token once on a computer with Claude Code installed:

```bash
claude setup-token
```

Add the result to the target repository as the Actions secret `CLAUDE_CODE_OAUTH_TOKEN`. Do not paste the token into chat or a command that will echo it. Use GitHub Settings -> Secrets and variables -> Actions, or an interactive secret command.

The bundled workflow uses this mode by default.

### Anthropic API billing

Add `ANTHROPIC_API_KEY` as an Actions secret. In `.github/workflows/claude-airpods.yml`, replace:

```yaml
claude_code_oauth_token: ${{ secrets.CLAUDE_CODE_OAUTH_TOKEN }}
```

with:

```yaml
anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
```

Never configure both inputs in the same workflow step.

Install the official Claude GitHub App from `https://github.com/apps/claude` and grant it access only to the selected repository.

## 4. Create the iPhone token

Create a GitHub fine-grained personal access token:

- Repository access: only the target repository.
- Repository permission: `Issues` -> `Read and write`.
- Use the shortest practical expiration and rotate it if the phone or Shortcut is shared.

The configured Shortcut contains this token. Do not share or publish the configured Shortcut. A tutorial may show the action structure only, with the token hidden.

## 5. Build the iPhone Shortcut

Open Shortcuts and create a shortcut named `Задача для Claude` with these actions:

1. `Dictate Text`. Stop listening after a pause.
2. `Current Date`, formatted as `yyyy-MM-dd HH:mm`.
3. `Text` with the following content, inserting the Dictated Text variable:

   ```text
   @claude

   Voice task from AirPods:
   [Dictated Text]

   Work only in this repository. Do not publish, deploy, change billing or secrets, or delete data without a separate confirmation.
   ```

4. `Get Contents of URL`:
   - URL: `https://api.github.com/repos/OWNER/REPOSITORY/issues`
   - Method: `POST`
   - Headers:
     - `Accept`: `application/vnd.github+json`
     - `Authorization`: `Bearer YOUR_FINE_GRAINED_TOKEN`
     - `X-GitHub-Api-Version`: `2022-11-28`
   - Request Body: JSON
     - `title`: `Voice task [Current Date]`
     - `body`: the Text value from step 3
5. Read `html_url` from the response and save it if desired.
6. `Speak Text`: `Задачу отправила. Результат придёт в GitHub.`

Replace `OWNER`, `REPOSITORY`, and the token locally on the iPhone.

Run it through AirPods by activating Siri and saying: `Задача для Claude`. Siri runs the shortcut, then the Dictate Text action captures the task.

## 6. Receive the result

The issue author is normally subscribed to issue updates. Install GitHub Mobile and enable issue notifications. If Announce Notifications is enabled for the relevant app and AirPods, Siri can read the notification aloud.

The actual result appears in the GitHub issue or in a pull request created by Claude Code. Do not promise that a full file or long report will be read aloud.

## 7. Test safely

Start with:

```text
@claude Summarize README.md and comment with four bullets. Do not modify files.
```

Confirm all of the following:

- The Shortcut receives a successful GitHub API response and returns an issue URL.
- A GitHub Actions run starts.
- Claude posts a tracking or result comment.
- The phone receives a GitHub notification.

Only after this test should the user try a file-changing task. Keep deployment, publication, payment, secret access, workflow edits, and deletion behind manual confirmation.

## Troubleshooting

- No workflow run: confirm the issue body contains lowercase `@claude`, Actions are enabled, and the workflow is on the default branch.
- Workflow starts but Claude does not respond: inspect the run for a missing GitHub App installation or missing/expired Claude secret.
- Shortcut gets HTTP 401: rotate the GitHub token and confirm the Authorization header uses `Bearer`.
- Shortcut gets HTTP 404: verify the owner/repository path and that the token can access that private repository.
- Claude cannot find a file: push the file to GitHub; cloud execution cannot read the Mac filesystem.
