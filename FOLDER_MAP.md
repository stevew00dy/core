# 🗺️ Core Folder Map & Navigation Guide

## Quick Reference - Top Level Folders (13)

| 🏷️ Folder | 📝 Purpose | 🔗 Key Files/Subdirs |
|-----------|-----------|---------------------|
| 🛠️ **administration** | System admin, deployment, user mgmt | deployment/, support-tools/, system-administration/, user-management/ |
| 🤖 **agent-management** | Agent pool, debates, consensus | agent-pool/, agent-config/, debate-mgmt/, byzantine-consensus/ |
| 📊 **analytics-reports** | Performance, cost, quality analytics | performance/, cost/, quality/, custom-reports/ |
| 💻 **code-generation** | Code gen, templates, evaluation | new-generation/, history/, templates/, evaluation/ |
| ⚙️ **configuration** | System & agent settings | agent-settings/, system-settings/, integration-settings/, advanced-settings/ |
| 🏠 **dashboard** | Main UI, overview, quick actions | system-overview/, quick-actions/, performance-metrics/ |
| 📚 **documentation** | Guides, API docs, best practices | user-guide/, api-documentation/, architecture-docs/, best-practices/ |
| 👥 **human-review** | Review queue, approvals, feedback | review-queue/, approval-workflows/, feedback-system/ |
| 🧠 **memory-knowledge** | Graph DB, vector store, GraphRAG | **memory-core/**, graph-db/, vector-store/, graphrag/ |
| 📈 **monitoring-observability** | Health, APM, infrastructure | system-monitoring/, app-monitoring/, infrastructure/, alerting/ |
| 🛡️ **security-safety** | Security, safety controls, compliance | security-center/, safety-controls/, access-control/, compliance/ |
| 🔧 **tools-integration** | MCP servers, external tools | **ide-interface/**, mcp-servers/, external-tools/, dev-tools/ |
| 🔄 **workflows-automation** | Workflow design, Temporal, automation | workflow-designer/, active-workflows/, temporal-integration/, automation-rules/ |

---

## 🎯 Quick Navigation by Use Case

### 🚀 **Getting Started**
```
📚 documentation/user-guide/getting-started/
🏠 dashboard/quick-actions/
⚙️ configuration/system-settings/general-configuration/
```

### 👨‍💻 **Development Work**
```
💻 code-generation/new-generation/
🔧 tools-integration/ide-interface/
🔧 tools-integration/dev-tools/
📚 documentation/api-documentation/
```

### 🤖 **Agent Management**
```
🤖 agent-management/agent-pool/
🤖 agent-management/agent-config/
🤖 agent-management/debate-mgmt/
⚙️ configuration/agent-settings/
```

### 📊 **Monitoring & Analytics**
```
🏠 dashboard/system-overview/
📈 monitoring-observability/system-monitoring/
📊 analytics-reports/performance/
📊 analytics-reports/cost/
```

### 🛡️ **Security & Admin**
```
🛡️ security-safety/security-center/
🛠️ administration/system-administration/
🛠️ administration/user-management/
🛡️ security-safety/access-control/
```

---

## 📁 Detailed Folder Structure

### 🛠️ Administration
```
administration/
├── deployment/
│   ├── environment-config/
│   ├── blue-green-deploy/
│   ├── rollback-controls/
│   └── migration-tools/
├── support-tools/
│   ├── diagnostic-tools/
│   ├── debug-console/
│   ├── system-logs/
│   └── contact-support/
├── system-administration/
│   ├── backup-recovery/
│   ├── database-management/
│   ├── log-management/
│   └── system-updates/
└── user-management/
    ├── user-accounts/
    ├── teams-groups/
    ├── permissions/
    └── session-management/
```

### 🤖 Agent Management
```
agent-management/
├── agent-pool/
│   ├── view-all-agents/
│   ├── agent-status-monitor/
│   ├── performance-rankings/
│   └── agent-health-check/
├── agent-config/
│   ├── create-new-agent/
│   ├── edit-agent-parameters/
│   ├── model-selection/
│   ├── specialization-settings/
│   └── trust-scores/
├── debate-mgmt/
│   ├── active-debates/
│   ├── debate-history/
│   ├── consensus-tracking/
│   ├── configure-debate-rules/
│   └── socratic-templates/
└── byzantine-consensus/
    ├── consensus-settings/
    ├── voting-configuration/
    ├── malicious-agent-detection/
    └── geometric-median-config/
```

### 💻 Code Generation
```
code-generation/
├── new-generation/
│   ├── single-function/
│   ├── class-module/
│   ├── full-application/
│   ├── api-endpoint/
│   └── from-requirements/
├── history/
│   ├── recent-generations/
│   ├── successful-outputs/
│   ├── failed-attempts/
│   └── under-review/
├── templates/
│   ├── code-templates/
│   ├── design-patterns/
│   ├── architecture-blueprints/
│   └── custom-templates/
└── evaluation/
    ├── humaneval-tests/
    ├── mbpp-benchmarks/
    ├── custom-test-suites/
    ├── coverage-reports/
    └── performance-metrics/
```

### 🧠 Memory & Knowledge
```
memory-knowledge/
├── memory-core/          [MOVED FROM TOP LEVEL]
│   └── README.md         [Core memory system docs]
├── graph-db/
│   ├── view-knowledge-graph/
│   ├── agent-relationships/
│   ├── code-dependencies/
│   ├── query-interface/
│   └── graph-analytics/
├── vector-store/
│   ├── embedding-search/
│   ├── semantic-collections/
│   ├── index-management/
│   └── similarity-analysis/
├── graphrag/
│   ├── community-detection/
│   ├── hierarchical-summaries/
│   ├── knowledge-extraction/
│   └── rag-configuration/
└── cache-management/
    ├── semantic-cache/
    ├── response-cache/
    ├── cache-statistics/
    └── clear-cache/
```

### 🔧 Tools & Integration
```
tools-integration/
├── ide-interface/        [MOVED FROM TOP LEVEL]
│   ├── package.json      [React/Vite IDE interface]
│   ├── tsconfig.json
│   ├── vite.config.ts
│   └── src/             [IDE interface source code]
├── mcp-servers/
│   ├── connected-servers/
│   ├── tool-registry/
│   ├── add-new-server/
│   └── server-configuration/
├── external-tools/
│   ├── github-integration/
│   ├── file-system-access/
│   ├── database-connections/
│   └── api-integrations/
├── dev-tools/
│   ├── code-editor/
│   ├── terminal-access/
│   ├── debug-console/
│   └── log-viewer/
└── testing-tools/
    ├── test-runner/
    ├── sandbox-environment/
    ├── performance-profiler/
    └── security-scanner/
```

---

## 🔍 Finding What You Need

### 📝 **Want to...**

| **Task** | **Go to** |
|----------|-----------|
| Create new code | `code-generation/new-generation/` |
| Configure an agent | `agent-management/agent-config/` |
| Check system status | `dashboard/system-overview/` |
| Review generated code | `human-review/review-queue/` |
| Set up integrations | `tools-integration/mcp-servers/` |
| Monitor performance | `monitoring-observability/system-monitoring/` |
| Manage users | `administration/user-management/` |
| View documentation | `documentation/user-guide/` |
| Configure workflows | `workflows-automation/workflow-designer/` |
| Check security | `security-safety/security-center/` |
| Analyze costs | `analytics-reports/cost/` |
| Search knowledge | `memory-knowledge/vector-store/embedding-search/` |

### 🔧 **Configuration Files**
| **Type** | **Location** |
|----------|--------------|
| Agent settings | `configuration/agent-settings/` |
| System config | `configuration/system-settings/` |
| API keys | `configuration/integration-settings/authentication/` |
| Feature flags | `configuration/advanced-settings/feature-flags/` |
| IDE interface | `tools-integration/ide-interface/package.json` |

### 📊 **Monitoring & Logs**
| **Type** | **Location** |
|----------|--------------|
| System health | `monitoring-observability/system-monitoring/` |
| Performance metrics | `dashboard/performance-metrics/` |
| Error logs | `administration/support-tools/system-logs/` |
| Security audits | `security-safety/security-center/` |
| Cost analysis | `analytics-reports/cost/` |

---

## 🏷️ **Folder Color Coding**

- 🛠️ **Administration** - System management
- 🤖 **Agent Management** - AI agent controls
- 📊 **Analytics** - Reports and metrics
- 💻 **Code Generation** - Core functionality
- ⚙️ **Configuration** - Settings and config
- 🏠 **Dashboard** - Main interface
- 📚 **Documentation** - Guides and docs
- 👥 **Human Review** - Human oversight
- 🧠 **Memory/Knowledge** - Data storage
- 📈 **Monitoring** - System observability
- 🛡️ **Security/Safety** - Protection systems
- 🔧 **Tools/Integration** - External tools
- 🔄 **Workflows** - Process automation

---

## 🚨 **Important Notes**

1. **Moved Folders**:
   - `ide-interface` → `tools-integration/ide-interface/`
   - `memory-core` → `memory-knowledge/memory-core/`

2. **Key Entry Points**:
   - Start with: `dashboard/` for overview
   - Development: `code-generation/` and `tools-integration/`
   - Admin: `administration/` and `configuration/`

3. **Documentation**: Always check `documentation/` for detailed guides

4. **Configuration**: Most settings are in `configuration/` hierarchy

This map should help you navigate the 13 top-level folders and their ~200+ subdirectories efficiently!