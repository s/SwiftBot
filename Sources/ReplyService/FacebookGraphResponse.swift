//
//  FacebookGraphResponse.swift
//  SwiftBot
//
//  Created by Andrew Tokarev on 29/06/2017.
//
//

import Foundation

enum FacebookGraphResponse {

    case body(text: String)
    
    case error(error: Error)
}
