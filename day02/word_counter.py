paragraph = str(input("Type the paragraph here: "))

counter: dict[str,int] = {}

for word in paragraph.split():
    if word in counter:
        counter[word] +=1
    else:
        counter[word]=1;
print(counter)
