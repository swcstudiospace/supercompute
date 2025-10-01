#!/usr/bin/env node
/**
 * RE:ASSEMBLY Julia-TypeScript Integration Demo
 * 
 * This demo showcases the integration between TypeScript frontend
 * and Julia backend computational services.
 */

import { REASSEMBLYClient, quickTest } from './index';

async function runFullDemo() {
  console.log('🚀 RE:ASSEMBLY Julia-TypeScript Integration Demo');
  console.log('=' .repeat(60));
  
  const client = new REASSEMBLYClient();
  
  try {
    // Basic connectivity test
    console.log('\n🔗 Testing Julia Backend Connectivity...');
    const connected = await client.testConnection();
    
    if (connected) {
      console.log('✅ Connected to Julia/Genie.jl backend');
      
      // Get system information
      const systemInfo = await client.getSystemInfo();
      console.log('📊 System Info:');
      console.log(`   Framework: ${systemInfo.web_framework}`);
      console.log(`   Language: ${systemInfo.language}`);
      console.log(`   Architecture: ${systemInfo.architecture}`);
    } else {
      console.log('⚠️  Julia backend not available - running in simulation mode');
    }
    
    // Consciousness Level Testing
    console.log('\n🧠 Testing Consciousness Multipliers...');
    for (let level = 1; level <= 5; level++) {
      const consciousness = await client.calculateConsciousnessMultiplier(level);
      console.log(`   Level ${level} [${consciousness.name}]: ${consciousness.multiplier.toFixed(4)}x`);
    }
    
    // Pattern Recognition Demo
    console.log('\n🔍 Testing Pattern Recognition...');
    
    const testCases = [
      { name: 'Perfect Squares', data: [1, 4, 9, 16, 25, 36] },
      { name: 'Fibonacci Sequence', data: [1, 1, 2, 3, 5, 8, 13] },
      { name: 'Random Data', data: [3.2, 1.8, 4.7, 2.1, 5.9, 1.3] },
      { name: 'Oscillating', data: [1, -1, 2, -2, 3, -3, 4] }
    ];
    
    for (const testCase of testCases) {
      const result = await client.performPatternRecognition({ data: testCase.data });
      console.log(`   ${testCase.name}:`);
      console.log(`     Strength: ${result.pattern_strength.toFixed(4)}`);
      console.log(`     Patterns: ${result.patterns_detected.join(', ')}`);
      console.log(`     Efficiency: ${(result.processing_efficiency * 100).toFixed(1)}%`);
    }
    
    // Mathematical Operations Demo
    console.log('\n🔢 Testing Mathematical Operations...');
    
    // Fibonacci calculations
    const fibonacciTests = [5, 10, 15, 20];
    for (const n of fibonacciTests) {
      const result = await client.calculateFibonacci(n);
      console.log(`   Fibonacci(${n}): ${result.result} (${result.processing_time_ms}ms)`);
    }
    
    // Vector operations
    const vectorA = [1, 2, 3, 4];
    const vectorB = [5, 6, 7, 8];
    const vectorResult = await client.performVectorOperations(vectorA, vectorB);
    console.log(`   Vector ops [${vectorA}] + 2*[${vectorB}]: [${vectorResult.result}]`);
    
    // Performance Benchmarking
    console.log('\n⚡ Performance Benchmarking...');
    
    const benchmarkStart = Date.now();
    const iterations = 100;
    
    for (let i = 0; i < iterations; i++) {
      await client.calculateConsciousnessMultiplier((i % 5) + 1);
    }
    
    const benchmarkTime = Date.now() - benchmarkStart;
    const avgTime = benchmarkTime / iterations;
    
    console.log(`   ${iterations} consciousness calculations: ${benchmarkTime}ms total`);
    console.log(`   Average per calculation: ${avgTime.toFixed(2)}ms`);
    console.log(`   Operations per second: ${(1000 / avgTime).toFixed(0)}`);
    
    // WebSocket Demo (if connected)
    if (connected) {
      console.log('\n🌊 Testing Real-Time WebSocket Connection...');
      try {
        await client.connectWebSocket();
        console.log('✅ WebSocket connected - monitoring consciousness updates...');
        
        // Let it run for a few seconds to show updates
        await new Promise(resolve => setTimeout(resolve, 3000));
        
        client.disconnectWebSocket();
        console.log('🔌 WebSocket disconnected');
      } catch (error) {
        console.log('⚠️  WebSocket connection failed:', error.message);
      }
    }
    
    // Integration Recommendations
    console.log('\n💡 Integration Recommendations:');
    console.log('   ✓ Use API-first approach for immediate implementation');
    console.log('   ✓ Leverage existing Genie.jl web framework');
    console.log('   ✓ WebSocket for real-time consciousness monitoring');
    console.log('   ✓ Reserve WASM compilation for performance-critical kernels');
    console.log('   ✓ Validate each integration point before adding complexity');
    
    console.log('\n🎉 Demo completed successfully!');
    console.log('🔗 Ready for RE:ASSEMBLY framework integration');
    
  } catch (error) {
    console.error('❌ Demo failed:', error);
    process.exit(1);
  }
}

// Command line interface
if (require.main === module) {
  const args = process.argv.slice(2);
  
  if (args.includes('--quick')) {
    quickTest().catch(console.error);
  } else {
    runFullDemo().catch(console.error);
  }
}

export { runFullDemo };