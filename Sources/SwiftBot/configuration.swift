//
//  config.swift
//  SwiftBot
//

import PerfectLib
import Foundation

//
fileprivate var configuration: [String:Any]?

public final class Configuration {
    public let port: Int
    public let dbURL: String
    
    public let fbSubscribeToken: String
    public let fbPageAccessToken: String
    
    public convenience init() {
        if configuration == nil {
#if os(Linux)
            configuration = ProcessInfo.processInfo.environment
#else
            configuration = getConfig()
#endif
        }
        self.init(configuration!)
    }
    
    internal init(_ configuration: [String:Any]) {
        port = Int(configuration["PORT"] as? String ?? "8080")!
        dbURL = configuration["CLEARDB_DATABASE_URL"] as! String
        
        fbSubscribeToken = configuration["FACEBOOK_SUBSCRIBE_TOKEN"] as! String
        fbPageAccessToken = configuration["FACEBOOK_PAGE_ACCESS_TOKEN"] as! String
    }
}
