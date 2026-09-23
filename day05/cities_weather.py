import requests
import json

api_key = "1898673ff4a89c044bb4c859a69a9bcc"

api_url = "https://api.openweathermap.org/data/2.5/weather"

cities = {
    "Arusha": {"lat": -3.3869, "lon": 36.6822},
    "Kakamega": {"lat": 0.2827, "lon": 34.7519},
    "Kinshasa": {"lat": -4.4419, "lon": 15.2663},
    "Lagos": {"lat": 6.5244, "lon": 3.3792},
    "Bangui": {"lat": 4.3733, "lon": 18.5628}
}

weather_data = []
for city, coordinates in cities.items():
    params = {
        "lat": coordinates["lat"],
        "lon": coordinates["lon"],
        "appid": api_key
    }

    response = requests.get(api_url, params=params)

    status_code = response.status_code
    print(f"Status Code for {city}: {status_code}")

    if status_code == 200:
        data = response.json()
        weather_data.append(data)
        with open("weather_data_5_cities.json", "w", encoding="utf-8") as file:
            json.dump(weather_data, file, indent=4)
print("Weather data for 5 cities saved to weather_data_5_cities.json")