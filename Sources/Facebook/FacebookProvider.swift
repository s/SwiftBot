//
//  FacebookService.swift
//  Messanger
//

import Foundation
import BotsKit
import Mapper
import ReplyService
import LoggerAPI

public final class FacebookProvider: Provider {
    internal let accessToken: String
    internal let secretToken: String
    
    public let name = "Facebook"
    public let recieveActivity: Signal<Activity>
    internal let updateInput: SignalInput<Activity>
    
    internal let webhook: MessengerWebhook = MessengerWebhook()
    internal let replyService: ReplyService
    
    public init(secretToken: String, accessToken: String) {
        self.secretToken = secretToken
        self.accessToken = accessToken
        self.replyService = ReplyService(accessToken: accessToken)
        
        let (input, signal) = Signal<Activity>.create()
        recieveActivity = signal
        updateInput = input
    }
    
    // Send
    public func send(activity: Activity) {
        replyService.send(replyRequest: activity) { (responce) in
            if let error = responce.error {
                Log.error(error.localizedDescription);
            }
            
            if let body = responce.body {
                Log.info(body)
            }
        }
    }
}

/// This extension add WebHook releated methods. To check registration challenge, parse
/// hook message, etc
extension FacebookProvider {
    public enum ChallengeResult {
        case ok(String)
        case error(String)
    }
    
    public func take(challenge: String, token: String) -> ChallengeResult {
        if token == self.secretToken {
            return ChallengeResult.ok(challenge)
        } else {
            return ChallengeResult.error("Wrong challenge token \(token)")
        }
    }
    
    public func parse(data: Data) throws {
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
            throw ProviderError.cantParseJSON(data)
        }
        try parse(json: json)
    }
    
    internal func parse(json: JSON) throws {
        let request = try webhook.parse(callback: json)
        request.entry.forEach{
            let conversation = Conversation(members: [], //?
                status: "page",
                channelId: $0.id,
                activityId: "facebook")
            $0.messaging.forEach{ (o) in
                switch (o) {
                case .message(let details, let message):
                    let from = Account(id: details.sender, name: "")
                    let recipient = Account(id: details.recipient, name: "")
                    let activity = Activity(type: .message,
                                            id: message.mid,
                                            conversation: conversation,
                                            from: from,
                                            recipient: recipient,
                                            timestamp: details.timestamp,
                                            localTimestamp: details.timestamp,
                                            text: message.text ?? "")
                    updateInput.update(activity)
                    break
                default:
                    break
                }
            }
        }
    }
}

