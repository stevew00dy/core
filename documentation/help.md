# 📚 Multi-Agent AGI System - Help Guide

## 🚀 Quick Start Commands

### Essential Commands
```bash
# Start MCP Gateway (required for GitHub operations)
docker mcp gateway run

# Commit changes with version bump
./commit patch           # Bug fixes (1.0.1 → 1.0.2)
./commit minor           # New features (1.0.1 → 1.1.0)
./commit major           # Breaking changes (1.0.1 → 2.0.0)
./commit                 # Interactive mode

# Navigate the project structure
cat FOLDER_MAP.md        # Complete folder navigation guide
```

---

## 🔧 Commit Command Reference

### Basic Usage
```bash
# Interactive commit (prompts for version type and description)
./commit

# Direct version bump with prompts for description
./commit patch
./commit minor
./commit major
```

### What the Commit Command Does
1. **🔍 Reads current version** from GitHub repository
2. **📈 Bumps version** according to semantic versioning
3. **📝 Updates CHANGELOG.md** with your description and recent changes
4. **🏷️ Updates README version badge** automatically
5. **🚀 Pushes directly to GitHub** via MCP (no local git needed)
6. **✅ Shows completion summary** with new version

### Version Numbering (Semantic Versioning)
- **MAJOR.MINOR.PATCH** (e.g., 2.1.3)
- **PATCH** (x.x.1): Bug fixes, documentation updates, small changes
- **MINOR** (x.1.x): New features, backwards compatible additions
- **MAJOR** (1.x.x): Breaking changes, incompatible API changes

### Example Workflow
```bash
# 1. Make your changes to files
# 2. Run commit command
./commit patch

# Output:
# 🚀 Starting automated GitHub commit process...
# 📡 Getting current version from GitHub...
# Current GitHub version: 1.0.2
# New version: 1.0.3
# Enter a brief description of changes:
# > Fix README badge auto-update functionality
# ✅ VERSION file updated on GitHub
# ✅ CHANGELOG.md updated on GitHub
# ✅ README version badge updated to 1.0.3
```

---

## 📁 Project Structure

### Top-Level Folders (13)
```
Core/
├── 🛠️ administration/           # System admin, deployment, user management
├── 🤖 agent-management/         # AI agent orchestration and control
├── 📊 analytics-reports/        # Performance insights and reporting
├── 💻 code-generation/          # Core code generation functionality
├── ⚙️ configuration/            # System and agent settings
├── 🏠 dashboard/                # Main UI and command center
├── 📚 documentation/            # Comprehensive guides (you are here!)
├── 👥 human-review/             # Human oversight workflows
├── 🧠 memory-knowledge/         # Persistent memory and knowledge base
├── 📈 monitoring-observability/ # System health and performance tracking
├── 🛡️ security-safety/         # Enterprise security and safety controls
├── 🔧 tools-integration/        # External tools and MCP integrations
└── 🔄 workflows-automation/     # Process orchestration and automation
```

### Important Files
```
Core/
├── VERSION                      # Current version number
├── CHANGELOG.md                 # Version history and changes
├── FOLDER_MAP.md               # Detailed navigation guide
├── README.md                   # Project overview with badges
└── CLAUDE.md                   # Claude Code startup instructions
```

---

## 🐳 Docker MCP Commands

### Gateway Management
```bash
# Start MCP gateway (required for GitHub operations)
docker mcp gateway run

# List available MCP tools
docker mcp tools list

# Check MCP server status
docker ps | grep mcp
```

### GitHub Integration via MCP
```bash
# Manual file operations (advanced users)
docker mcp tools call get_file_contents owner=USERNAME repo=REPO path="FILE"
docker mcp tools call create_or_update_file owner=USERNAME repo=REPO branch=main path="FILE" message="MESSAGE" content="CONTENT"
docker mcp tools call list_commits owner=USERNAME repo=REPO
```

---

## 🗺️ Navigation & Discovery

### Finding Things
```bash
# Use the folder map for navigation
cat FOLDER_MAP.md

# Search for specific functionality
grep -r "function_name" .
find . -name "*.md" | grep topic

# View recent changes
cat CHANGELOG.md | head -20
```

