//! RE:ASSEMBLY WebAssembly Modules
//! 
//! High-performance computational kernels for consciousness computing,
//! designed to complement Julia backend services with client-side processing.

use wasm_bindgen::prelude::*;
use serde::{Deserialize, Serialize};

// Import JavaScript console for logging
#[wasm_bindgen]
extern "C" {
    #[wasm_bindgen(js_namespace = console)]
    fn log(s: &str);
}

// Logging macro for WASM
macro_rules! console_log {
    ($($t:tt)*) => (log(&format_args!($($t)*).to_string()))
}

/// Consciousness level definition matching Julia backend
#[wasm_bindgen]
#[derive(Debug, Clone, Copy, PartialEq, Serialize, Deserialize)]
pub enum ConsciousnessLevel {
    Alpha = 1,
    Beta = 2,
    Gamma = 3,
    Delta = 4,
    Omega = 5,
}

/// Pattern recognition result structure
#[wasm_bindgen]
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct PatternResult {
    strength: f64,
    pattern_count: usize,
    processing_time_ms: f64,
}

#[wasm_bindgen]
impl PatternResult {
    #[wasm_bindgen(getter)]
    pub fn strength(&self) -> f64 {
        self.strength
    }

    #[wasm_bindgen(getter)]
    pub fn pattern_count(&self) -> usize {
        self.pattern_count
    }

    #[wasm_bindgen(getter)]
    pub fn processing_time_ms(&self) -> f64 {
        self.processing_time_ms
    }
}

/// Initialize WASM module
#[wasm_bindgen(start)]
pub fn init() {
    console_log!("🚀 RE:ASSEMBLY WASM modules initialized");
    console_log!("🧠 Consciousness computing kernels loaded");
}

/// Calculate consciousness multiplier (matching Julia implementation)
#[wasm_bindgen]
pub fn calculate_consciousness_multiplier(level: u8) -> f64 {
    let level = level.clamp(1, 5);
    let base = 2.5_f64;
    base.powi((level - 1) as i32)
}

/// High-performance pattern recognition kernel
#[wasm_bindgen]
pub fn pattern_recognition_kernel(data: &[f64]) -> PatternResult {
    let start_time = web_sys::window()
        .and_then(|w| w.performance())
        .map(|p| p.now())
        .unwrap_or(0.0);

    if data.is_empty() {
        return PatternResult {
            strength: 0.0,
            pattern_count: 0,
            processing_time_ms: 0.0,
        };
    }

    // Calculate RMS (Root Mean Square) - matching Julia implementation
    let sum_squares: f64 = data.iter().map(|&x| x * x).sum();
    let rms = (sum_squares / data.len() as f64).sqrt();

    // Detect patterns
    let mut pattern_count = 0;

    // Check for monotonic increase
    let is_increasing = data.windows(2).all(|w| w[1] >= w[0]);
    if is_increasing { pattern_count += 1; }

    // Check for oscillation
    let sign_changes = data.windows(3)
        .filter(|w| {
            let diff1 = w[1] - w[0];
            let diff2 = w[2] - w[1];
            (diff1 > 0.0 && diff2 < 0.0) || (diff1 < 0.0 && diff2 > 0.0)
        })
        .count();
    
    if sign_changes > data.len() / 3 { pattern_count += 1; }

    // Check for low variance (stable pattern)
    let mean = data.iter().sum::<f64>() / data.len() as f64;
    let variance = data.iter()
        .map(|&x| (x - mean).powi(2))
        .sum::<f64>() / data.len() as f64;
    
    if variance < mean.abs() * 0.1 { pattern_count += 1; }

    let end_time = web_sys::window()
        .and_then(|w| w.performance())
        .map(|p| p.now())
        .unwrap_or(0.0);

    PatternResult {
        strength: rms,
        pattern_count,
        processing_time_ms: end_time - start_time,
    }
}

