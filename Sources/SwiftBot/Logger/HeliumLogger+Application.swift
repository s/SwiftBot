//
//  HeliumLogger+Application.swift
//  SwiftBot
//

import Foundation
import HeliumLogger
import LoggerAPI
import protocol PerfectLib.Logger
#if os(Linux)
    import Glibc
#else
    import Darwin
#endif


extension HeliumLogger {
    fileprivate final class PerfectLoggerBridge: PerfectLib.Logger {
        let logger: HeliumLogger
        
        init(logger: HeliumLogger) {
            self.logger = logger
        }
        
        public func debug(message: String) {
            logger.log(.debug, msg: message, functionName: "", lineNum: 0, fileName: "Perfect")
        }
        
        public func info(message: String) {
            logger.log(.info, msg: message, functionName: "", lineNum: 0, fileName: "Perfect")
        }
        
        public func warning(message: String) {
            logger.log(.warning, msg: message, functionName: "", lineNum: 0, fileName: "Perfect")
        }
        
        public func error(message: String) {
            logger.log(.error, msg: message, functionName: "", lineNum: 0, fileName: "Perfect")
        }
        
        public func critical(message: String) {
            logger.log(.error, msg: message, functionName: "", lineNum: 0, fileName: "Perfect")
        }
        
        public func terminal(message: String) {
            logger.log(.error, msg: message, functionName: "", lineNum: 0, fileName: "Perfect")
        }
    }
    
    fileprivate final class HerokuOutputStream: TextOutputStream {
        func write(_ string: String) {
            fputs(string, stdout)
            fputs("\n", stdout)
            fflush(stdout)
        }
    }
    
    class func applicationLogger(type: LoggerAPI.LoggerMessageType = .verbose) -> HeliumLogger {
        #if os(Linux)
            let logger = HeliumStreamLogger(type, outputStream:HerokuOutputStream())
        #else
            let logger = HeliumLogger(type)
        #endif
        Log.logger = logger
        return logger
    }
    
    func perfectLogger() -> PerfectLib.Logger {
        return PerfectLoggerBridge(logger: self)
    }
}
