import sqlite3
from datetime import datetime

DATABASE = "database/health_monitor.db"


def create_database():
    conn = sqlite3.connect(DATABASE)

    cursor = conn.cursor()

    cursor.execute("""
        CREATE TABLE IF NOT EXISTS health_readings (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            timestamp TEXT NOT NULL,
            temperature REAL NOT NULL,
            voltage REAL NOT NULL,
            power REAL NOT NULL,
            errors INTEGER NOT NULL,
            health_score INTEGER NOT NULL
        )
    """)

    conn.commit()
    conn.close()


def save_health_reading(data):
    conn = sqlite3.connect(DATABASE)

    cursor = conn.cursor()

    cursor.execute("""
        INSERT INTO health_readings
        (timestamp, temperature, voltage, power, errors, health_score)
        VALUES (?, ?, ?, ?, ?, ?)
    """, (
        datetime.now().isoformat(),
        data["temperature"],
        data["voltage"],
        data["power"],
        data["errors"],
        data["health"]
    ))

    conn.commit()
    conn.close()


def get_recent_readings(limit=10):
    conn = sqlite3.connect(DATABASE)

    cursor = conn.cursor()

    cursor.execute("""
        SELECT *
        FROM health_readings
        ORDER BY id DESC
        LIMIT ?
    """, (limit,))

    readings = cursor.fetchall()

    conn.close()

    return readings


if __name__ == "__main__":

    create_database()

    test_data = {
        "temperature": 40,
        "voltage": 3300,
        "power": 2000,
        "errors": 0,
        "health": 100
    }

    save_health_reading(test_data)

    print("Database created successfully.")
    print("Recent readings:")

    for reading in get_recent_readings():
        print(reading)