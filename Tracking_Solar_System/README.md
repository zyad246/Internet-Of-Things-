# Solar Tracking System

This code implements a solar tracking system using an Arduino board, a servo motor, and two LDR (Light Dependent Resistor) sensors. The purpose of the system is to automatically adjust the position of a solar panel to maximize its exposure to sunlight throughout the day, optimizing energy generation.

## Hardware Requirements

To run this code, you will need the following components:

- Arduino board (e.g., Arduino Uno)
- Servo motor
- Two LDR sensors
- Jumper wires
- Power supply

## Circuit Setup

1. Connect the LDR sensors to the Arduino board:
   - LDR1: Connect one leg to analog pin A0 on the Arduino board.
   - LDR2: Connect one leg to analog pin A1 on the Arduino board.
   - Connect the other legs of both LDR sensors to the ground (GND) pin on the Arduino board.

2. Connect the servo motor to the Arduino board:
   - Connect the signal wire of the servo motor to digital pin 11 on the Arduino board.
   - Connect the power and ground wires of the servo motor to the appropriate pins on the Arduino board.

3. Ensure that the power supply is connected to the Arduino board.

## Software Setup

1. Open the Arduino IDE (Integrated Development Environment) on your computer.

2. Create a new sketch and copy the code from the `Sollar_Cell.ino` file into the sketch.

3. Verify the code for any syntax errors.

4. Upload the code to the Arduino board.

## Operation

Once the code is uploaded and the circuit is set up, the solar tracking system will begin operation. Here's how it works:

1. The LDR sensors continuously measure the light intensity falling on them.

2. The code calculates the difference in light intensity readings between the two sensors.

3. If the difference is within the acceptable error range (defined by the `error` constant), no adjustment is made to the servo motor.

4. If the difference exceeds the error range, the code determines which sensor has a higher light intensity reading.

5. The servo motor is then adjusted to incrementally align the solar panel with the sun. If `ldr1` has a higher reading, the servo position is decremented by one degree; if `ldr2` has a higher reading, the servo position is incremented by one degree.

6. The new servo position is written to the servo motor, and the process is repeated in a loop.

The system will continuously track the sun's movement by adjusting the solar panel's position in real-time, maximizing its exposure to sunlight and optimizing energy generation.

## Customization

- You can adjust the `error` value in the code to change the acceptable difference in light intensity readings for servo motor adjustment.
- Additional calibration and fine-tuning may be required based on the specific setup and environmental conditions.


## Acknowledgments

This code is inspired by various solar tracking projects and examples available in the Arduino community.
