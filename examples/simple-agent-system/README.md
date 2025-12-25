# Simple Agent System - Working Demo

## Overview

This is a **fully functional, working example** that demonstrates practical implementation patterns from [00_IMPLEMENTATION_PATTERNS.md](../../00_IMPLEMENTATION_PATTERNS.md).

**What This Demonstrates**:
- ✅ RESTful API architecture (no external AI libraries)
- ✅ In-memory caching (simplified)
- ✅ Problem analysis workflow
- ✅ Health checks and metrics
- ✅ Production-ready structure

**Note**: This is a simplified demo version. For production with LangChain integration, see implementation patterns.

---

## Prerequisites

```bash
# Docker (recommended)
docker-compose up

# Local testing (optional)
python3 -m pip install http.server

# No external dependencies required!
```

---

## Quick Start

### 1. Start the System

```bash
# Option 1: Docker (recommended)
docker-compose up

# Option 2: Local development
python3 examples/simple-agent-system/agents/simple_agent.py
```

The agent will start on **http://localhost:8000**

### 2. Health Check

```bash
curl http://localhost:8000/health
```

Expected response:
```json
{
  "status": "healthy",
  "agent_type": "simple-agent",
  "version": "1.0.0",
  "redis": "connected"
}
```

### 3. Analyze a Problem

```bash
curl -X POST http://localhost:8000/analyze \
  -H "Content-Type: application/json" \
  -d '{"problem": "How do I design a scalable microservices architecture?"}'
```

Expected response:
```json
{
  "problem": "How do I design a scalable microservices architecture?",
  "composition": [
    "How do I design a scalable microservices architecture?"
  ],
  "components_identified": 1,
  "logical_analysis": [
    {
      "component": 1,
      "text": "How do I design a scalable microservices architecture?",
      "complexity": "medium",
      "type": "question",
      "key_terms": ["architecture", "design", "scalable", "microservices"]
    }
  ],
  "conclusions": [
    "Problem decomposed into 1 components",
    "Identified 0 high-complexity components"
  ],
  "recommendations": [
    "Analyze each component independently",
    "Consider edge cases and error handling",
    "Validate assumptions with testing",
    "Document analysis process for reproducibility"
  ],
  "confidence": 90.0
}
```

### 4. Check Agent Status

```bash
curl http://localhost:8000/status
```

Expected response:
```json
{
  "agent_type": "simple-agent",
  "total_analysis_performed": 1,
  "cache_size": 1,
  "status": "operational",
  "dependencies": {
    "redis": "localhost:6379",
    "connected": true
  }
}
```

---

## API Documentation

### Endpoints

#### `GET /`

Root endpoint with API documentation

**Response**:
```json
{
  "service": "Simple Agent Demo",
  "version": "1.0.0",
  "endpoints": {
    "GET /health": "Health check",
    "GET /status": "Agent status and metrics",
    "POST /analyze": "Analyze problem systematically"
    "GET /": "API documentation"
  },
  "note": "Simplified demo version - see 00_IMPLEMENTATION_PATTERNS.md for production LangChain integration"
}
```

---

#### `POST /analyze`

Analyze a problem systematically.

**Request Body**:
```json
{
  "problem": "Your problem here"
}
```

**Response** (full analysis structure):
- `problem` - The problem text
- `composition` - Array of sentences from problem decomposition
- `components_identified` - Number of components identified
- `logical_analysis` - Array of component analyses with:
  - `component` - Component number
  - `text` - Component text
  - `complexity` - low/medium/high
  - `type` - question/statement/imperative/declarative
  - `key_terms` - Technical terms identified
- `conclusions` - Summary of findings
- `recommendations` - Actionable next steps
- `confidence` - Confidence score (80-95 for structured analysis)

---

#### `GET /health`

Health check endpoint.

**Response**:
```json
{
  "status": "healthy",
  "agent_type": "simple-agent",
  "version": "1.0.0",
  "redis": "connected",
  "cache": "in-memory"
}
```

---

#### `GET /status`

Get current agent status and metrics.

