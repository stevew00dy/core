# Memory Core

The **Memory Core** is the foundational component of the AI Development Environment that provides persistent contextual memory across chat sessions. It replaces Claude Code's ephemeral memory with a sophisticated, multi-layered memory system that remembers everything and learns from every interaction.

## 🧠 Architecture Overview

The Memory Core implements a **memory-first architecture** with four specialized engines:

```
┌─────────────────────────────────────────────────────────────┐
│                      Memory Core                             │
│                                                             │
│  ┌─────────────────┐    ┌─────────────────┐               │
│  │   Memory API    │    │ Context Builder │               │
│  │   (Router)      │◄──►│  (Enrichment)   │               │
│  └─────────────────┘    └─────────────────┘               │
│           │                       │                       │
│           │              ┌─────────────────┐              │
│           └──────────────►│ Memory Indexer  │              │
│                          │ (Processing)    │              │
│                          └─────────────────┘              │
│                                   │                       │
│    ┌──────────────────────────────┼──────────────────────┐│
│    │                              │                      ││
│ ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────────────┐││
│ │Session  │  │Project  │  │Semantic │  │    Personal     │││
│ │Memory   │  │Memory   │  │Memory   │  │    Memory       │││
│ │(Redis)  │  │(FalkorDB│  │(Qdrant) │  │(Qdrant+Postgres│││
│ └─────────┘  └─────────┘  └─────────┘  └─────────────────┘││
│                                                           ││
└───────────────────────────────────────────────────────────┘│
                                                             │
                       ┌─────────────────┐                  │
                       │   MCP Server    │◄─────────────────┘
                       │   (Protocol)    │
                       └─────────────────┘
```

## 🔧 Memory Engines

### 1. Session Memory (Redis)
- **Purpose**: Fast, ephemeral storage for current session context
- **Storage**: Redis key-value store with TTL
- **Data**: Conversation history, current files, temporary context
- **Lifespan**: 24 hours (configurable)

### 2. Project Memory (FalkorDB)
- **Purpose**: Graph-based project understanding and relationships
- **Storage**: FalkorDB graph database
- **Data**: Code structure, dependencies, architectural decisions
- **Relationships**: Files→Functions, Imports, Decision impacts

### 3. Semantic Memory (Qdrant)
- **Purpose**: Vector-based semantic search and similarity
- **Storage**: Qdrant vector database
- **Data**: Code snippets, concepts, patterns, documentation
- **Capabilities**: Similarity search, clustering, embeddings

### 4. Personal Memory (Hybrid)
- **Purpose**: User preferences, patterns, and learning progress
- **Storage**: Qdrant (vectors) + PostgreSQL (structured data)
- **Data**: Coding style, workflow preferences, skill development
- **Learning**: Adapts to user behavior and provides personalized suggestions

## 🚀 Quick Start

### 1. Installation

```bash
cd memory-core
npm install
```

### 2. Environment Configuration

Create `.env` file:

```bash
# Redis Configuration
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=
REDIS_DB=0
SESSION_TTL=86400

# FalkorDB Configuration
FALKOR_HOST=localhost
FALKOR_PORT=6379
FALKOR_PASSWORD=
FALKOR_DB=memory

# Qdrant Configuration
QDRANT_HOST=localhost
QDRANT_PORT=6333
QDRANT_API_KEY=
QDRANT_COLLECTION=memory
VECTOR_SIZE=768
QDRANT_DISTANCE=Cosine

# PostgreSQL Configuration
POSTGRES_HOST=localhost
POSTGRES_PORT=5432
POSTGRES_DB=memory
POSTGRES_USER=memory
POSTGRES_PASSWORD=

# Indexing Configuration
INDEXING_BATCH_SIZE=10
MAX_CONCURRENT_JOBS=3
ENABLE_REALTIME_INDEXING=true
EMBEDDING_MODEL=openai
CHUNK_SIZE=512
OVERLAP_SIZE=64
```

### 3. Database Setup

```bash
# Start databases with Docker
docker-compose up -d redis falkordb qdrant postgres

# Initialize databases
npm run setup-databases
```

### 4. Start Memory MCP Server

```bash
# Development mode
npm run dev

# Production mode
npm run build
npm start
```

## 🛠️ Usage Examples

### Store Session Context

