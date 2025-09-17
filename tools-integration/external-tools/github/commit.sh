#!/bin/bash
# commit.sh - Automated version bump and commit script
# Usage: ./commit.sh [patch|minor|major]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Starting automated commit process...${NC}"

# Check if we're in the right directory
if [ ! -f "VERSION" ] || [ ! -f "CHANGELOG.md" ]; then
    echo -e "${RED}❌ ERROR: VERSION or CHANGELOG.md not found. Run from project root.${NC}"
    exit 1
fi

# Get bump type from argument or prompt
BUMP_TYPE=${1:-}
if [ -z "$BUMP_TYPE" ]; then
    echo -e "${YELLOW}Select version bump type:${NC}"
    echo "1) patch - Bug fixes, small changes (x.x.X)"
    echo "2) minor - New features, backwards compatible (x.X.x)"
    echo "3) major - Breaking changes (X.x.x)"
    read -p "Enter choice (1-3): " choice

    case $choice in
        1) BUMP_TYPE="patch" ;;
        2) BUMP_TYPE="minor" ;;
        3) BUMP_TYPE="major" ;;
        *) echo -e "${RED}Invalid choice. Exiting.${NC}"; exit 1 ;;
    esac
fi

# Current version
CURRENT_VERSION=$(cat VERSION 2>/dev/null || echo "0.0.0")
echo -e "${BLUE}Current version: ${CURRENT_VERSION}${NC}"

# Calculate new version
case $BUMP_TYPE in
    patch)
        NEW_VERSION=$(echo $CURRENT_VERSION | awk -F. '{print $1"."$2"."($3+1)}')
        ;;
    minor)
        NEW_VERSION=$(echo $CURRENT_VERSION | awk -F. '{print $1"."($2+1)".0"}')
        ;;
    major)
        NEW_VERSION=$(echo $CURRENT_VERSION | awk -F. '{print ($1+1)".0.0"}')
        ;;
    *)
        echo -e "${RED}Invalid bump type. Use: patch, minor, or major${NC}"
        exit 1
        ;;
esac

echo -e "${GREEN}New version: ${NEW_VERSION}${NC}"

# Update VERSION file
echo $NEW_VERSION > VERSION
echo -e "${GREEN}✅ Updated VERSION file${NC}"

# Get recent changes for changelog
echo -e "${BLUE}📝 Gathering recent changes...${NC}"
RECENT_COMMITS=$(git log --oneline HEAD~3..HEAD 2>/dev/null || echo "- Initial changes")
MODIFIED_FILES=$(git diff --name-only HEAD~3..HEAD 2>/dev/null || git ls-files | head -10)

# Get current date
DATE=$(date '+%Y-%m-%d')

# Prompt for changelog description
echo -e "${YELLOW}Enter a brief description of changes (or press Enter to use auto-generated):${NC}"
read -p "> " USER_DESCRIPTION

if [ -n "$USER_DESCRIPTION" ]; then
    CHANGELOG_ENTRY="- $USER_DESCRIPTION"
else
    CHANGELOG_ENTRY=$(echo "$RECENT_COMMITS" | sed 's/^[a-f0-9]* /- /')
fi

# Update CHANGELOG.md
cat > CHANGELOG_TEMP.md << EOF
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [${NEW_VERSION}] - ${DATE}

### Changes
${CHANGELOG_ENTRY}

### Files Modified
$(echo "$MODIFIED_FILES" | sed 's/^/- /')

EOF

# Append existing changelog (skip first 6 lines of old changelog)
if [ -f CHANGELOG.md ] && [ $(wc -l < CHANGELOG.md) -gt 6 ]; then
    echo "" >> CHANGELOG_TEMP.md
    tail -n +7 CHANGELOG.md >> CHANGELOG_TEMP.md
fi

mv CHANGELOG_TEMP.md CHANGELOG.md
echo -e "${GREEN}✅ Updated CHANGELOG.md${NC}"

# Check README for version references
echo -e "${BLUE}🔍 Checking README for version updates...${NC}"
if grep -q "$CURRENT_VERSION" README.md 2>/dev/null; then
    echo -e "${YELLOW}⚠️  README contains old version references. Consider updating manually.${NC}"
    echo "Old version found: $CURRENT_VERSION"
fi

# Commit via MCP
echo -e "${BLUE}📤 Committing to GitHub via MCP...${NC}"

# Get current SHAs for existing files
echo "Getting current file SHAs..."
VERSION_SHA=$(docker mcp tools call get_file_contents owner=stevew00dy repo=core path="VERSION" 2>/dev/null | grep "SHA:" | awk '{print $2}' | tr -d ')')
CHANGELOG_SHA=$(docker mcp tools call get_file_contents owner=stevew00dy repo=core path="CHANGELOG.md" 2>/dev/null | grep "SHA:" | awk '{print $2}' | tr -d ')')

# Commit VERSION file
echo "Committing VERSION file..."
if [ -n "$VERSION_SHA" ]; then
    docker mcp tools call create_or_update_file \
        owner=stevew00dy \
        repo=core \
        branch=main \
        path="VERSION" \
        message="Bump version to ${NEW_VERSION}" \
        content="$(cat VERSION)" \
        sha="$VERSION_SHA"
else
    docker mcp tools call create_or_update_file \
        owner=stevew00dy \
        repo=core \
        branch=main \
        path="VERSION" \
        message="Bump version to ${NEW_VERSION}" \
        content="$(cat VERSION)"
fi

# Commit CHANGELOG file
echo "Committing CHANGELOG file..."
if [ -n "$CHANGELOG_SHA" ]; then
    docker mcp tools call create_or_update_file \
        owner=stevew00dy \
        repo=core \
        branch=main \
        path="CHANGELOG.md" \
        message="Update changelog for version ${NEW_VERSION}" \
        content="$(cat CHANGELOG.md)" \
        sha="$CHANGELOG_SHA"
else
    docker mcp tools call create_or_update_file \
        owner=stevew00dy \
        repo=core \
        branch=main \
        path="CHANGELOG.md" \
        message="Update changelog for version ${NEW_VERSION}" \
        content="$(cat CHANGELOG.md)"
fi

echo -e "${GREEN}🎉 Release ${NEW_VERSION} completed successfully!${NC}"
echo ""
echo -e "${BLUE}📋 Summary:${NC}"
echo "• Version: $CURRENT_VERSION → $NEW_VERSION"
echo "• Files updated: VERSION, CHANGELOG.md"
echo "• Repository: https://github.com/stevew00dy/core"
echo ""
echo -e "${BLUE}💡 Next steps (optional):${NC}"
echo "• Review README.md for version updates"
echo "• Create release tag: git tag v$NEW_VERSION"
echo "• Check GitHub repository for changes"