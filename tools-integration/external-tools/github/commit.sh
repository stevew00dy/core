#!/bin/bash
# commit.sh - Automated version bump and commit script
# Usage: ./commit.sh [patch|minor|major]
# Pushes directly to GitHub without modifying local files

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Starting automated GitHub commit process...${NC}"

# Repository configuration
OWNER="stevew00dy"
REPO="core"
BRANCH="main"

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

# Get current version from GitHub
echo -e "${BLUE}📡 Getting current version from GitHub...${NC}"

# Get the latest commit messages to find version information
RECENT_COMMITS=$(docker mcp tools call list_commits owner=$OWNER repo=$REPO 2>/dev/null)

# Look for version bump commits in recent history
CURRENT_VERSION=""
if [ -n "$RECENT_COMMITS" ]; then
    # Extract version from commit messages like "Bump version to 1.0.2"
    CURRENT_VERSION=$(echo "$RECENT_COMMITS" | grep -o 'version to [0-9]\+\.[0-9]\+\.[0-9]\+' | head -1 | awk '{print $3}')

    # Also check for "Update changelog for version X.Y.Z"
    if [[ ! "$CURRENT_VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        CURRENT_VERSION=$(echo "$RECENT_COMMITS" | grep -o 'version [0-9]\+\.[0-9]\+\.[0-9]\+' | head -1 | awk '{print $2}')
    fi
fi

# Final fallback - use default version
if [[ ! "$CURRENT_VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    CURRENT_VERSION="1.0.1"
    echo -e "${YELLOW}⚠️  Could not determine version from GitHub, using: ${CURRENT_VERSION}${NC}"
fi

echo -e "${BLUE}Current GitHub version: ${CURRENT_VERSION}${NC}"

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

# Get current date
DATE=$(date '+%Y-%m-%d')

# Prompt for changelog description
echo -e "${YELLOW}Enter a brief description of changes:${NC}"
read -p "> " USER_DESCRIPTION

if [ -z "$USER_DESCRIPTION" ]; then
    USER_DESCRIPTION="Version bump and maintenance updates"
fi

# Get recent local changes for reference
RECENT_CHANGES=$(git status --porcelain 2>/dev/null | head -5 | awk '{print "- " $2}' || echo "- General updates")

# Get current CHANGELOG from GitHub
echo -e "${BLUE}📡 Getting current CHANGELOG from GitHub...${NC}"
GITHUB_CHANGELOG=$(docker mcp tools call get_file_contents owner=$OWNER repo=$REPO path="CHANGELOG.md" 2>/dev/null || echo "")

# Prepare new CHANGELOG content
cat > NEW_CHANGELOG.md << EOF
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [${NEW_VERSION}] - ${DATE}

### Changes
- ${USER_DESCRIPTION}

### Modified
${RECENT_CHANGES}

EOF

# Append existing changelog content (skip header if it exists)
if [ -n "$GITHUB_CHANGELOG" ]; then
    echo "" >> NEW_CHANGELOG.md
    echo "$GITHUB_CHANGELOG" | tail -n +7 >> NEW_CHANGELOG.md
fi

echo -e "${GREEN}✅ Prepared new version files${NC}"

# Commit to GitHub via MCP
echo -e "${BLUE}📤 Committing to GitHub...${NC}"

# Get current SHAs from GitHub properly
echo "Getting current file SHAs from GitHub..."

# Get VERSION file SHA
VERSION_SHA_OUTPUT=$(docker mcp tools call get_file_contents owner=$OWNER repo=$REPO path="VERSION" 2>/dev/null)
VERSION_SHA=$(echo "$VERSION_SHA_OUTPUT" | grep -o 'SHA: [a-f0-9]\+' | cut -d' ' -f2)

# Get CHANGELOG file SHA
CHANGELOG_SHA_OUTPUT=$(docker mcp tools call get_file_contents owner=$OWNER repo=$REPO path="CHANGELOG.md" 2>/dev/null)
CHANGELOG_SHA=$(echo "$CHANGELOG_SHA_OUTPUT" | grep -o 'SHA: [a-f0-9]\+' | cut -d' ' -f2)

echo "VERSION SHA: $VERSION_SHA"
echo "CHANGELOG SHA: $CHANGELOG_SHA"

# Commit VERSION file to GitHub
echo "Pushing VERSION to GitHub..."
if [ -n "$VERSION_SHA" ]; then
    docker mcp tools call create_or_update_file \
        owner=$OWNER \
        repo=$REPO \
        branch=$BRANCH \
        path="VERSION" \
        message="Bump version to ${NEW_VERSION}" \
        content="$NEW_VERSION" \
        sha="$VERSION_SHA"
else
    docker mcp tools call create_or_update_file \
        owner=$OWNER \
        repo=$REPO \
        branch=$BRANCH \
        path="VERSION" \
        message="Bump version to ${NEW_VERSION}" \
        content="$NEW_VERSION"
fi

echo "VERSION update result: $?"

# Commit CHANGELOG file to GitHub
echo "Pushing CHANGELOG to GitHub..."
if [ -n "$CHANGELOG_SHA" ]; then
    docker mcp tools call create_or_update_file \
        owner=$OWNER \
        repo=$REPO \
        branch=$BRANCH \
        path="CHANGELOG.md" \
        message="Update changelog for version ${NEW_VERSION}" \
        content="$(cat NEW_CHANGELOG.md)" \
        sha="$CHANGELOG_SHA"
else
    docker mcp tools call create_or_update_file \
        owner=$OWNER \
        repo=$REPO \
        branch=$BRANCH \
        path="CHANGELOG.md" \
        message="Update changelog for version ${NEW_VERSION}" \
        content="$(cat NEW_CHANGELOG.md)"
fi

echo "CHANGELOG update result: $?"

# Update README version badge
echo "Updating README version badge..."

# Get README SHA using the same method as other files
README_SHA_OUTPUT=$(docker mcp tools call get_file_contents owner=$OWNER repo=$REPO path="README.md" 2>/dev/null)
README_SHA=$(echo "$README_SHA_OUTPUT" | grep -o 'SHA: [a-f0-9]\+' | cut -d' ' -f2)

echo "README SHA: $README_SHA"

if [ -n "$README_SHA" ]; then
    echo "Updating README version badge from ${CURRENT_VERSION} to ${NEW_VERSION}..."

    # Since parsing MCP output is complex, let's use the current local README as base
    # and just update the version badge
    if [ -f "README.md" ]; then
        # Update the local README version badge
        UPDATED_README_CONTENT=$(sed "s/version-[0-9]\+\.[0-9]\+\.[0-9]\+-blue/version-${NEW_VERSION}-blue/g" README.md)

        echo "Pushing updated README to GitHub..."

        docker mcp tools call create_or_update_file \
            owner=$OWNER \
            repo=$REPO \
            branch=$BRANCH \
            path="README.md" \
            message="Update version badge to ${NEW_VERSION}" \
            content="$UPDATED_README_CONTENT" \
            sha="$README_SHA"

        echo "✅ README version badge updated to ${NEW_VERSION}"
    else
        echo "⚠️ Local README.md not found, skipping badge update"
    fi
else
    echo "Could not get README SHA for version badge update"
fi

# Clean up temporary files
rm -f NEW_CHANGELOG.md

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