"""
FPGA Health Monitor
Health Packet Parser

Parses health packets received from the FPGA.
"""

def parse_health_packet(packet):
    """
    Parse a health packet.

    Expected format:
    TEMP, VOLTAGE, POWER, ERRORS, HEALTH
    """

    try:
        values = packet.strip().split(",")

        if len(values) != 5:
            raise ValueError("Invalid packet format")

        temperature = int(values[0])
        voltage = int(values[1])
        power = int(values[2])
        errors = int(values[3])
        health = int(values[4])

        return {
            "temperature": temperature,
            "voltage": voltage,
            "power": power,
            "errors": errors,
            "health": health
        }

    except ValueError as error:
        print(f"Packet parsing error: {error}")
        return None


if __name__ == "__main__":

    test_packet = "40,3300,2000,0,100"

    result = parse_health_packet(test_packet)

    if result:
        print("Health packet received:")
        print(f"Temperature : {result['temperature']} °C")
        print(f"Voltage     : {result['voltage']} mV")
        print(f"Power       : {result['power']} mW")
        print(f"Errors      : {result['errors']}")
        print(f"Health Score: {result['health']}")