//
//  logger.swift
//  SwiftBot
//
//  Created by Andrew on 30/05/2017.
//
//

import Foundation

#if os(Linux)
    import Glibc
#else
    import Darwin
#endif

enum HerokuLogger {
    static func info(_ string: String) {
        fputs("[INFO]: \(string)", stdout)
        fflush(stdout)
    }
}
