# Git Basics for Data Engineers

This tutorial gives you the minimum Git skills needed to work on data pipeline projects safely and confidently.

## 1) Why Git Matters for Pipelines

- Track every infrastructure and code change.
- Roll back quickly when a deployment breaks.
- Collaborate across ingestion, transformation, and analytics teams.
- Keep production changes auditable.

## 2) One-Time Setup

```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```

Check setup:

```bash
git config --list
```

## 3) Core Git Flow (Daily Use)

### Clone a repository

```bash
git clone https://github.com/<org>/<repo>.git
cd <repo>
```

### Create a feature branch

```bash
git checkout -b feature/add-athena-validation
```

### Make changes and inspect status

```bash
git status
git diff
```

### Stage and commit

```bash
git add tutorials/aws-streaming-pipelines-python-pyspark.md
git commit -m "docs: add Athena validation query examples"
```

### Push branch to remote

```bash
git push -u origin feature/add-athena-validation
```

## 4) Important Commands to Know

### View commit history

```bash
git log --oneline --graph --decorate -n 20
```

### Compare your branch with main

```bash
git fetch origin
git diff origin/main...HEAD
```

### Undo local unstaged changes in one file

```bash
git restore <file>
```

### Unstage a file but keep changes

```bash
git restore --staged <file>
```

## 5) Keep Your Branch Updated

```bash
git fetch origin
git rebase origin/main
```

If conflicts appear:
- Fix conflict markers in files.
- Continue rebase:

```bash
git add <resolved-file>
git rebase --continue
```

## 6) Good Commit Message Examples

- `docs: add CI setup instructions`
- `feat: add Python Kinesis producer sample`
- `fix: handle missing schema_version in API payload`
- `refactor: simplify Glue job config loading`

## 7) Common Mistakes and Fixes

- Committed to `main` accidentally:
  - Create a branch from current commit and reset local `main` to remote.
- Pushed secrets by mistake:
  - Rotate credentials immediately and remove secret history with security-approved process.
- Huge mixed commit:
  - Split into smaller focused commits for easier review.

## 8) Practice Exercise

1. Create branch `feature/git-practice`.
2. Edit any tutorial markdown file.
3. Run `git status` and `git diff`.
4. Commit with a meaningful message.
5. Push the branch.
6. Open a pull request on GitHub.

You now have the Git foundation required for the streaming pipeline labs.
