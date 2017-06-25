//
//  HeliumLogger+Application.swift
//  PerfectLib
//
//  Created by mainuser on 6/25/17.
//

import Foundation
import HeliumLogger
import LoggerAPI
import protocol PerfectLib.Logger

extension HeliumLogger {
    public final class PerfectLoggerBridge: PerfectLib.Logger {
        public func debug(message: String) {
            Log.debug(message)
        }
        
        public func info(message: String) {
            Log.info(message)
        }
        
        public func warning(message: String) {
            Log.warning(message)
        }
        
        public func error(message: String) {
            Log.error(message)
        }
        
        public func critical(message: String) {
            Log.error(message)
        }
        
        public func terminal(message: String) {
            Log.error(message)
        }
    }
    
    @discardableResult
    class func applicationLogger() -> HeliumLogger {
        let log = HeliumLogger(.verbose)
        Log.logger = log
        
        return log
    }
    
    internal func perfectLogger() -> PerfectLib.Logger {
        return PerfectLoggerBridge()
    }
}
