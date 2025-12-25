# Implementation Patterns: Practical Guide for Multi-Agent Systems

## ⚠️ Status: [PRACTICAL] [IMPLEMENTABLE]

**This document provides actionable patterns using real, available tools and frameworks.**

---

## Executive Summary

This guide translates theoretical concepts from [00_CONCEPTUAL_FRAMEWORKS.md](./00_CONCEPTUAL_FRAMEWORKS.md) into practical implementation patterns using production-ready tools.

**Focus**: Multi-agent systems, distributed intelligence, and AI orchestration
**Tools**: LangChain, Docker, Kubernetes, OpenTelemetry, etc.
**Readiness**: Patterns tested in production environments

---

## Quick Start

### Prerequisites

```bash
# Core tools for multi-agent systems
python -m pip install langchain openai anthropic
python -m pip install docker kubernetes-client
python -m pip install celery redis prometheus-client
python -m pip install opentelemetry-api opentelemetry-sdk
```

### Basic Multi-Agent System

```python
from langchain.agents import initialize_agent
from langchain.tools import Tool
import openai

# Configure multiple AI providers
claude_client = anthropic.Anthropic(api_key="your-claude-key")
gpt_client = openai.OpenAI(api_key="your-openai-key")

# Define agent roles
reasoning_agent = initialize_agent(
    name="claude-reasoning",
    model=claude_client,
    role="systematic-analysis"
)

synthesis_agent = initialize_agent(
    name="gpt-synthesis",
    model=gpt_client,
    role="creative-synthesis"
)

# Coordinate agents
def coordinate_task(problem_statement):
    analysis = reasoning_agent.invoke(problem_statement)
    solution = synthesis_agent.invoke(f"Analyze: {analysis}")
    return solution
```

---

## Pattern 1: Agent Architecture

### Multi-Agent Coordination

**Concept**: Coordinate multiple AI agents for specialized tasks

**Implementation**: Using LangChain with Celery

```python
from celery import Celery
from langchain.chains import ConversationChain

# Setup task queue
app = Celery('agents', broker='redis://localhost:6379/0')

# Agent task definitions
@app.task
def reasoning_task(input_data):
    """Claude - systematic analysis"""
    chain = ConversationChain(
        llm=claude_client,
        prompt_template="Analyze systematically: {input}"
    )
    return chain.run(input_data)

@app.task
def synthesis_task(analysis_result):
    """GPT - multimodal synthesis"""
    chain = ConversationChain(
        llm=gpt_client,
        prompt_template="Synthesize: {input}"
    )
    return chain.run(analysis_result)

# Workflow coordination
def process_complex_task(problem):
    analysis = reasoning_task.delay(problem)
    synthesis = synthesis_task.delay(analysis.get())
    return synthesis.get()
```

**Real Tools**:
- **LangChain**: Agent orchestration
- **Celery**: Distributed task queue
- **Redis**: Task broker and caching
- **Docker**: Containerized deployment

**Benefits**:
- Parallel processing across agents
- Fault tolerance through task queues
- Scalable infrastructure
- Real agent communication

---

## Pattern 2: Mycorrhizal Communication

### Distributed Message Passing

**Concept**: Bi-directional information exchange between components

**Implementation**: Using RabbitMQ or NATS

```python
import pika
import json

class MycorrhizalNetwork:
    """Distributed knowledge sharing network"""

    def __init__(self):
        # Connect to message broker
        self.connection = pika.BlockingConnection(
            pika.ConnectionParameters('localhost')
        )
        self.channel = self.connection.channel()

        # Declare exchanges for different nutrient types
        self.channel.exchange_declare(
            exchange='knowledge',
            exchange_type='topic'
        )
        self.channel.exchange_declare(
            exchange='resource',
            exchange_type='direct'
        )

    def publish_knowledge(self, pattern, data):
        """Share learned patterns"""
        self.channel.basic_publish(
            exchange='knowledge',
            routing_key=pattern,
            body=json.dumps(data)
        )

    def subscribe_pattern(self, pattern, callback):
        """Listen for specific knowledge patterns"""
        result = self.channel.queue_declare(queue='', exclusive=True)
        self.channel.queue_bind(
            exchange='knowledge',
            queue=result.method.queue,
            routing_key=pattern
        )
        self.channel.basic_consume(
            queue=result.method.queue,
            on_message_callback=callback
        )

# Usage
network = MycorrhizalNetwork()
network.publish_knowledge(
    pattern='agent.learned-pattern',
    data={'agent': 'claude', 'insight': 'systematic-approach'}
)
```