### Key Locations
| **Need** | **Go To** |
|----------|-----------|
| 📝 Commit changes | `./commit` |
| 🗺️ Navigate folders | `FOLDER_MAP.md` |
| 📋 See what's changed | `CHANGELOG.md` |
| 🔧 GitHub tools | `tools-integration/external-tools/github/` |
| 📚 Documentation | `documentation/` |
| ⚙️ Configuration | `configuration/` |
| 🤖 Agent settings | `agent-management/` |

---

## 🛠️ Development Workflows

### Making Changes
1. **Edit files** as needed
2. **Test changes** if applicable
3. **Run commit** with appropriate version bump:
   ```bash
   ./commit patch    # For bug fixes
   ./commit minor    # For new features
   ./commit major    # For breaking changes
   ```

### Release Process
1. **Complete your changes**
2. **Update documentation** if needed
3. **Run commit** with descriptive message
4. **Check GitHub** for successful updates
5. **Verify version badges** are updated

### Troubleshooting
```bash
# If commit fails, check MCP gateway
docker mcp gateway run

# Check if containers are running
docker ps

# View recent GitHub commits
docker mcp tools call list_commits owner=stevew00dy repo=core

# Manual version check
cat VERSION
```

---

## 📖 Documentation Resources

### Available Guides
```
documentation/
├── help.md                     # This file - general help
├── user-guide/                 # Detailed usage instructions
├── api-documentation/          # API references
├── architecture-docs/          # System design documentation
├── best-practices/             # Recommended approaches
├── final-overview.md           # Complete system architecture
└── research-paper.md           # Technical research details
```

### External Tools Documentation
```
tools-integration/external-tools/github/
├── commit.sh                   # Automated commit script
├── mcp-github-push-process.md  # MCP GitHub integration guide
└── release-management.md       # Complete versioning workflow
```

---

## ⚡ Quick Reference

### Daily Commands
```bash
# Start working
docker mcp gateway run

# Make changes to files
# ...

# Commit with auto-versioning
./commit patch

# Navigate project
cat FOLDER_MAP.md
```

### Emergency Commands
```bash
# Stop all containers
docker stop $(docker ps -q)

# Restart MCP gateway
docker mcp gateway run

# Check system status
docker ps
git status
```

### File Locations
- **Scripts**: `tools-integration/external-tools/github/`
- **Docs**: `documentation/`
- **Config**: `configuration/`
- **Navigation**: `FOLDER_MAP.md`

---

## 🆘 Getting Help

### Self-Help Resources
1. **FOLDER_MAP.md** - Complete project navigation
2. **CHANGELOG.md** - Recent changes and version history
3. **README.md** - Project overview and current status
4. **documentation/** - Comprehensive guides and references

### Command Help
```bash
# Commit command help
./commit --help

# MCP tools help
docker mcp --help
docker mcp tools --help

# Docker help
docker --help
```

### Useful Information
- **Current Version**: Check `VERSION` file or README badge
- **GitHub Repository**: https://github.com/stevew00dy/core
- **Project Structure**: See `FOLDER_MAP.md` for complete navigation
- **Recent Changes**: Check `CHANGELOG.md` for version history

---

## 💡 Tips & Best Practices

### Commit Best Practices
- Use **descriptive commit messages** that explain the "why"
- Choose appropriate **version bump types**:
  - patch: Small fixes, typos, minor improvements
  - minor: New features, enhancements, non-breaking additions
  - major: Breaking changes, API changes, architectural shifts

### Project Organization
- Follow the **13-folder structure** for consistency
- Use **FOLDER_MAP.md** to understand where things belong
- Keep **documentation updated** when making significant changes

### Workflow Efficiency
- **Start MCP gateway first** before any GitHub operations
- Use **./commit** for all version updates (don't manual edit VERSION)
- Check **CHANGELOG.md** to see what others have been working on

---

*Last updated: Version 1.0.2*
*For more detailed information, see the documentation/ folder structure above.*