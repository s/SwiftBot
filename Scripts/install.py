#!/usr/bin/python

import sys

optionsList = {"PORT":"",
    "CLEARDB_DATABASE_URL":"",
    "FACEBOOK_SUBSCRIBE_TOKEN":"",
    "FACEBOOK_PAGE_ACCESS_TOKEN":""
    }

for key in optionsList:
    optionsList[key] = raw_input("Please enter " + key + ": ")

content = """
// Do not commit changes of this file to repo

internal func getConfig() -> [String:String] {
    return [
"""

for key, value in optionsList.items():
    content += "            \"" + key + "\": \"" + value + "\",\n"

content += """
    ]
}
"""

with open(sys.argv[1], "w") as file:
    file.write(content)

print("Checked your config.swift")
