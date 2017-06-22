//
//  FacebookService.swift
//  Messanger
//

import Foundation
import BotsKit
import Mapper
import PerfectCURL

public final class FacebookProvider: Provider {
    internal let accessToken: String
    public let secretToken: String
    
    internal let webhook: MessengerWebhook = MessengerWebhook()
    // Good candidate to remove
    public weak var delegate: ProviderDelegate?
    
    public init(secretToken: String, accessToken: String) {
        self.secretToken = secretToken;
        self.accessToken = accessToken
    }
        
    public func parse(data: Data) throws {
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
            throw ProviderError.cantParseJSON(data)
        }
        try parse(json: json)
    }
    
    public func parse(json: JSON) throws {
        if let delegate = self.delegate {
            let request = try webhook.parse(callback: json)
            request.entry.forEach{
                let conversation = Conversation(members: [], //?
                    status: "page",
                    channelId: $0.id,
                    activityId: "facebook")
                $0.messaging.forEach{ (o) in
                    switch (o) {
                    case .message(let metadata, let message):
                        let from = Account(id: metadata.sender, name: "")
                        let recipient = Account(id: metadata.recipient, name: "")
                        let activity = Activity(type: .message,
                                                id: message.mid,
                                                conversation: conversation,
                                                from: from,
                                                recipient: recipient,
                                                timestamp: metadata.timestamp,
                                                localTimestamp: metadata.timestamp,
                                                text: message.text)
                        delegate.receive(message: activity)
                        break
                    default:
                        break
                    }
                }
            }
        }
    }
        
    // Send
    public func send(activity: Activity) {
        
        do {
            let json = [
                "recipient": ["id": activity.recipient.id ],
                "message": ["text": activity.text]
            ];
            
            let data = try JSONSerialization.data(withJSONObject: json)
            
            let url = "https://graph.facebook.com/v2.6/me/messages?access_token=\(self.accessToken)"
            let res = try performPOSTUrlRequest(url, data: data);
            
            debugPrint("Response \(res)")
        }
        catch let error {
            fatalError("\(error)")
        }
    }
    
    fileprivate func performPOSTUrlRequest(_ url: String, data: Data) throws -> String {
        let request = CURLRequest(url,
                                  .httpMethod(.post),
                                  .addHeader(.fromStandard(name: "Content-Type"), "application/json"),
                                  .postData([UInt8](data)))
        return try request.perform().bodyString
    }
}


