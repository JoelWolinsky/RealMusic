import json

with open("EmojiLibrary.json", "r") as read_file:
    data = json.load(read_file)
    print(data)
