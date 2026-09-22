class Person:
    def __init__(self, name, age):
        self.name = name
        self.age = age

    def greet(self):
        print(f"Hello, my name is {self.name} and I am {self.age} years old")

person1 = Person("James", 26)
person1.greet()
name = input("Enter your name here: ")
age = int(input("Enter your age here: "))
person2 = Person(name,age)
person2.greet()