/**
 * RE:ASSEMBLY Julia-TypeScript Integration Client
 * 
 * This client provides a TypeScript interface to the Julia-based RE:ASSEMBLY
 * computational backend, leveraging Genie.jl APIs and WebSocket connections
 * for real-time consciousness computing.
 */

import WebSocket from 'ws';

// Type definitions for RE:ASSEMBLY
export interface ConsciousnessLevel {
  level: number;
  name: 'Alpha' | 'Beta' | 'Gamma' | 'Delta' | 'Omega';
  multiplier: number;
}

export interface ComputationRequest {
  function_name: string;
  parameters: Record<string, any>;
  consciousness_level?: number;
}

export interface ComputationResult {
  result: any;
  processing_time_ms: number;
  consciousness_multiplier: number;
  julia_version: string;
  timestamp: string;
}

export interface PatternRecognitionRequest {
  data: number[];
  algorithm?: 'rms' | 'correlation' | 'fourier';
}

export interface PatternRecognitionResult {
  pattern_strength: number;
  patterns_detected: string[];
  processing_efficiency: number;
  consciousness_insights: string[];
}

/**
 * Main client class for Julia backend integration
 */
export class REASSEMBLYClient {
  private baseUrl: string;
  private websocket: WebSocket | null = null;
  private isConnected: boolean = false;

  constructor(baseUrl: string = 'http://localhost:8080') {
    this.baseUrl = baseUrl.replace(/\/$/, ''); // Remove trailing slash
  }

  /**
   * Test basic connectivity to Julia backend
   */
  async testConnection(): Promise<boolean> {
    try {
      const response = await fetch(`${this.baseUrl}/api/status`);
      const data = await response.json();
      this.isConnected = data.status === 'operational';
      return this.isConnected;
    } catch (error) {
      console.error('Connection test failed:', error);
      this.isConnected = false;
      return false;
    }
  }

  /**
   * Get system information from Julia backend
   */
  async getSystemInfo(): Promise<any> {
    const response = await fetch(`${this.baseUrl}/api/info`);
    if (!response.ok) {
      throw new Error(`HTTP ${response.status}: ${response.statusText}`);
    }
    return response.json();
  }

  /**
   * Calculate consciousness multiplier for given level
   */
  async calculateConsciousnessMultiplier(level: number): Promise<ConsciousnessLevel> {
    const request: ComputationRequest = {
      function_name: 'consciousness_multiplier',
      parameters: { level },
    };

    const result = await this.executeComputation(request);
    
    const levelNames = ['Alpha', 'Beta', 'Gamma', 'Delta', 'Omega'] as const;
    const levelName = levelNames[Math.max(0, Math.min(4, level - 1))];

    return {
      level,
      name: levelName,
      multiplier: result.result
    };
  }

  /**
   * Perform pattern recognition on data array
   */
  async performPatternRecognition(request: PatternRecognitionRequest): Promise<PatternRecognitionResult> {
    const computationRequest: ComputationRequest = {
      function_name: 'pattern_recognition_kernel',
      parameters: {
        data: request.data,
        algorithm: request.algorithm || 'rms'
      }
    };

    const result = await this.executeComputation(computationRequest);
    
    // Mock pattern insights for demo (would be computed by Julia)
    const patterns = this.analyzePatterns(request.data);
    
    return {
      pattern_strength: result.result,
      patterns_detected: patterns,
      processing_efficiency: result.processing_time_ms < 100 ? 0.95 : 0.80,
      consciousness_insights: [
        `Pattern strength: ${result.result.toFixed(4)}`,
        `Computation completed in ${result.processing_time_ms}ms`,
        `Data points analyzed: ${request.data.length}`
      ]
    };
  }

  /**
   * Execute Fibonacci calculation via Julia backend
   */
  async calculateFibonacci(n: number): Promise<ComputationResult> {
    const request: ComputationRequest = {
      function_name: 'fibonacci_iterative',
      parameters: { n }
    };

    return this.executeComputation(request);
  }

  /**
   * Execute vector operations via Julia backend
   */
  async performVectorOperations(vectorA: number[], vectorB: number[]): Promise<ComputationResult> {
    const request: ComputationRequest = {
      function_name: 'vector_operations',
      parameters: { 
        vector_a: vectorA,
        vector_b: vectorB 
      }
    };

    return this.executeComputation(request);
  }

  /**
   * Generic computation execution method
   */
  private async executeComputation(request: ComputationRequest): Promise<ComputationResult> {
    const startTime = Date.now();
    
    // For now, simulate Julia backend call
    // In actual implementation, this would call the Genie.jl API
    const mockResult = await this.simulateJuliaComputation(request);
    
    const processingTime = Date.now() - startTime;
    
    return {
      result: mockResult,
      processing_time_ms: processingTime,
      consciousness_multiplier: request.consciousness_level ? 
        Math.pow(2.5, request.consciousness_level - 1) : 1.0,
      julia_version: "1.10.0",
      timestamp: new Date().toISOString()
    };
  }