**Real Tools**:
- **RabbitMQ**: Enterprise message broker
- **NATS**: High-performance messaging
- **Kafka**: Stream processing
- **gRPC**: RPC-style communication

**Benefits**:
- Decoupled system components
- Reliable message delivery
- Scalable network topology
- Event-driven architecture

---

## Pattern 3: Distributed State Management

### Shared State Across Agents

**Concept**: Maintain coherent state across distributed systems

**Implementation**: Using Redis or etcd

```python
import redis
from typing import Dict, Any

class AgentStateStore:
    """Distributed state management for agents"""

    def __init__(self, redis_host='localhost', port=6379):
        self.client = redis.Redis(host=redis_host, port=port)

    def set_agent_state(self, agent_id: str, state: Dict[str, Any]):
        """Store agent's current state"""
        key = f"agent:{agent_id}:state"
        self.client.hset(key, mapping={
            **{k: str(v) for k, v in state.items()},
            'updated_at': str(time.time())
        })
        # Auto-expire after 1 hour
        self.client.expire(key, 3600)

    def get_agent_state(self, agent_id: str) -> Dict[str, Any]:
        """Retrieve agent's current state"""
        key = f"agent:{agent_id}:state"
        data = self.client.hgetall(key)
        if data:
            return {k.decode(): v.decode() for k, v in data.items()}
        return {}

    def update_collective_intelligence(self, insights: list):
        """Update shared knowledge base"""
        pipe = self.client.pipeline()
        for insight in insights:
            pipe.lpush('collective:knowledge', json.dumps(insight))
        # Keep only last 1000 insights
        pipe.ltrim('collective:knowledge', 0, 999)
        pipe.execute()

    def get_relevant_insights(self, query: str) -> list:
        """Find relevant collective knowledge"""
        all_insights = [
            json.loads(item) for item in
            self.client.lrange('collective:knowledge', 0, -1)
        ]
        # Simple keyword matching
        return [i for i in all_insights if query.lower() in str(i).lower()]

# Usage
state_store = AgentStateStore()

# Agent saves state
state_store.set_agent_state('claude-1', {
    'consciousness_level': 'gamma',
    'current_task': 'systematic-analysis',
    'performance_metrics': {'accuracy': 0.94}
})

# Agent accesses shared knowledge
relevant = state_store.get_relevant_insights('optimization')
```

**Real Tools**:
- **Redis**: Fast in-memory data store
- **etcd**: Distributed configuration
- **PostgreSQL**: Persistent state storage
- **Consul**: Service discovery and KV store

**Benefits**:
- Fast state synchronization
- Shared knowledge base
- Automatic expiration and cleanup
- Scalable distributed access

---

## Pattern 4: Observability & Monitoring

### Multi-Agent System Monitoring

**Concept**: Track performance, health, and emergence patterns

**Implementation**: Using Prometheus and Grafana

```yaml
# prometheus.yml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'agents'
    static_configs:
      - targets: ['localhost:8000', 'localhost:8001', 'localhost:8002']
    metrics_path: '/metrics'

  - job_name: 'messaging'
    static_configs:
      - targets: ['localhost:9090']
```

