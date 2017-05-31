
echo Send Subscribe Mode
curl  -X GET "http://localhost:8080//webhook?hub.mode=subscribe&hub.challenge=27493587&hub.verify_token=test-token"

# echo Send message empty message to the bot
# curl -X POST -H "Content-Type: application/json" -d '{}' http://127.0.0.1:8080/webhook

echo Send message to the bot
curl -X POST -H "Content-Type: application/json" -d '{ 
        "object": "page",
        "entry": [
            {
                "id": "223368791496726",
                "time": 1495630999933,
                "messaging": [
                    {
                        "sender": {
                            "id": "113922941284824"
                        },
                        "recipient": {
                            "id": "223368791496726"
                        },
                        "timestamp": 1495630999385,
                        "message": {
                            "mid": "mid.cAADLJ1_Btedia9M3WVcOo3uTVWpG",
                            "seq": 7827,
                            "text": "here is my very long message!!!"
                        }
                    }
                ]
            }
        ]
    }' http://127.0.0.1:8080/webhook

 

 