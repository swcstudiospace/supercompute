"""
Claude Reasoning Agent - Systematic Analysis (Simplified Working Version)

This is a working agent example that demonstrates:
- RESTful API architecture
- Redis caching
- Problem analysis workflow
- Health checks

Note: This is a simplified demo version without external AI APIs.
For production integration with LangChain, see 00_IMPLEMENTATION_PATTERNS.md.
"""

import os
from flask import Flask, jsonify, request
import redis
import json
import hashlib

# Initialize Flask app
app = Flask(__name__)

# Configuration
REDIS_HOST = os.environ.get("REDIS_HOST", "redis")
REDIS_PORT = int(os.environ.get("REDIS_PORT", 6379))

# Initialize Redis connection
redis_client = redis.Redis(host=REDIS_HOST, port=REDIS_PORT, decode_responses=True)


# Reasoning template (simplified)
def analyze_problem_systematic(problem):
    """Systematic problem analysis with logical decomposition"""

    # Create analysis structure
    analysis = {
        "problem": problem,
        "composition": [],
        "logical_analysis": [],
        "conclusions": [],
        "recommendations": [],
        "confidence": 85.0,
    }

    # Step 1: Problem decomposition
    sentences = [s.strip() for s in problem.split(".") if s.strip()]
    analysis["composition"] = sentences
    analysis["components_identified"] = len(sentences)

    # Step 2: Logical analysis of components
    for i, sentence in enumerate(sentences, 1):
        component_analysis = {
            "component": i,
            "text": sentence,
            "complexity": "high"
            if len(sentence) > 50
            else "low"
            if len(sentence) < 20
            else "medium",
        }

        # Extract key terms
        words = sentence.lower().split()
        technical_terms = [
            "algorithm",
            "data",
            "system",
            "code",
            "function",
            "error",
            "test",
            "deploy",
        ]
        component_analysis["key_terms"] = [w for w in words if w in technical_terms]
        component_analysis["type"] = (
            "question"
            if "?" in sentence or "what" in sentence.lower()
            else "statement"
            if "is" in sentence
            else "imperative"
        )

        analysis["logical_analysis"].append(component_analysis)

    # Step 3: Generate conclusions
    analysis["conclusions"] = [
        "Problem decomposed into " + str(len(sentences)) + " components",
        "Identified "
        + str(sum(1 for c in analysis["logical_analysis"] if c["complexity"] == "high"))
        + " high-complexity components",
    ]

    # Step 4: Generate recommendations
    if len(analysis["logical_analysis"]) > 0:
        analysis["recommendations"] = [
            "Analyze each component independently",
            "Consider edge cases and error handling",
            "Validate assumptions with testing",
        ]
        analysis["confidence"] += 5.0

    return analysis


@app.route("/health", methods=["GET"])
def health_check():
    """Health check endpoint"""
    status = {
        "status": "healthy" if redis_client else "degraded",
        "agent_type": "claude-reasoning",
        "version": "1.0.0",
        "redis": "connected" if redis_client else "disconnected",
    }
    return jsonify(status)


@app.route("/analyze", methods=["POST"])
def analyze_problem():
    """Main analysis endpoint"""
    try:
        data = request.get_json()
        problem = data.get("problem")

        if not problem:
            return jsonify({"error": "No problem provided"}), 400

        # Check Redis cache first
        problem_hash = hashlib.md5(problem.encode()).hexdigest()
        cache_key = "analysis:" + problem_hash

        if redis_client:
            cached = redis_client.get(cache_key)
            if cached:
                return jsonify(json.loads(cached))

        # Run systematic analysis
        result = analyze_problem_systematic(problem)

        # Cache result for 5 minutes
        if redis_client:
            redis_client.setex(cache_key, 300, json.dumps(result))

        return jsonify(result)

    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route("/status", methods=["GET"])
def agent_status():
    """Get current agent status and metrics"""
    try:
        # Get total analysis count
        total_analysis = 0
        if redis_client:
            total_analysis = redis_client.incr("agent:claude:total_analysis") or 0

        # Get recent cache stats
        cache_size = 0
        if redis_client:
            cache_keys = redis_client.keys("analysis:*")
            cache_size = len(cache_keys)

        return jsonify(
            {
                "agent_type": "claude-reasoning",
                "total_analysis_performed": total_analysis,
                "cache_size": cache_size,
                "status": "operational",
                "dependencies": {
                    "redis": f"{REDIS_HOST}:{REDIS_PORT}",
                    "connected": redis_client is not None,
                },
            }
        )

    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route("/", methods=["GET"])
def index():
    """Root endpoint with API documentation"""
    return jsonify(
        {
            "service": "Claude Reasoning Agent",
            "version": "1.0.0",
            "endpoints": {
                "GET /health": "Health check",
                "GET /status": "Agent status and metrics",
                "POST /analyze": "Analyze problem systematically",
                "GET /": "API documentation",
            },
            "documentation": "Full API docs at /analyze endpoint",
            "note": "Simplified demo version - see 00_IMPLEMENTATION_PATTERNS.md for production LangChain integration",
        }
    )


if __name__ == "__main__":
    # Run on port 8000
    port = int(os.environ.get("PORT", 8000))
    debug = os.environ.get("DEBUG", "False").lower() == "true"
    app.run(host="0.0.0.0", port=port, debug=debug)