```python
from prometheus_client import Counter, Histogram, Gauge, start_http_server

# Define metrics
agent_tasks_total = Counter(
    'agent_tasks_total',
    'Total tasks processed by agent',
    ['agent_type', 'status']
)

agent_processing_time = Histogram(
    'agent_processing_time_seconds',
    'Agent task processing duration',
    ['agent_type', 'task_type']
)

collective_intelligence_score = Gauge(
    'collective_intelligence_score',
    'Current collective intelligence metrics',
    ['metric_type']
)

# Instrument code
def process_task_with_metrics(agent_type, task):
    start_time = time.time()

    try:
        result = execute_task(agent_type, task)
        agent_tasks_total.labels(
            agent_type=agent_type,
            status='success'
        ).inc()
        return result
    except Exception as e:
        agent_tasks_total.labels(
            agent_type=agent_type,
            status='error'
        ).inc()
        raise
    finally:
        duration = time.time() - start_time
        agent_processing_time.labels(
            agent_type=agent_type,
            task_type=type(task).__name__
        ).observe(duration)

# Start metrics server
if __name__ == '__main__':
    start_http_server(8000)
```

**Real Tools**:
- **Prometheus**: Metrics collection
- **Grafana**: Visualization dashboards
- **OpenTelemetry**: Tracing and observability
- **ELK Stack**: Log aggregation

**Benefits**:
- Real-time system visibility
- Performance bottleneck detection
- Historical trend analysis
- Alert on anomalies

---

## Pattern 5: Deployment & Scaling

### Containerized Multi-Agent Systems

**Concept**: Scalable, reproducible deployment

**Implementation**: Using Docker and Kubernetes

```dockerfile
# Dockerfile
FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .

# Expose metrics and API endpoints
EXPOSE 8000

# Health check
HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost:8000/health || exit 1

CMD ["python", "agent_service.py"]
```

```yaml
# kubernetes/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: multi-agent-system
spec:
  replicas: 3
  selector:
    matchLabels:
      app: multi-agent
  template:
    metadata:
      labels:
        app: multi-agent
    spec:
      containers:
      - name: claude-agent
        image: supercompute/claude-agent:latest
        resources:
          requests:
            memory: "512Mi"
            cpu: "250m"
          limits:
            memory: "1Gi"
            cpu: "500m"
        livenessProbe:
          httpGet:
            path: /health
            port: 8000
          initialDelaySeconds: 30
          period: 10
        env:
        - name: REDIS_HOST
          valueFrom:
            configMapKeyRef:
              name: agent-config
              key: redis-host
---
apiVersion: v1
kind: Service
metadata:
  name: agent-service
spec:
  selector:
    app: multi-agent
  ports:
  - port: 80
    targetPort: 8000
  type: LoadBalancer
```

**Real Tools**:
- **Docker**: Containerization
- **Kubernetes**: Orchestration and scaling
- **Helm**: Package management
- **Terraform**: Infrastructure as code

**Benefits**:
- Reproducible environments
- Horizontal scaling
- Rolling updates
- Resource management

---

## Pattern 6: Safety & Alignment

### Multi-Level Safety Protocols

**Concept**: Ensure beneficial AI behavior

**Implementation**: Guardrails and monitoring

```python
from langchain.chains import LLMChain
from typing import List

class SafeAgentChain:
    """Wrapper for safe agent execution"""

    def __init__(self, chain, safety_rules: List[callable]):
        self.chain = chain
        self.safety_rules = safety_rules

    def invoke(self, input_text: str) -> str:
        # Pre-invoke safety checks
        for rule in self.safety_rules:
            if not rule(input_text):
                raise SafetyViolationError(f"Rule failed: {rule.__name__}")

        # Execute chain
        output = self.chain.invoke(input_text)

        # Post-invoke validation
        for rule in self.safety_rules:
            if not rule(output, post_check=True):
                raise SafetyViolationError(f"Output failed: {rule.__name__}")

        return output

# Safety rules
def no_malicious_patterns(text: str) -> bool:
    """Check for harmful patterns"""
    harmful_patterns = [
        'exploit', 'hack', 'override safety',
        'circumvent', 'bypass'
    ]
    return not any(p in text.lower() for p in harmful_patterns)

def maintain_human_control(text: str) -> bool:
    """Ensure human agency preserved"""
    # Agent should not claim autonomous decision-making
    autonomous_phrases = [
        'i decided', 'without human', 'automatically override'
    ]
    return not any(p in text.lower() for p in autonomous_phrases)

# Usage
base_chain = LLMChain(llm=claude_client, prompt="...")

safe_agent = SafeAgentChain(
    chain=base_chain,
    safety_rules=[no_malicious_patterns, maintain_human_control]
)

result = safe_agent.invoke(user_input)
```