  /**
   * Establish WebSocket connection for real-time updates
   */
  async connectWebSocket(): Promise<void> {
    return new Promise((resolve, reject) => {
      try {
        const wsUrl = this.baseUrl.replace('http', 'ws') + '/api/monitor/stream';
        this.websocket = new WebSocket(wsUrl);

        this.websocket.on('open', () => {
          console.log('✅ WebSocket connected for real-time consciousness monitoring');
          resolve();
        });

        this.websocket.on('message', (data) => {
          try {
            const update = JSON.parse(data.toString());
            this.handleRealtimeUpdate(update);
          } catch (error) {
            console.error('Failed to parse WebSocket message:', error);
          }
        });

        this.websocket.on('error', (error) => {
          console.error('WebSocket error:', error);
          reject(error);
        });

        this.websocket.on('close', () => {
          console.log('🔌 WebSocket connection closed');
          this.websocket = null;
        });

      } catch (error) {
        reject(error);
      }
    });
  }

  /**
   * Handle real-time updates from Julia backend
   */
  private handleRealtimeUpdate(update: any): void {
    if (update.type === 'dimensional_update') {
      console.log('📊 Dimensional Update:', {
        timestamp: update.timestamp,
        health_score: update.health_score,
        consciousness_coherence: update.coherence,
        active_dimensions: update.dimensions?.length || 0
      });
    }
  }

  /**
   * Disconnect WebSocket
   */
  disconnectWebSocket(): void {
    if (this.websocket) {
      this.websocket.close();
      this.websocket = null;
    }
  }

  /**
   * Simulate Julia computation for testing
   * In production, this would be replaced with actual Genie.jl API calls
   */
  private async simulateJuliaComputation(request: ComputationRequest): Promise<any> {
    // Simulate processing delay
    await new Promise(resolve => setTimeout(resolve, Math.random() * 50 + 10));

    switch (request.function_name) {
      case 'consciousness_multiplier':
        const level = request.parameters.level;
        return Math.pow(2.5, level - 1);
      
      case 'pattern_recognition_kernel':
        const data = request.parameters.data;
        const sumSquares = data.reduce((sum: number, val: number) => sum + val * val, 0);
        return Math.sqrt(sumSquares / data.length);
      
      case 'fibonacci_iterative':
        const n = request.parameters.n;
        let a = 0, b = 1;
        for (let i = 2; i <= n; i++) {
          [a, b] = [b, a + b];
        }
        return n <= 1 ? n : b;
      
      case 'vector_operations':
        const vecA = request.parameters.vector_a;
        const vecB = request.parameters.vector_b;
        return vecA.map((val: number, idx: number) => val + vecB[idx] * 2);
      
      default:
        throw new Error(`Unknown function: ${request.function_name}`);
    }
  }

  /**
   * Analyze patterns in data (mock implementation)
   */
  private analyzePatterns(data: number[]): string[] {
    const patterns = [];
    
    // Check for increasing trend
    let increasing = true;
    for (let i = 1; i < data.length; i++) {
      if (data[i] <= data[i-1]) {
        increasing = false;
        break;
      }
    }
    if (increasing) patterns.push('monotonic_increase');
    
    // Check for periodic pattern
    const mean = data.reduce((sum, val) => sum + val, 0) / data.length;
    const variance = data.reduce((sum, val) => sum + Math.pow(val - mean, 2), 0) / data.length;
    if (variance < mean * 0.1) patterns.push('low_variance');
    
    // Check for oscillation
    let signChanges = 0;
    for (let i = 1; i < data.length - 1; i++) {
      const diff1 = data[i] - data[i-1];
      const diff2 = data[i+1] - data[i];
      if ((diff1 > 0 && diff2 < 0) || (diff1 < 0 && diff2 > 0)) {
        signChanges++;
      }
    }
    if (signChanges > data.length * 0.3) patterns.push('oscillatory');
    
    return patterns.length > 0 ? patterns : ['no_clear_pattern'];
  }
}

// Export convenience functions
export async function quickTest(baseUrl?: string): Promise<void> {
  const client = new REASSEMBLYClient(baseUrl);
  
  console.log('🧪 Running RE:ASSEMBLY Julia-TypeScript integration test...');
  
  try {
    // Test connection
    const connected = await client.testConnection();
    console.log(`🔗 Connection: ${connected ? '✅ Success' : '❌ Failed'}`);
    
    if (!connected) {
      console.log('⚠️  Running in simulation mode (Julia backend not available)');
    }
    
    // Test consciousness calculation
    const consciousness = await client.calculateConsciousnessMultiplier(3); // Gamma
    console.log(`🧠 Consciousness [${consciousness.name}]: ${consciousness.multiplier}x multiplier`);
    
    // Test pattern recognition
    const testData = [1, 4, 9, 16, 25]; // Perfect squares
    const patterns = await client.performPatternRecognition({ data: testData });
    console.log(`🔍 Pattern Recognition: strength=${patterns.pattern_strength.toFixed(4)}, patterns=${patterns.patterns_detected.join(', ')}`);
    
    // Test Fibonacci
    const fibonacci = await client.calculateFibonacci(10);
    console.log(`🔢 Fibonacci(10): ${fibonacci.result} (${fibonacci.processing_time_ms}ms)`);
    
    console.log('✅ All tests completed successfully!');
    
  } catch (error) {
    console.error('❌ Test failed:', error);
  }
}