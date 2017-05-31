import MySQL
import Foundation;

// MySQL documentation: https://github.com/PerfectlySoft/PerfectDocs/blob/master/guide/MySQL.md
// URLComponents: https://developer.apple.com/reference/foundation/urlcomponents

// implement store function that can store dictionaries
// implement store function that can store an Int
// implement fetch function that can return an Int
// maybe support the following Types: String, Int, [String], [Int], [String:String], [String:Int], [Int:String], [Int:Int]
// I guess we present ourselves as a [String:Any]

public class Storage {
    var mysql:MySQL;
    let storageTable = "swiftbot_storage"
    
    enum StorageError: Error {
        case connectionError(details:String)
        case queryError(details:String)
        case dsnError
    }

    public init() throws {
        mysql = MySQL();
        let dsnString = ProcessInfo.processInfo.environment["CLEARDB_DATABASE_URL"] ?? "mysql://root@127.0.0.1/swiftbot"
        guard let dsn = URLComponents(string:dsnString) else { throw StorageError.dsnError }
        if dsn.scheme != "mysql" { throw StorageError.dsnError }
        
        let host = dsn.host ?? "127.0.0.1"
        let user = dsn.user ?? "root"
        let db = dsn.path.hasPrefix("/") ? dsn.path.substring(from:dsn.path.index(after:dsn.path.startIndex)) : dsn.path
        
        let connected = mysql.connect(
            host: host,
            user: user,
            password: dsn.password,
            db: db
        )
        guard connected else { throw StorageError.connectionError(details: mysql.errorMessage()) }
        
        let createSQL = "CREATE TABLE IF NOT EXISTS \(storageTable) ( `key` VARCHAR(255) CHARACTER SET latin1, last_update TIMESTAMP, `data` TEXT CHARACTER SET utf8, UNIQUE INDEX (`key`) )"
        let createSuccess = mysql.query(statement: createSQL )
        guard createSuccess else { throw StorageError.queryError(details: mysql.errorMessage()) }
    }

    deinit {
        mysql.close()
    }
    
    public func store(_ key: String, _ value: String) throws {
        let storeSuccess = mysql.query(statement: "INSERT INTO \(storageTable) SET `key`='\(key)', `data`='\(value)' ON DUPLICATE KEY UPDATE `data`='\(value)'")
        guard storeSuccess else { throw StorageError.queryError(details: mysql.errorMessage()) }
        
    }
    
    public func fetch(_ key: String) throws -> Any? {
        let fetchSuccess = mysql.query(statement: "SELECT data FROM \(storageTable) WHERE `key`='\(key)'")
        guard fetchSuccess else { throw StorageError.queryError(details: mysql.errorMessage()) }

        let results = mysql.storeResults()!
        
        if results.numRows() == 0 { return nil }
        
        guard let row = results.next() else { return nil }
        guard let value = row[0] else { return nil }
        
        return value
    }
    
    public func delete(_ key: String) throws {
        let deleteSuccess = mysql.query(statement: "DELETE FROM \(storageTable) WHERE `key`='\(key)'")
        guard deleteSuccess else { throw StorageError.queryError(details: mysql.errorMessage()) }
        
    }
}
