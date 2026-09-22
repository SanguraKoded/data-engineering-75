import csv

with open("employees.csv", "r", newline="") as file:

    reader = csv.DictReader(file)

    for employee in reader:
        if int(employee["Salary"]) > 10000:

            print(employee)