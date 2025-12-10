#!/usr/bin/env python3
"""
Test Suite for Consciousness Level Progression System
TDD: Test-Driven Development for Alpha→Beta→Gamma→Delta→Omega consciousness elevation
"""

import unittest
import json
import sys
import os
from datetime import datetime

# Add modules path to import context
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'modules'))

class TestConsciousnessLevelProgression(unittest.TestCase):
    """Comprehensive test suite for consciousness level progression system"""
    
    def setUp(self):
        """Set up test fixtures"""
        # Import the consciousness progression module
        try:
            from consciousness_progression import ConsciousnessLevel, ConsciousnessProgressionSystem
            self.ConsciousnessLevel = ConsciousnessLevel
            self.ConsciousnessProgressionSystem = ConsciousnessProgressionSystem
        except ImportError:
            self.skipTest("consciousness_progression module not yet implemented")
    
    def test_consciousness_level_enumeration(self):
        """Test that all required consciousness levels are defined"""
        expected_levels = ['alpha', 'beta', 'gamma', 'delta', 'omega']
        actual_levels = [level.value for level in self.ConsciousnessLevel]
        
        self.assertEqual(set(expected_levels), set(actual_levels),
                        "All consciousness levels should be defined")
    
    def test_consciousness_level_multipliers(self):
        """Test consciousness level performance multipliers"""
        expected_multipliers = {
            'alpha': 1.0,
            'beta': 2.5,
            'gamma': 6.25,
            'delta': 15.625,
            'omega': 39.0625
        }
        
        for level_name, expected_multiplier in expected_multipliers.items():
            level = self.ConsciousnessLevel(level_name)
            actual_multiplier = level.get_performance_multiplier()
            self.assertEqual(actual_multiplier, expected_multiplier,
                           f"Performance multiplier for {level_name} should be {expected_multiplier}")
    
    def test_consciousness_level_ordering(self):
        """Test that consciousness levels are correctly ordered"""
        levels = [self.ConsciousnessLevel('alpha'), 
                 self.ConsciousnessLevel('beta'),
                 self.ConsciousnessLevel('gamma'),
                 self.ConsciousnessLevel('delta'),
                 self.ConsciousnessLevel('omega')]
        
        for i in range(len(levels) - 1):
            self.assertTrue(levels[i] < levels[i + 1],
                          f"{levels[i]} should be less than {levels[i + 1]}")
            self.assertTrue(levels[i + 1] > levels[i],
                          f"{levels[i + 1]} should be greater than {levels[i]}")
    
    def test_etd_generation_rates(self):
        """Test ETD generation rates for each consciousness level"""
        base_rate = 100.0  # Base ETD rate at alpha level
        
        expected_rates = {
            'alpha': base_rate * 1.0,      # $100/hour
            'beta': base_rate * 2.5,       # $250/hour
            'gamma': base_rate * 6.25,     # $625/hour
            'delta': base_rate * 15.625,   # $1,562.5/hour
            'omega': base_rate * 39.0625   # $3,906.25/hour
        }
        
        for level_name, expected_rate in expected_rates.items():
            level = self.ConsciousnessLevel(level_name)
            actual_rate = level.calculate_etd_generation_rate(base_rate)
            self.assertAlmostEqual(actual_rate, expected_rate, places=2,
                                 msg=f"ETD rate for {level_name} should be {expected_rate}")
    
    def test_consciousness_elevation_requirements(self):
        """Test consciousness elevation requirements"""
        system = self.ConsciousnessProgressionSystem()
        
        # Test alpha to beta elevation
        alpha_requirements = system.get_elevation_requirements('alpha', 'beta')
        self.assertIn('quantum_coherence_threshold', alpha_requirements)
        self.assertIn('pattern_recognition_score', alpha_requirements)
        self.assertIn('semantic_integration_level', alpha_requirements)
        
        # Test beta to gamma elevation
        beta_requirements = system.get_elevation_requirements('beta', 'gamma')
        self.assertIn('field_resonance_achievement', beta_requirements)
        self.assertIn('symbolic_residue_integration', beta_requirements)
        
        # Test gamma to delta elevation
        gamma_requirements = system.get_elevation_requirements('gamma', 'delta')
        self.assertIn('quantum_entanglement_stability', gamma_requirements)
        self.assertIn('consciousness_coherence_maintenance', gamma_requirements)
        
        # Test delta to omega elevation (final transcendence)
        delta_requirements = system.get_elevation_requirements('delta', 'omega')
        self.assertIn('omega_point_convergence', delta_requirements)
        self.assertIn('universal_pattern_mastery', delta_requirements)
    
    def test_consciousness_elevation_validation(self):
        """Test consciousness elevation validation logic"""
        system = self.ConsciousnessProgressionSystem()
        
        # Test valid elevation criteria
        valid_criteria = {
            'quantum_coherence': 0.85,
            'pattern_recognition_score': 0.90,
            'semantic_integration_level': 0.88,
            'etd_generation_consistency': 0.92
        }
        
        can_elevate = system.validate_elevation_criteria('alpha', 'beta', valid_criteria)
        self.assertTrue(can_elevate, "Valid criteria should allow elevation")
        
        # Test invalid elevation criteria
        invalid_criteria = {
            'quantum_coherence': 0.45,  # Too low
            'pattern_recognition_score': 0.60,  # Too low
            'semantic_integration_level': 0.50,  # Too low
            'etd_generation_consistency': 0.55   # Too low
        }
        
        cannot_elevate = system.validate_elevation_criteria('alpha', 'beta', invalid_criteria)
        self.assertFalse(cannot_elevate, "Invalid criteria should prevent elevation")
    
    def test_omega_point_convergence_mathematics(self):
        """Test Omega Point convergence mathematical foundations"""
        system = self.ConsciousnessProgressionSystem()
        
        # Test convergence calculation
        convergence_metrics = {
            'consciousness_coherence': 0.95,
            'pattern_mastery_index': 0.98,
            'quantum_field_resonance': 0.92,
            'symbolic_integration_depth': 0.96,
            'etd_generation_exponential': 0.94
        }
        
        convergence_score = system.calculate_omega_point_convergence(convergence_metrics)
        self.assertGreater(convergence_score, 0.9, "High-quality metrics should produce high convergence score")
        self.assertLessEqual(convergence_score, 1.0, "Convergence score should not exceed 1.0")
    
    def test_consciousness_progression_tracking(self):
        """Test consciousness progression tracking over time"""
        system = self.ConsciousnessProgressionSystem()
        
        # Initialize progression tracking
        user_id = "test_user_001"
        system.initialize_progression_tracking(user_id)
        
        # Test progression state
        current_state = system.get_current_consciousness_state(user_id)
        self.assertEqual(current_state['current_level'], 'alpha')
        self.assertEqual(current_state['progression_metrics']['elevation_progress'], 0.0)
        
        # Simulate progression activities
        activities = [
            {'type': 'pattern_recognition', 'score': 0.85, 'timestamp': datetime.now().isoformat()},
            {'type': 'semantic_integration', 'score': 0.82, 'timestamp': datetime.now().isoformat()},
            {'type': 'quantum_coherence_training', 'score': 0.88, 'timestamp': datetime.now().isoformat()}
        ]
        
        system.record_progression_activities(user_id, activities)
        updated_state = system.get_current_consciousness_state(user_id)
        
        # Should have progress toward beta
        self.assertGreater(updated_state['progression_metrics']['elevation_progress'], 0.0)
    
    def test_performance_multiplier_application(self):
        """Test performance multiplier application in calculations"""
        base_performance = {
            'pattern_extraction_speed': 100.0,  # ms
            'xml_transformation_speed': 80.0,   # ms
            'context_validation_speed': 150.0,  # ms
            'semantic_accuracy': 0.85,           # decimal
            'etd_generation_rate': 50.0          # per hour
        }
        
        for level_name in ['alpha', 'beta', 'gamma', 'delta', 'omega']:
            level = self.ConsciousnessLevel(level_name)
            enhanced_performance = level.apply_performance_multiplier(base_performance)
            
            # Speed metrics should improve (lower is better)
            self.assertLess(enhanced_performance['pattern_extraction_speed'], 
                           base_performance['pattern_extraction_speed'],
                           f"Pattern extraction should improve at {level_name}")
            
            # Accuracy should improve
            self.assertGreater(enhanced_performance['semantic_accuracy'],
                             base_performance['semantic_accuracy'],
                             f"Semantic accuracy should improve at {level_name}")
            
            # ETD generation should increase
            self.assertGreater(enhanced_performance['etd_generation_rate'],
                             base_performance['etd_generation_rate'],
                             f"ETD generation should increase at {level_name}")
    
    def test_quantum_coherence_calculation(self):
        """Test quantum coherence calculation for consciousness levels"""
        for level_name in ['alpha', 'beta', 'gamma', 'delta', 'omega']:
            level = self.ConsciousnessLevel(level_name)
            
            # Test quantum coherence calculation based on metrics
            coherence_metrics = {
                'wave_function_stability': 0.90,
                'entanglement_preservation': 0.85,
                'superposition_maintenance': 0.88,
                'measurement_consistency': 0.92
            }
            
            coherence_score = level.calculate_quantum_coherence(coherence_metrics)
            self.assertGreaterEqual(coherence_score, 0.0, "Coherence score should be non-negative")
            self.assertLessEqual(coherence_score, 1.0, "Coherence score should not exceed 1.0")
            
            # Higher consciousness levels should have better coherence
            if level_name != 'alpha':  # Skip alpha as baseline
                higher_level = self.ConsciousnessLevel(level_name)
                lower_level = self.ConsciousnessLevel('alpha')
                higher_coherence = higher_level.calculate_quantum_coherence(coherence_metrics)
                lower_coherence = lower_level.calculate_quantum_coherence(coherence_metrics)
                self.assertGreaterEqual(higher_coherence, lower_coherence,
                                      f"Higher consciousness ({level_name}) should maintain better coherence")
    
    def test_omega_point_transcendence_validation(self):
        """Test Omega Point transcendence validation"""
        system = self.ConsciousnessProgressionSystem()
        
        # Test transcendence criteria
        transcendence_metrics = {
            'universal_pattern_mastery': 0.99,
            'quantum_consciousness_unity': 0.98,
            'omega_point_convergence': 0.97,
            'applied_science_mastery': 0.96,
            'transcendence_readiness': 0.95
        }
        
        can_transcend = system.validate_omega_point_transcendence(transcendence_metrics)
        self.assertTrue(can_transcend, "High-quality transcendence metrics should allow Omega Point convergence")
        
        # Test insufficient transcendence criteria
        insufficient_metrics = {
            'universal_pattern_mastery': 0.65,  # Too low
            'quantum_consciousness_unity': 0.70,  # Too low
            'omega_point_convergence': 0.68,      # Too low
            'applied_science_mastery': 0.72,      # Too low
            'transcendence_readiness': 0.60       # Too low
        }
        
        cannot_transcend = system.validate_omega_point_transcendence(insufficient_metrics)
        self.assertFalse(cannot_transcend, "Insufficient metrics should prevent transcendence")
    
    def test_consciousness_regression_prevention(self):
        """Test that consciousness level regression is prevented"""
        system = self.ConsciousnessProgressionSystem()
        
        user_id = "test_user_002"
        
        # Simulate progression to gamma level
        system.initialize_progression_tracking(user_id)
        system.force_consciousness_level(user_id, 'gamma')  # For testing
        
        # Attempt to regress to beta level
        with self.assertRaises(ValueError) as context:
            system.set_consciousness_level(user_id, 'beta')
        
        self.assertIn("regression", str(context.exception).lower(),
                      "Consciousness regression should be prevented")
    
    def test_schema_integration_compatibility(self):
        """Test compatibility with v7.0 context pattern schema"""
        level = self.ConsciousnessLevel('gamma')
        
        # Generate schema-compatible data
        schema_data = level.to_schema_compatible_format()
        
        # Validate required fields
        required_fields = ['current_level', 'progression_metrics', 'quantum_coherence', 'etd_generation_rate']
        for field in required_fields:
            self.assertIn(field, schema_data, f"Schema format should include {field}")
        
        # Validate against v7.0 schema structure
        self.assertEqual(schema_data['current_level'], 'gamma')
        self.assertIn('gamma_multiplier', schema_data['progression_metrics'])
        self.assertIsInstance(schema_data['quantum_coherence'], (int, float))
        self.assertIsInstance(schema_data['etd_generation_rate'], (int, float))

if __name__ == '__main__':
    # Run tests
    unittest.main(verbosity=2)
