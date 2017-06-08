//
//  logger.swift
//  SwiftBot
//
//  Created by Andrew on 30/05/2017.
//
//

import PerfectLib
#if os(Linux)
    import Glibc
#else
    import Darwin
#endif

internal final class HerokuLogger: Logger {
    func debug(message: String) {
        puts("[DEBUG]: \(message)")
    }
    
    func info(message: String) {
        puts("[INFO]: \(message)")
    }
    
    func warning(message: String) {
        puts("[WARNING]: \(message)")
    }
    
    func error(message: String) {
        puts("[ERROR]: \(message)")
    }
    
    func critical(message: String) {
        puts("[CRITICAL]: \(message)")
    }
    
    func terminal(message: String) {
        puts("[TERMINAL]: \(message)")
    }
    
    private func puts(_ string: String) {
        fputs(string, stdout)
        fflush(stdout)
    }

}
