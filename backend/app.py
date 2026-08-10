from flask import Flask, jsonify, request

from database.health_database import (
    create_database,
    save_health_reading,
    get_recent_readings
)

from ai.anomaly_detector import detect_anomaly


app = Flask(__name__)


# =========================================================
# LATEST HEALTH DATA
# =========================================================

latest_health = {
    "temperature": 0,
    "voltage": 0,
    "power": 0,
    "errors": 0,
    "health": 0,
    "status": "UNKNOWN",
    "warnings": [],
    "critical": []
}


# =========================================================
# HOME
# =========================================================

@app.route("/")
def home():

    return jsonify({
        "project": "FPGA Health Monitor",
        "status": "Backend running",
        "version": "1.0"
    })


# =========================================================
# GET LATEST HEALTH
# =========================================================

@app.route("/health", methods=["GET"])
def get_health():

    return jsonify(latest_health)


# =========================================================
# UPDATE HEALTH
# =========================================================

@app.route("/health", methods=["POST"])
def update_health():

    global latest_health

    data = request.get_json()

    if not data:
        return jsonify({
            "error": "No data received"
        }), 400

    required_fields = [
        "temperature",
        "voltage",
        "power",
        "errors",
        "health"
    ]

    # Check required fields
    for field in required_fields:

        if field not in data:
            return jsonify({
                "error": f"Missing field: {field}"
            }), 400

    # Create clean health data
    health_data = {
        "temperature": data["temperature"],
        "voltage": data["voltage"],
        "power": data["power"],
        "errors": data["errors"],
        "health": data["health"]
    }

    # =====================================================
    # AI ANOMALY DETECTION
    # =====================================================

    analysis = detect_anomaly(health_data)

    # =====================================================
    # STORE HEALTH + AI RESULTS
    # =====================================================

    latest_health = {
        **health_data,
        "status": analysis["status"],
        "warnings": analysis["warnings"],
        "critical": analysis["critical"]
    }

    # =====================================================
    # SAVE DATA
    # =====================================================

    save_health_reading(latest_health)

    # =====================================================
    # RETURN RESULT
    # =====================================================

    return jsonify({
        "message": "Health data processed successfully",
        "data": latest_health
    }), 200


# =========================================================
# HEALTH HISTORY
# =========================================================

@app.route("/health/history", methods=["GET"])
def health_history():

    readings = get_recent_readings()

    return jsonify({
        "count": len(readings),
        "readings": readings
    })


# =========================================================
# AI ANALYSIS ONLY
# =========================================================

@app.route("/health/analyze", methods=["POST"])
def analyze_health():

    data = request.get_json()

    if not data:
        return jsonify({
            "error": "No data received"
        }), 400

    required_fields = [
        "temperature",
        "voltage",
        "power",
        "errors",
        "health"
    ]

    for field in required_fields:

        if field not in data:
            return jsonify({
                "error": f"Missing field: {field}"
            }), 400

    result = detect_anomaly(data)

    return jsonify({
        "input": data,
        "analysis": result
    })


# =========================================================
# START SERVER
# =========================================================

if __name__ == "__main__":

    create_database()

    print("========================================")
    print("      FPGA HEALTH MONITOR BACKEND")
    print("========================================")
    print("Server       : http://127.0.0.1:5000")
    print("Health API   : http://127.0.0.1:5000/health")
    print("History API  : http://127.0.0.1:5000/health/history")
    print("AI API       : http://127.0.0.1:5000/health/analyze")
    print("========================================")

    app.run(
        host="127.0.0.1",
        port=5000,
        debug=True
    )