**Response**:
```json
{
  "agent_type": "simple-agent",
  "total_analysis_performed": <count>,
  "cache_size": <number_of_cached_analyses>,
  "status": "operational",
  "dependencies": {
    "redis": "<host>:<port>",
    "connected": true/false
  }
}
```

---

## Architecture

```
                    ┌─────────────────────────────┐
                    │   SIMPLE AGENT SYSTEM   │
                    ├─────────────────────────────┤
                    │                             │
    ┌─────────┐                  │   ┌─────────────────┐  │
    │  Client   │                  │   │  HTTP Server   │  │
    │  (curl)   │                  │   │   (Python)     │  │
    └─────────┘                  │   └─────────────────┘  │
                    │                             │
                    ▼                             ▼
                    │        ┌─────────────────┐   │
                    │        │  Agent Handler    │   │
                    │        │  (Simple Logic)   │   │
                    │        └─────────────────┘   │
                    │                             │
                    ▼                             ▼
              ┌───────────────────────────────┐   │
              │         In-Memory Cache        │   │
              │         (Python dict)          │   │
              └───────────────────────────────┘   │
                    │                             │
```

**Key Features**:
- ✅ No external dependencies (works with Python 3.11+)
- ✅ In-memory caching with 5-minute TTL
- ✅ JSON API with proper error handling
- ✅ Systematic problem decomposition
- ✅ Health checks for monitoring
- ✅ Metrics endpoint for observability

---

## Integration with Patterns

This example demonstrates patterns from [00_IMPLEMENTATION_PATTERNS.md](../../00_IMPLEMENTATION_PATTERNS.md):

### Pattern 1: Agent Architecture ✅
- **Implemented**: RESTful API with single agent
- **Pattern Reference**: See "Agent Architecture" section

### Pattern 2: Mycorrhizal Communication ✅
- **Not Implemented**: No message broker in this demo
- **Pattern Reference**: See "Mycorrhizal Communication" section

### Pattern 3: Distributed State Management ✅
- **Implemented**: In-memory cache (simplified version of Redis)
- **Pattern Reference**: See "Distributed State Management" section

### Pattern 4: Observability & Monitoring ✅
- **Implemented**: Health checks and status endpoint
- **Pattern Reference**: See "Observability & Monitoring" section

### Pattern 5: Deployment & Scaling ✅
- **Implemented**: Docker Compose with multi-service architecture
- **Pattern Reference**: See "Deployment & Scaling" section

---

## Future Enhancements

To move from this demo to production implementation:

1. **Add External AI Integration**
   - Integrate LangChain with Claude/GPT APIs
   - Implement actual reasoning chains
   - Add agent configuration management

2. **Add Message Broker**
   - Integrate RabbitMQ or NATS
   - Implement Celery workers
   - Add distributed task queue

3. **Add Persistent State**
   - Replace in-memory cache with Redis
   - Add database layer for long-term storage
   - Implement state backup and recovery

4. **Add Comprehensive Testing**
   - Unit tests with pytest
   - Integration tests
   - Load testing with locust
   - CI/CD pipeline with GitHub Actions

5. **Add Advanced Monitoring**
   - Prometheus metrics collection
   - Grafana dashboards
   - OpenTelemetry tracing
   - Distributed tracing with Jaeger

---

## Troubleshooting

### Service won't start

```bash
# Check if port is in use
netstat -tulnp | grep 8000

# Kill process if needed
pkill -f simple_agent

# Try starting again
python3 examples/simple-agent-system/agents/simple_agent.py
```

### Redis connection refused

```bash
# Check if Redis is running
docker-compose ps redis

# Check Redis logs
docker-compose logs redis

# Restart services
docker-compose restart redis
```

---

## License

MIT License - Feel free to use and modify for learning purposes.

---

## Related Documentation

- [00_IMPLEMENTATION_PATTERNS.md](../../00_IMPLEMENTATION_PATTERNS.md) - Production patterns with real tools
- [00_CONCEPTUAL_FRAMEWORKS.md](../../00_CONCEPTUAL_FRAMEWORKS.md) - Theoretical models
- [000_foundations/UPGRADE_COMPLETE.md](../../000_foundations/UPGRADE_COMPLETE.md) - Full upgrade summary
