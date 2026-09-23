import json

with open('weather_data.json', 'r') as file:
    weather_data = json.load(file)

city = weather_data['name']
temperature = weather_data['main']['temp']
humidity = weather_data['main']['humidity']
description = weather_data['weather'][0]['description']

print(f"Weather in {city}:")
print(f"Temperature: {temperature}°C")  
print(f"Humidity: {humidity}%")
print(f"Description: {description}")