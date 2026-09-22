import json

with open("high_earners.json", "r") as file:

    high_earners = json.load(file)

print(json.dumps(high_earners, indent=4))