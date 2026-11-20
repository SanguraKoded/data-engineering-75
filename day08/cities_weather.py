import requests
import json
import logging
import os

os.makedirs("logs", exist_ok=True)

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s",
    handlers=[
        logging.FileHandler("logs/etl.log", encoding="utf-8"),
        logging.StreamHandler()
    ]
)

api_key = os.getenv("OPENWEATHER_API_KEY")
if not api_key:
    logging.error("OpenWeather API key is missing. Set OPENWEATHER_API_KEY.")
    raise ValueError("Missing OpenWeather API key")

api_url = "https://api.openweathermap.org/data/2.5/weather"

cities = {
    "Arusha": {"lat": -3.3869, "lon": 36.6822},
    "Kakamega": {"lat": 0.2827, "lon": 34.7519},
    "Kinshasa": {"lat": -4.4419, "lon": 15.2663},
    "Lagos": {"lat": 6.5244, "lon": 3.3792},
    "Bangui": {"lat": 4.3733, "lon": 18.5628}
}

weather_data = []
logging.info("Weather ETL process started")
for city, coordinates in cities.items():
    logging.info(f"Fetching weather data for {city}")
    params = {
        "lat": coordinates["lat"],
        "lon": coordinates["lon"],
        "appid": api_key
    }

    try:
        response = requests.get(api_url, params=params)
    except requests.exceptions.ConnectionError as e:
        logging.error("Connection failed for %s: %s", city, e)
        continue
    except requests.exceptions.Timeout as e:
        logging.error("Request timed out for %s: %s", city, e)
        continue
    if response.status_code != 200:
        logging.error("API request failed for %s. Status: %s", city, response.status_code)
        continue

    status_code = response.status_code

    if status_code == 200:
        try:
            data = response.json()
        except requests.exceptions.JSONDecodeError as e:
            logging.error("Invalid JSON response for %s: %s", city, e)
            continue

        try:
            data["name"]
            data["main"]["temp"]
            data["main"]["humidity"]
            data["weather"][0]["description"]

        except (KeyError, IndexError, TypeError) as e:
            logging.error("Missing or invalid weather data for %s: %s", city, e)
            continue
        logging.info("Successfully retrieved weather data for %s", city)
        weather_data.append(data)
        with open("weather_data_5_cities.json", "w", encoding="utf-8") as file:
            json.dump(weather_data, file, indent=4)
        logging.info("Weather data saved to weather_data_5_cities.json")
logging.info("Weather ETL process completed")