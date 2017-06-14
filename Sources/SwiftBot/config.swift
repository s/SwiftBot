
// Do not commit changes of this file to repo

internal func getConfig() -> [String:String] {
    return [
        "PORT": "8080",
        "CLEARDB_DATABASE_URL": "mysql://root@127.0.0.1/swiftbot",
        
        "FACEBOOK_SUBSCRIBE_TOKEN": "test-token",
        "FACEBOOK_PAGE_ACCESS_TOKEN": ""
    ]
}
