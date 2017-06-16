## Swift Bot

It is going to do these tasks:
- Remind you about things
- Prepare Coffee
- Tell where the weather is worse right now
- BBB

## Some tips
There is a config.swift located in Sources/SwiftBot that needs to be modified for local environemnt and contain necessary values:
- "PORT" : "8080"
- "CLEARDB_DATABASE_URL": "mysql://root@127.0.0.1/swiftbot"
- "FACEBOOK_SUBSCRIBE_TOKEN": ???
- "FACEBOOK_PAGE_ACCESS_TOKEN": ???

if you change it for your envoronment, please also call this to prevent accidental push of this file:
```git update-index --assume-unchanged```

## Database
To test locally, you'll need to do the following:
```
brew install mysql
brew services start mysql
mysql <<<"CREATE DATABASE swiftbot;"
```
The Storage module connects to the MySQL database as set through the environment on Heroku, or if no setting is present there to your localhost 'swiftbot' schema. It creates the required table in the swiftbot database.

## Container

To build docker container use command:
```
docker build --tag bot
```

To run docker container you can use next command, that will rebind container port 8080 to your host port 80
```
docker run -p 80:8080 bot
```
