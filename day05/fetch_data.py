
import requests


api_key = "1898673ff4a89c044bb4c859a69a9bcc"

arusha_lat = -3.367
arusha_long = 36.683

api_url = "https://api.openweathermap.org/data/2.5/weather?"

params = {
    "lat" : arusha_lat,
    "lon": arusha_long,
    "appid": api_key

}

response  = requests.get(api_url, params=params)

print("Status Code: ", response.status_code)

data = response.json()

print(data)