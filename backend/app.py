from flask import Flask, jsonify, request

app = Flask(__name__)

latest_health = {
    "temperature": 0,
    "voltage": 0,
    "power": 0,
    "errors": 0,
    "health": 0
}


@app.route("/")
def home():
    return jsonify({
        "project": "FPGA Health Monitor",
        "status": "Backend running"
    })


@app.route("/health", methods=["GET"])
def get_health():
    return jsonify(latest_health)


@app.route("/health", methods=["POST"])
def update_health():
    global latest_health

    data = request.get_json()

    if not data:
        return jsonify({"error": "No data received"}), 400

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

    latest_health = data

    return jsonify({
        "message": "Health data updated",
        "data": latest_health
    }), 200


if __name__ == "__main__":
    app.run(debug=True, host="127.0.0.1", port=5000)