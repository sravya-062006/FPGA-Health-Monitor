"""
FPGA Health Monitor
AI / Anomaly Detection Module

Classifies FPGA health readings as:
NORMAL
WARNING
CRITICAL
"""


def detect_anomaly(data):
    """
    Analyze FPGA health parameters and determine system status.
    """

    temperature = data["temperature"]
    voltage = data["voltage"]
    power = data["power"]
    errors = data["errors"]
    health = data["health"]

    warnings = []
    critical = []

    # Temperature monitoring
    if temperature >= 90:
        critical.append("Critical temperature")
    elif temperature >= 75:
        warnings.append("High temperature")

    # Voltage monitoring
    if voltage < 2800 or voltage > 3600:
        critical.append("Critical voltage")
    elif voltage < 3000 or voltage > 3500:
        warnings.append("Voltage outside normal range")

    # Power monitoring
    if power >= 4000:
        critical.append("Critical power consumption")
    elif power >= 3000:
        warnings.append("High power consumption")

    # Error monitoring
    if errors >= 5:
        critical.append("Multiple hardware errors")
    elif errors > 0:
        warnings.append("Hardware errors detected")

    # Health score
    if health < 40:
        critical.append("Very low health score")
    elif health < 70:
        warnings.append("Reduced health score")

    # Final classification
    if critical:
        status = "CRITICAL"
    elif warnings:
        status = "WARNING"
    else:
        status = "NORMAL"

    return {
        "status": status,
        "warnings": warnings,
        "critical": critical
    }


if __name__ == "__main__":

    test_cases = [

        {
            "name": "Normal condition",
            "temperature": 40,
            "voltage": 3300,
            "power": 2000,
            "errors": 0,
            "health": 100
        },

        {
            "name": "Warning condition",
            "temperature": 80,
            "voltage": 3300,
            "power": 2000,
            "errors": 1,
            "health": 65
        },

        {
            "name": "Critical condition",
            "temperature": 95,
            "voltage": 3700,
            "power": 4500,
            "errors": 6,
            "health": 30
        }
    ]

    for test in test_cases:

        result = detect_anomaly(test)

        print("----------------------------------------")
        print(f"Test: {test['name']}")
        print(f"Status: {result['status']}")

        if result["warnings"]:
            print("Warnings:")
            for warning in result["warnings"]:
                print(f"  - {warning}")

        if result["critical"]:
            print("Critical:")
            for issue in result["critical"]:
                print(f"  - {issue}")