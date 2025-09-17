# Docker MCP GitHub Integration Guide

## Setup Requirements

### 1. Start MCP Gateway
```bash
docker mcp gateway run
```

### 2. GitHub Personal Access Token
- Token with repository permissions required
- Must be configured in MCP secrets

## Essential Commands

### List Available Tools
```bash
docker mcp tools list
```

### Check Repository Structure
```bash
docker mcp tools call get_file_contents owner=USERNAME repo=REPO path="/"
```

### Create/Update Files (Commit)
```bash
docker mcp tools call create_or_update_file owner=USERNAME repo=REPO branch=BRANCH path="FILEPATH" message="COMMIT_MESSAGE" content="$(cat LOCALFILE)"
```

### Delete Files
```bash
docker mcp tools call delete_file owner=USERNAME repo=REPO branch=BRANCH path="FILEPATH" message="COMMIT_MESSAGE"
```

### Get File Contents
```bash
docker mcp tools call get_file_contents owner=USERNAME repo=REPO path="FILEPATH"
```

### List Branches
```bash
docker mcp tools call list_branches owner=USERNAME repo=REPO
```

## Key GitHub MCP Tools

| Tool | Purpose |
|------|---------|
| `create_or_update_file` | Commit files to repository |
| `delete_file` | Remove files from repository |
| `get_file_contents` | Read repository files/structure |
| `list_branches` | View available branches |
| `create_branch` | Create new branches |
| `create_pull_request` | Create pull requests |
| `merge_pull_request` | Merge pull requests |

## Required Parameters

### For create_or_update_file:
- `owner` - GitHub username
- `repo` - Repository name
- `branch` - Target branch (e.g., "main")
- `path` - File path in repository
- `message` - Commit message
- `content` - File content
- `sha` - Current file SHA (for updates only)

## Common Workflows

### 1. Commit Single File
```bash
# Upload new file
docker mcp tools call create_or_update_file owner=myuser repo=myrepo branch=main path="src/file.js" message="Add new feature" content="$(cat src/file.js)"
```

### 2. Update Existing File
```bash
# Get current SHA first
docker mcp tools call get_file_contents owner=myuser repo=myrepo path="src/file.js"

# Update with SHA
docker mcp tools call create_or_update_file owner=myuser repo=myrepo branch=main path="src/file.js" message="Update feature" content="$(cat src/file.js)" sha="CURRENT_SHA"
```

### 3. Batch Upload Multiple Files
```bash
# Loop through files
for file in src/*.js; do
  docker mcp tools call create_or_update_file owner=myuser repo=myrepo branch=main path="$file" message="Upload $file" content="$(cat $file)"
done
```

## Error Handling

### Missing SHA Error
```
"sha" wasn't supplied. []
```
**Solution**: Get file SHA first with `get_file_contents`

### Missing Branch Parameter
```
error calling tool create_or_update_file: missing required parameter: branch
```
**Solution**: Always include `branch=main` parameter

### Authentication Failed
**Solution**: Verify GitHub token in MCP configuration

## File Size Limits
- Text files: Generally no issues
- Binary files: May need special handling
- Large files (>100MB): Use Git LFS or split files

## Best Practices
1. Always check repository structure first
2. Use descriptive commit messages
3. Verify changes with `get_file_contents` after commits
4. Handle authentication tokens securely
5. Use appropriate branch names