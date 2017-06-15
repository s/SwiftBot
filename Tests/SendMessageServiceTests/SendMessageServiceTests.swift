//
//  SendMessageServiceTests.swift
//  SwiftBot
//
//  Created by Andrew Tokarev on 15/06/2017.
//
//

import XCTest
@testable import ChatProviders

class MockHttpTransporter : HttpTransportable
{
    var requestMethod: String = ""
    var requestUrl   : String = ""
    var requestData  : String = ""
    
    var responseStatus: Int = 0
    var responseBody  : String = ""
    var responseError : Error? = nil
    
    func request(method: HttpTransportableMethod, url: URL, data: Data, callback:(_ status:Int, _ body: String, _ error: Error?)->())
    {
        requestUrl = url.absoluteString
        requestMethod = "\(method)"
        requestData = String(data: data, encoding: .utf8) ?? ""
        
        callback(responseStatus, responseBody, responseError)
    }
}

class SendMessageServiceTests: XCTestCase {
    
    func testSend() {
        
        let mockHttpTranporter = MockHttpTransporter();
        mockHttpTranporter.responseStatus = 201
        mockHttpTranporter.responseError = nil
        mockHttpTranporter.responseBody = "OK"
        
        let request = SendMessageRequest(recepientId: "id", messageText: "hi", accessToken: "token", httpMethod: "post")
        let service = SendMessageService(httpTransport: mockHttpTranporter)
        var callbackWasCalled = false
        
        service.send(request: request) { response in
            
            XCTAssertEqual(response.body, "OK")
            XCTAssertNil(response.error)
            callbackWasCalled = true
        }
        
        XCTAssertTrue(callbackWasCalled)
    }
}
