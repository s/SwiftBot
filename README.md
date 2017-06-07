## Swift Bot

It is going to do these tasks:
- Remind you about things
- Prepare Coffee
- Tell where the weather is worse right now
- BBB

## Some tips
There is a config.swift located in Sources/SwiftBot that needs to be modified for local environemnt and contain necessary values:
- PORT
- CLEARDB_DATABASE_URL
- FACEBOOK_SUBSCRIBE_TOKEN
- FACEBOOK_PAGE_ACCESS_TOKEN

if you change it for your envoronment, please also call this to prevent accidental push of this file:
```git update-index --assume-unchanged```
