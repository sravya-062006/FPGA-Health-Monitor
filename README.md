# FPGA Health Monitor

## Overview

FPGA Health Monitor is an FPGA-based real-time system designed to monitor
critical hardware parameters and identify abnormal operating conditions.

The system monitors:

- Temperature
- Voltage
- Power
- Error conditions
- Overall health status

It also supports health-data packet generation and UART transmission.

## Project Architecture

The project is organized into the following modules:

- FPGA RTL
- Simulation and Verification
- Backend
- Database
- AI
- Frontend
- Python
- Documentation

## FPGA RTL Modules

The FPGA implementation includes:

- Clock Monitor
- Temperature Monitor
- Voltage Monitor
- Power Monitor
- Error Counter
- Health FSM
- Health Monitor
- Health Packet Transmitter
- UART Transmitter
- Top Module

## Verification

The RTL functionality is verified using Verilog testbenches.

Simulation tests include:

- Normal operating conditions
- Critical health conditions
- UART transmission
- Health packet transmission
- Full packet transmission

## Current Status

- FPGA RTL modules implemented
- Behavioral simulations completed
- Health packet transmission verified
- UART transmission verified
- GitHub repository initialized
- Hardware implementation pending

## Future Work

1. FPGA board implementation
2. Sensor/hardware integration
3. Real-time health dashboard
4. Database integration
5. AI-based anomaly detection
6. Predictive maintenance
7. Hardware validation

## Technologies

- Verilog
- FPGA
- Vivado
- Python
- Git
- GitHub
- Database
- AI/ML
- Web technologies

## Author

Sravya