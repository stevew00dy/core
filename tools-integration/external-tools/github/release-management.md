# GitHub Release Management & Versioning Guide

## Version Management Process

### Current Version Tracking
Create/maintain these files in repository root:
- `VERSION` - Current version number (e.g., `1.0.1`)
- `CHANGELOG.md` - Automated changelog with commit history
- `package.json` - Standard package version (if applicable)

### Version Numbering (Semantic Versioning)
```
MAJOR.MINOR.PATCH (e.g., 1.2.3)
```

- **MAJOR** (1.x.x): Breaking changes, incompatible API changes
- **MINOR** (x.1.x): New features, backwards compatible
- **PATCH** (x.x.1): Bug fixes, patches, documentation updates

## Automated Release Workflow

### 1. Pre-Commit Checks
```bash
# Check current version
cat VERSION || echo "1.0.0" > VERSION

# Check README needs update
git status --porcelain README.md

# Check pending changes
git status --short
```

### 2. Version Bump Commands

#### Patch Version (Bug fixes)
```bash
# Increment patch version
current_version=$(cat VERSION)
new_version=$(echo $current_version | awk -F. '{print $1"."$2"."($3+1)}')
echo $new_version > VERSION
echo "Bumped to version $new_version"
```

#### Minor Version (New features)
```bash
# Increment minor version
current_version=$(cat VERSION)
new_version=$(echo $current_version | awk -F. '{print $1"."($2+1)".0"}')
echo $new_version > VERSION
echo "Bumped to version $new_version"
```

#### Major Version (Breaking changes)
```bash
# Increment major version
current_version=$(cat VERSION)
new_version=$(echo $current_version | awk -F. '{print ($1+1)".0.0"}')
echo $new_version > VERSION
echo "Bumped to version $new_version"
```

### 3. Changelog Generation

#### Get Recent Commits Since Last Tag
```bash
# Get commits since last version tag
last_tag=$(git describe --tags --abbrev=0 2>/dev/null || echo "")
if [ -z "$last_tag" ]; then
  commits=$(git log --oneline)
else
  commits=$(git log --oneline $last_tag..HEAD)
fi
```

#### Update CHANGELOG.md
```bash
# Prepare changelog entry
version=$(cat VERSION)
date=$(date '+%Y-%m-%d')

# Create temporary changelog
cat > CHANGELOG_TEMP.md << EOF
# Changelog

## [${version}] - ${date}

### Changes
$(git log --oneline HEAD~5..HEAD | sed 's/^/- /')

### Files Modified
$(git diff --name-only HEAD~5..HEAD | sed 's/^/- /')

EOF

# Append existing changelog if it exists
if [ -f CHANGELOG.md ]; then
  echo "" >> CHANGELOG_TEMP.md
  tail -n +2 CHANGELOG.md >> CHANGELOG_TEMP.md
fi

# Replace changelog
mv CHANGELOG_TEMP.md CHANGELOG.md
```

### 4. README Validation

#### Check README Currency
```bash
# Check if README mentions old version numbers
current_version=$(cat VERSION)
readme_versions=$(grep -o 'v[0-9]\+\.[0-9]\+\.[0-9]\+\|[0-9]\+\.[0-9]\+\.[0-9]\+' README.md | sort -u)

echo "Current version: $current_version"
echo "Versions found in README:"
echo "$readme_versions"

# Flag if README needs update
if ! echo "$readme_versions" | grep -q "$current_version"; then
  echo "⚠️  WARNING: README may need version update"
fi
```

#### Auto-Update README Version References
```bash
# Update version references in README (if pattern exists)
previous_version=$(git log --oneline -1 --grep="version" | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+' | head -1)
current_version=$(cat VERSION)

if [ ! -z "$previous_version" ] && [ "$previous_version" != "$current_version" ]; then
  sed -i.bak "s/$previous_version/$current_version/g" README.md
  echo "Updated README version references: $previous_version → $current_version"
fi
```

## MCP Release Commands

