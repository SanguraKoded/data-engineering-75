import requests
import json

api_key = "1898673ff4a89c044bb4c859a69a9bcc"

api_url = "https://api.openweathermap.org/data/2.5/weather"

arusha_lat = -3.3869
arusha_lon = 36.6822

params = {
    "lat": arusha_lat,
    "lon": arusha_lon,
    "appid": api_key
}

response = requests.get(api_url, params=params)

status_code = response.status_code
print(f"Status Code: {status_code}")

data = response.json()
with open("weather_data.json", "w", encoding="utf-8") as file:
    json.dump(data, file, indent=4)

print("Weather data saved to weather_data.json")