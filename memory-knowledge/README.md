# Memory & Knowledge

The Memory & Knowledge system provides persistent, contextual memory that spans sessions, projects, and conversations. It combines graph databases, vector stores, and advanced RAG (Retrieval-Augmented Generation) techniques to create a comprehensive knowledge management system for the Multi-Agent AGI platform.

**This system integrates the complete memory-core implementation**, providing a production-ready memory system with four specialized engines, comprehensive APIs, and MCP integration.

## Overview

Memory & Knowledge is organized into four main components:
- **graph-database/**: FalkorDB-based graph relationships and dependencies
- **vector-store/**: Qdrant-based semantic search and similarity matching
- **graphrag-system/**: Advanced knowledge extraction and hierarchical summaries
- **cache-management/**: Multi-layer caching for optimal performance

## Integrated Memory Core Architecture

The system implements a **memory-first architecture** with four specialized engines:

```
┌─────────────────────────────────────────────────────────────┐
│                 Memory & Knowledge System                    │
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

## Memory Engines

### 1. Session Memory (Redis)
**Location**: `engines/session-memory/`
- **Purpose**: Fast, ephemeral storage for current session context
- **Storage**: Redis key-value store with TTL
- **Data**: Conversation history, current files, temporary context
- **Lifespan**: 24 hours (configurable)

### 2. Project Memory (FalkorDB)
**Location**: `engines/project-memory/`
- **Purpose**: Graph-based project understanding and relationships
- **Storage**: FalkorDB graph database
- **Data**: Code structure, dependencies, architectural decisions
- **Relationships**: Files→Functions, Imports, Decision impacts

### 3. Semantic Memory (Qdrant)
**Location**: `engines/semantic-memory/`
- **Purpose**: Vector-based semantic search and similarity
- **Storage**: Qdrant vector database
- **Data**: Code snippets, concepts, patterns, documentation
- **Capabilities**: Similarity search, clustering, embeddings

### 4. Personal Memory (Hybrid)
**Location**: `engines/personal-memory/`
- **Purpose**: User preferences, patterns, and learning progress
- **Storage**: Qdrant (vectors) + PostgreSQL (structured data)
- **Data**: Coding style, workflow preferences, skill development
- **Learning**: Adapts to user behavior and provides personalized suggestions

## Core APIs

### Memory Router
**Location**: `api/memory-router.ts`

Unified API for accessing all memory engines:

```typescript
class MemoryRouter {
  async query(memoryQuery: MemoryQuery): Promise<MemoryResponse>;
  async getMemoryStatistics(): Promise<MemoryStats>;
  async shutdown(): Promise<void>;
}
```

### Context Builder
**Location**: `api/context-builder.ts`

Builds enriched context from all memory sources:

```typescript
class ContextBuilder {
  async buildContext(request: ContextRequest): Promise<EnrichedContext>;
  async streamContext(request: ContextRequest): AsyncGenerator<Partial<EnrichedContext>>;
  async cacheContext(context: EnrichedContext, ttl?: number): Promise<void>;
}
```

### Memory Indexer
**Location**: `api/memory-indexer.ts`

Real-time indexing of files, conversations, and decisions:

```typescript
class MemoryIndexer {
  async indexFile(projectId: string, filePath: string, content: string): Promise<string>;
  async indexConversation(sessionId: string, userId: string, history: any[]): Promise<string>;
  async indexDecision(projectId: string, decisionData: any): Promise<string>;
}
```

## MCP Integration

**Location**: `mcp-server/server.ts`

Complete MCP server with 25+ tools:

### Available Tools

- **Session Management**: `store_session_context`, `get_session_context`, `add_conversation_entry`
- **Project Memory**: `create_project`, `add_file_to_project`, `get_project_architecture`, `add_decision`
- **Semantic Search**: `store_semantic_document`, `search_similar`, `find_similar_code`
- **Personal Learning**: `create_user_profile`, `record_interaction`, `predict_preferences`
- **Context Building**: `build_context`
- **Indexing**: `index_file`, `index_conversation`, `get_indexing_status`
- **Statistics**: `get_memory_stats`

### MCP Configuration

```json
{
  "mcpServers": {
    "memory": {
      "command": "node",
      "args": ["memory-knowledge/mcp-server/server.ts"],
      "env": {
        "REDIS_HOST": "localhost",
        "QDRANT_HOST": "localhost"
      }
    }
  }
}
```

## Data Schemas

**Location**: `schemas/`

Structured schemas for consistent data storage:

- **[code-context.json](schemas/code-context.json)**: File structure, dependencies, metrics
- **[decision-history.json](schemas/decision-history.json)**: Architectural decisions and outcomes
- **[user-patterns.json](schemas/user-patterns.json)**: Coding style, preferences, learning
- **[project-evolution.json](schemas/project-evolution.json)**: Project history and growth

## Quick Start

### 1. Installation

```bash
cd memory-knowledge
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

## Usage Examples

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

## Advanced Features

### GraphRAG Integration
- **Community Detection**: Identify clusters of related concepts and code patterns
- **Hierarchical Summaries**: Create multi-level summaries of complex information
- **Knowledge Extraction**: Automatically extract key insights from code and conversations
- **Contextual Generation**: Use retrieved knowledge to enhance AI responses

### Intelligent Caching
- **Semantic Cache**: Cache semantically similar queries and responses
- **Response Cache**: Store frequently accessed responses for quick retrieval
- **Adaptive Expiration**: Intelligent cache invalidation based on content relevance
- **Performance Optimization**: Multi-tier caching for optimal response times

### Memory Flow

1. **Input**: User interaction, code changes, decisions
2. **Indexing**: Real-time processing and storage across engines
3. **Context Building**: Enriched context assembly from all memory layers
4. **Learning**: Pattern extraction and user preference adaptation
5. **Retrieval**: Context-aware memory access for AI assistance

## Key Features

- **Persistent Memory**: Never forgets across sessions
- **Multi-Modal Storage**: Optimized storage for different data types
- **Real-Time Indexing**: Immediate memory updates
- **Semantic Understanding**: Vector-based code and concept similarity
- **Personal Adaptation**: Learns and adapts to user patterns
- **Context Enrichment**: Builds comprehensive context for AI assistance
- **MCP Native**: Full Model Context Protocol integration

## Integration Points

### Agent Management Integration
- **Agent Knowledge**: Store agent interactions and learning progress
- **Collaboration Patterns**: Track successful agent collaboration patterns
- **Trust Relationships**: Map trust relationships between agents
- **Performance History**: Store agent performance data for analysis

### Code Generation Integration
- **Pattern Storage**: Store successful code generation patterns
- **Template Evolution**: Track template usage and effectiveness
- **Quality Feedback**: Store quality assessments and improvement suggestions
- **Reusability Analysis**: Identify reusable code components

### Dashboard Integration
- **Memory Insights**: Provide real-time memory system status
- **Knowledge Visualization**: Display knowledge graphs and relationships
- **Performance Metrics**: Memory system performance and health metrics
- **User Analytics**: Track user knowledge acquisition and preferences

## Related Components

- **dashboard/**: Visualizes knowledge graphs and memory insights
- **agent-management/**: Stores agent interactions and collaboration patterns
- **code-generation/**: Provides context for code generation and stores patterns
- **analytics-reports/**: Analyzes knowledge growth and usage patterns
- **human-review/**: Incorporates human feedback into knowledge base

The Memory & Knowledge system serves as the cognitive foundation of the Multi-Agent AGI System, enabling persistent learning, context awareness, and intelligent knowledge synthesis across all system components.