/// Fast Fibonacci calculation (iterative, stack-safe)
#[wasm_bindgen]
pub fn fibonacci_fast(n: u32) -> u64 {
    if n <= 1 {
        return n as u64;
    }

    let mut a = 0u64;
    let mut b = 1u64;

    for _ in 2..=n {
        let temp = a + b;
        a = b;
        b = temp;
    }

    b
}

/// Vector addition with scalar multiplication (a + scalar * b)
#[wasm_bindgen]
pub fn vector_add_scaled(a: &[f64], b: &[f64], scalar: f64) -> Vec<f64> {
    a.iter()
        .zip(b.iter())
        .map(|(&a_val, &b_val)| a_val + scalar * b_val)
        .collect()
}

/// Matrix multiplication for small matrices (up to 4x4)
#[wasm_bindgen]
pub fn matrix_multiply_4x4(a: &[f64], b: &[f64]) -> Vec<f64> {
    if a.len() != 16 || b.len() != 16 {
        console_log!("⚠️  Matrix multiplication requires 4x4 matrices (16 elements each)");
        return vec![0.0; 16];
    }

    let mut result = vec![0.0; 16];
    
    for i in 0..4 {
        for j in 0..4 {
            let mut sum = 0.0;
            for k in 0..4 {
                sum += a[i * 4 + k] * b[k * 4 + j];
            }
            result[i * 4 + j] = sum;
        }
    }
    
    result
}

/// Consciousness-enhanced computation (applies consciousness multiplier to result)
#[wasm_bindgen]
pub fn consciousness_enhanced_computation(data: &[f64], level: u8) -> f64 {
    let base_result = pattern_recognition_kernel(data).strength;
    let multiplier = calculate_consciousness_multiplier(level);
    
    console_log!("🧠 Consciousness Level {}: {}x multiplier", level, multiplier);
    
    base_result * multiplier
}

/// Benchmark WASM performance
#[wasm_bindgen]
pub fn benchmark_wasm_performance(iterations: u32) -> f64 {
    console_log!("⚡ Benchmarking WASM performance with {} iterations", iterations);
    
    let start_time = web_sys::window()
        .and_then(|w| w.performance())
        .map(|p| p.now())
        .unwrap_or(0.0);

    let test_data = vec![1.0, 4.0, 9.0, 16.0, 25.0, 36.0, 49.0, 64.0];
    
    for i in 0..iterations {
        let level = ((i % 5) + 1) as u8;
        consciousness_enhanced_computation(&test_data, level);
    }

    let end_time = web_sys::window()
        .and_then(|w| w.performance())
        .map(|p| p.now())
        .unwrap_or(0.0);

    let total_time = end_time - start_time;
    console_log!("✅ Benchmark completed: {}ms total", total_time);
    
    total_time
}

/// Get WASM module information
#[wasm_bindgen]
pub fn get_module_info() -> JsValue {
    let info = serde_json::json!({
        "module": "RE:ASSEMBLY WASM Modules",
        "version": "0.1.0",
        "capabilities": [
            "consciousness_multiplier_calculation",
            "pattern_recognition",
            "fibonacci_computation",
            "vector_operations",
            "matrix_multiplication",
            "performance_benchmarking"
        ],
        "consciousness_levels": [
            {"name": "Alpha", "level": 1, "multiplier": 1.0},
            {"name": "Beta", "level": 2, "multiplier": 2.5},
            {"name": "Gamma", "level": 3, "multiplier": 6.25},
            {"name": "Delta", "level": 4, "multiplier": 15.625},
            {"name": "Omega", "level": 5, "multiplier": 39.0625}
        ],
        "integration": {
            "julia_backend": "Via Genie.jl API calls",
            "typescript_client": "Direct WASM binding",
            "performance": "Optimized for client-side processing"
        }
    });

    serde_wasm_bindgen::to_value(&info).unwrap_or(JsValue::NULL)
}