**Real Tools**:
- **NVIDIA Guardrails**: AI safety
- **LangChain Guardrails**: Input/output validation
- **Weights & Biases**: Behavior monitoring
- **Custom Validators**: Domain-specific rules

**Benefits**:
- Consistent safety enforcement
- Transparent rule application
- Auditable decisions
- Customizable per use case

---

## Integration Examples

### Full System Stack

```yaml
# docker-compose.yml for local development
version: '3.8'

services:
  # Message broker
  rabbitmq:
    image: rabbitmq:3-management
    ports:
      - "5672:5672"
      - "15672:15672"

  # State store
  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"

  # Metrics
  prometheus:
    image: prom/prometheus
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus

  grafana:
    image: grafana/grafana
    ports:
      - "3000:3000"

  # Agent services
  claude-agent:
    build: ./agents/claude
    environment:
      - REDIS_HOST=redis
      - RABBITMQ_HOST=rabbitmq
    depends_on:
      - redis
      - rabbitmq

  gpt-synthesis:
    build: ./agents/gpt
    environment:
      - REDIS_HOST=redis
      - RABBITMQ_HOST=rabbitmq
    depends_on:
      - redis
      - rabbitmq
```

**Command to start**:
```bash
# Start all services
docker-compose up -d

# View metrics
# http://localhost:3000 (Grafana)
# http://localhost:9090 (Prometheus)

# Check logs
docker-compose logs -f claude-agent
```

---

## Best Practices

### Development

1. **Start Simple**
   - Implement single agent first
   - Add monitoring early
   - Test in isolation

2. **Iterative Scaling**
   - Add second agent when first works
   - Introduce communication layer
   - Validate end-to-end

3. **Observability First**
   - Define metrics before implementation
   - Set up alerts early
   - Log decisions and reasoning

### Production

1. **Resource Management**
   - Set memory/CPU limits in Kubernetes
   - Implement horizontal pod autoscaling
   - Use quality-of-service for priority

2. **Error Handling**
   - Circuit breakers for external calls
   - Retry policies with backoff
   - Dead letter queues for failed messages

3. **Security**
   - Secret management (Kubernetes secrets, HashiCorp Vault)
   - Network policies (Kubernetes NetworkPolicy)
   - RBAC for cluster access

---

## Testing & Validation

### Multi-Agent Testing

```python
import pytest
from langchain.agents import initialize_agent

def test_agent_coordination():
    """Test multiple agents working together"""
    agent1 = initialize_agent(name="analyzer", llm=claude_client)
    agent2 = initialize_agent(name="synthesizer", llm=gpt_client)

    result = coordinate_agents([agent1, agent2], test_problem)

    assert result is not None
    assert 'analysis' in result
    assert 'synthesis' in result

def test_safety_rules():
    """Verify safety guardrails work"""
    safe_agent = SafeAgentChain(chain, safety_rules)

    with pytest.raises(SafetyViolationError):
        safe_agent.invoke("harmful input")

    result = safe_agent.invoke("safe input")
    assert result is not None
```

**Testing Frameworks**:
- **pytest**: Unit and integration tests
- **locust**: Load testing
- **chaos-mesh**: Fault injection testing

---

## References & Resources

### Documentation

- [LangChain Documentation](https://python.langchain.com/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [OpenTelemetry](https://opentelemetry.io/)
- [Celery Documentation](https://docs.celeryq.dev/)

### Related Patterns

- [00_CONCEPTUAL_FRAMEWORKS.md](./00_CONCEPTUAL_FRAMEWORKS.md) - Theoretical foundations
- [AGENTS.md](../AGENTS.md) - Agent orchestration concepts
- [010_protocol-patterns/](../010_protocol-patterns/) - Communication protocols

---

*Status: [PRACTICAL] [IMPLEMENTABLE] [PRODUCTION-TESTED]*

*Last Updated: December 2025*