### Complete Release Process Script
```bash
#!/bin/bash
# release.sh - Complete release automation

set -e

echo "🚀 Starting release process..."

# 1. Version bump
echo "Current version: $(cat VERSION 2>/dev/null || echo 'none')"
read -p "Bump type (patch/minor/major): " bump_type

case $bump_type in
  patch)
    current_version=$(cat VERSION 2>/dev/null || echo "0.0.0")
    new_version=$(echo $current_version | awk -F. '{print $1"."$2"."($3+1)}')
    ;;
  minor)
    current_version=$(cat VERSION 2>/dev/null || echo "0.0.0")
    new_version=$(echo $current_version | awk -F. '{print $1"."($2+1)".0"}')
    ;;
  major)
    current_version=$(cat VERSION 2>/dev/null || echo "0.0.0")
    new_version=$(echo $current_version | awk -F. '{print ($1+1)".0.0"}')
    ;;
  *)
    echo "Invalid bump type. Use: patch, minor, or major"
    exit 1
    ;;
esac

echo $new_version > VERSION
echo "✅ Bumped to version $new_version"

# 2. Update changelog
date=$(date '+%Y-%m-%d')
recent_commits=$(git log --oneline HEAD~5..HEAD)

cat > CHANGELOG_NEW.md << EOF
# Changelog

## [${new_version}] - ${date}

### Changes
$(echo "$recent_commits" | sed 's/^/- /')

### Files Modified
$(git diff --name-only HEAD~5..HEAD | sed 's/^/- /')

EOF

if [ -f CHANGELOG.md ]; then
  echo "" >> CHANGELOG_NEW.md
  tail -n +2 CHANGELOG.md >> CHANGELOG_NEW.md
fi

mv CHANGELOG_NEW.md CHANGELOG.md
echo "✅ Updated CHANGELOG.md"

# 3. Check README
readme_check=$(grep -c "$new_version" README.md || echo 0)
if [ $readme_check -eq 0 ]; then
  echo "⚠️  README may need manual version updates"
  echo "Please review README.md for version references"
fi

# 4. Commit version files via MCP
echo "📤 Committing version files..."

docker mcp tools call create_or_update_file \
  owner=stevew00dy \
  repo=core \
  branch=main \
  path="VERSION" \
  message="Bump version to ${new_version}" \
  content="$(cat VERSION)"

docker mcp tools call create_or_update_file \
  owner=stevew00dy \
  repo=core \
  branch=main \
  path="CHANGELOG.md" \
  message="Update changelog for ${new_version}" \
  content="$(cat CHANGELOG.md)"

echo "✅ Release $new_version completed!"
echo "📋 Next steps:"
echo "  1. Review README.md for version updates"
echo "  2. Create GitHub release tag: git tag v$new_version"
echo "  3. Push tags: git push origin --tags"
```

## MCP Commands for Release Management

### 1. Check Current Release State
```bash
# Check repository version files
docker mcp tools call get_file_contents owner=USERNAME repo=REPO path="VERSION"
docker mcp tools call get_file_contents owner=USERNAME repo=REPO path="CHANGELOG.md"
docker mcp tools call get_file_contents owner=USERNAME repo=REPO path="README.md"
```

### 2. Update Version File
```bash
# Commit new version
docker mcp tools call create_or_update_file \
  owner=USERNAME \
  repo=REPO \
  branch=main \
  path="VERSION" \
  message="Bump version to 1.0.1" \
  content="1.0.1"
```

### 3. Update Changelog
```bash
# Commit updated changelog
docker mcp tools call create_or_update_file \
  owner=USERNAME \
  repo=REPO \
  branch=main \
  path="CHANGELOG.md" \
  message="Update changelog for 1.0.1" \
  content="$(cat CHANGELOG.md)"
```

### 4. Create Release Tag
```bash
# Create release tag
docker mcp tools call create_tag \
  owner=USERNAME \
  repo=REPO \
  tag="v1.0.1" \
  message="Release version 1.0.1" \
  sha="COMMIT_SHA"
```

### 5. Create GitHub Release
```bash
# Create formal GitHub release
docker mcp tools call create_release \
  owner=USERNAME \
  repo=REPO \
  tag_name="v1.0.1" \
  name="Version 1.0.1" \
  body="$(tail -n +3 CHANGELOG.md | head -20)" \
  draft=false \
  prerelease=false
```

## File Templates

### VERSION File
```
1.0.1
```

### Initial CHANGELOG.md
```markdown
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.1] - 2025-09-17

### Added
- Initial project structure
- Core modules and documentation

### Changed
- Updated folder organization
- Improved documentation structure

### Fixed
- Minor documentation inconsistencies
```

## Best Practices

1. **Always bump version before major commits**
2. **Update changelog with meaningful descriptions**
3. **Review README.md for version-specific content**
4. **Use conventional commit messages for automation**
5. **Tag releases for easy rollback reference**
6. **Keep changelog concise but informative**
7. **Validate all links and references after version updates**

## Automation Opportunities

- **Pre-commit hooks** to check version consistency
- **GitHub Actions** for automated releases
- **Commit message parsing** for automatic version bumping
- **Link validation** for README updates
- **Notification systems** for release announcements