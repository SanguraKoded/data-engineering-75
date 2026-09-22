import csv
import json

filtered_employees = []

with open("employees.csv", "r", newline="") as file:

    reader = csv.DictReader(file)

    for employee in reader:
        if int(employee["Salary"]) > 10000:
            filtered_employees.append(employee)

    with open("high_earners.json", "w") as file:

        json.dump(filtered_employees, file, indent=4)

print("Top Earners Have Been Saved Successfully")