```typescript
// Store current session state
await memoryRouter.query({
  type: 'session',
  target: 'session_123',
  operation: 'store_context',
  parameters: {
    context: {
      sessionId: 'session_123',
      userId: 'user_456',
      projectId: 'project_789',
      currentFile: '/src/components/Button.tsx',
      activeTask: 'Implementing dark mode toggle',
      conversationHistory: [...],
      timestamp: new Date()
    }
  }
});
```

### Index a File

```typescript
// Index file for semantic search and project understanding
const jobId = await memoryIndexer.indexFile(
  'project_789',
  '/src/components/Button.tsx',
  fileContent,
  'high'
);
```

### Search Similar Code

```typescript
// Find similar code patterns
const results = await memoryRouter.query({
  type: 'semantic',
  target: 'project_789',
  operation: 'find_similar_code',
  parameters: {
    codeSnippet: 'const handleClick = () => { ... }',
    language: 'typescript',
    limit: 5
  }
});
```

### Build Enriched Context

```typescript
// Build complete context for AI assistant
const context = await contextBuilder.buildContext({
  sessionId: 'session_123',
  userId: 'user_456',
  projectId: 'project_789',
  currentFile: '/src/components/Button.tsx',
  includeHistory: true,
  includeRelated: true
});

// Context includes:
// - Current session state
// - Project architecture
// - Related code patterns
// - User preferences
// - Relevant decisions
// - Learning opportunities
```

### Record User Interaction

```typescript
// Learn from user behavior
await memoryRouter.query({
  type: 'personal',
  target: 'user_456',
  operation: 'record_interaction',
  parameters: {
    interaction: {
      type: 'code_completion',
      context: { language: 'typescript', file_type: 'component' },
      outcome: 'success',
      feedback: 'Used suggested pattern',
      timestamp: new Date()
    }
  }
});
```

## 🔌 MCP Integration

The Memory Core exposes all functionality through MCP tools:

### Available Tools

- **Session Management**: `store_session_context`, `get_session_context`, `add_conversation_entry`
- **Project Memory**: `create_project`, `add_file_to_project`, `get_project_architecture`, `add_decision`
- **Semantic Search**: `store_semantic_document`, `search_similar`, `find_similar_code`
- **Personal Learning**: `create_user_profile`, `record_interaction`, `predict_preferences`
- **Context Building**: `build_context`
- **Indexing**: `index_file`, `index_conversation`, `get_indexing_status`
- **Statistics**: `get_memory_stats`

### MCP Configuration

Add to your MCP client configuration:

```json
{
  "mcpServers": {
    "memory": {
      "command": "node",
      "args": ["memory-core/mcp-server/server.ts"],
      "env": {
        "REDIS_HOST": "localhost",
        "QDRANT_HOST": "localhost"
      }
    }
  }
}
```

## 📊 Memory Schemas

The Memory Core uses structured schemas for consistent data storage:

- **[Code Context](schemas/code-context.json)**: File structure, dependencies, metrics
- **[Decision History](schemas/decision-history.json)**: Architectural decisions and outcomes
- **[User Patterns](schemas/user-patterns.json)**: Coding style, preferences, learning
- **[Project Evolution](schemas/project-evolution.json)**: Project history and growth

## 🔄 Memory Flow

1. **Input**: User interaction, code changes, decisions
2. **Indexing**: Real-time processing and storage across engines
3. **Context Building**: Enriched context assembly from all memory layers
4. **Learning**: Pattern extraction and user preference adaptation
5. **Retrieval**: Context-aware memory access for AI assistance

## 🎯 Key Features

- **Persistent Memory**: Never forgets across sessions
- **Multi-Modal Storage**: Optimized storage for different data types
- **Real-Time Indexing**: Immediate memory updates
- **Semantic Understanding**: Vector-based code and concept similarity
- **Personal Adaptation**: Learns and adapts to user patterns
- **Context Enrichment**: Builds comprehensive context for AI assistance
- **MCP Native**: Full Model Context Protocol integration

## 🚀 Future Enhancements

- **Distributed Memory**: Multi-node memory cluster support
- **Advanced Embeddings**: Custom code embedding models
- **Memory Compression**: Intelligent memory summarization
- **Cross-Project Learning**: Pattern transfer between projects
- **Collaborative Memory**: Shared team memory spaces
- **Memory Analytics**: Deep insights into development patterns

The Memory Core is the foundation that makes the AI Development Environment truly intelligent and contextually aware, enabling it to replace Claude Code with a system that genuinely remembers and learns from every interaction.