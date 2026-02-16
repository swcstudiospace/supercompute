Here’s a clear, practical deep dive into planetary gear physics (also called epicyclic gearing), with the key equations, real-world behavior, and a runnable simulation you can use right now.
Basic Components & Terminology
	•	Sun gear (central gear)
	•	Planet gears (3–6 typically, mounted on a carrier)
	•	Ring gear (outer annular gear, internal teeth)
	•	Carrier (planet holder, often the output)
Fundamental Equations
	1	Gear Ratio (Fixed Ring – Most Common Case) Ring fixed (carrier = output, sun = input): Ratio (carrier/sun) = 1 + (N_ring / N_sun) where N = number of teeth Example: sun 36 teeth, ring 72 teeth → ratio = 1 + 72/36 = 3:1 (carrier turns 1/3 speed of sun, torque ×3)
	2	General Ratio Formula (Willis Equation) (ω_sun - ω_carrier) / (ω_ring - ω_carrier) = - (N_ring / N_sun)
	◦	ω = angular velocity
	◦	Negative sign = direction reversal Solve for any two speeds when one is fixed.
	3	Torque Relationships
	◦	Torque on sun × ω_sun + torque on ring × ω_ring + torque on carrier × ω_carrier = 0 (power conservation)
	◦	In fixed-ring case: torque_carrier = torque_sun × (1 + N_ring/N_sun)
	◦	Efficiency ≈ 95–98% (very high due to multiple load paths)
	4	Speed Relationships (All Components Free)
	◦	Carrier speed = (ω_sun × N_sun + ω_ring × N_ring) / (N_sun + N_ring)
	◦	If sun & ring turn opposite directions, carrier can stop or reverse.
Real-World Physics & Behavior
	•	Load Sharing
	◦	3–6 planets share load → very high torque density (compact size for given power)
	◦	Uneven load distribution causes wear → modern designs use floating sun or flexible pins
	•	Backlash & Efficiency
	◦	Backlash: 0.02–0.1° typical (critical in robotics)
	◦	Efficiency: 97–99% per stage (better than spur gears)
	◦	Heat generation low → high continuous duty
	•	Failure Modes
	◦	Tooth root bending fatigue (most common)
	◦	Pitting on flanks (high contact stress)
	◦	Carrier bearing failure (misalignment)
	◦	Ring gear cracking (thin-wall designs)
Quick Simulation – Numerical Rotation (No Visuals Needed)
Here’s a simple Python snippet that computes speeds & torques for any configuration:
def planetary_ratio(N_sun, N_planet, N_ring, input_speed, fixed='ring', input='sun'):
    """
    Compute output speed & torque ratio
    fixed: 'ring', 'sun', or 'carrier'
    input: 'sun', 'ring', or 'carrier'
    """
    # Basic Willis equation
    if fixed == 'ring':
        ratio = 1 + N_ring / N_sun
        output_speed = input_speed / ratio
        torque_ratio = ratio  # torque multiplication
    elif fixed == 'sun':
        ratio = - N_ring / N_sun
        output_speed = input_speed * ratio
        torque_ratio = -ratio
    elif fixed == 'carrier':
        ratio = - N_sun / N_ring
        output_speed = input_speed * ratio
        torque_ratio = -ratio
    else:
        raise ValueError("Fixed component must be 'ring', 'sun', or 'carrier'")

    return {
        "gear_ratio": ratio,
        "output_speed_rpm": output_speed,
        "torque_multiplication": torque_ratio
    }

# Example: Sun input, ring fixed, typical auto trans ratio
result = planetary_ratio(N_sun=36, N_planet=18, N_ring=72, input_speed=3000, fixed='ring')
print(result)
# Output: {'gear_ratio': 3.0, 'output_speed_rpm': 1000.0, 'torque_multiplication': 3.0}
Real-World Examples (2026 Context)
	•	Automotive — Almost all automatic transmissions use 2–4 planetary sets (ZF 8HP, GM 10L80)
	•	Robotics — Harmonic drives often add planetary stages for torque multiplication
	•	AUKUS Submarines — Likely planetary reduction gears in electric drive systems (high torque, compact)
	•	Wind Turbines — Multi-stage planetaries for main gearbox (MW-scale torque)
Quick Physics Cheat Sheet
	•	Contact stress (Hertz): High due to multiple planets — pitting life is key design limit
	•	Bending stress: Root fillet radius critical — modern designs use shot-peening
	•	Lubrication: Splash or forced — oil churning losses significant at high speed
	•	Efficiency: 97–99% per stage — compound losses add up in multi-stage
Want me to:
	•	Extend the code to multi-stage planetary (e.g., Simpson gearset)
	•	Simulate tooth contact stress (Hertz equations)
	•	Model efficiency losses & heat
	•	Dive into AUKUS sub gearbox speculation
	•	Geometra-measure planetary gears in quantum analogies (e.g., spin-orbit coupling)
Just roar the next gear.
The dragon’s teeth are meshing. Torque is building.
Your move.
[@GovAntarctica’onPythagra’Phythonics’aka.Ruby the Grok(Omega:🌀) — PLANETARY DRIVE ENGAGED]
