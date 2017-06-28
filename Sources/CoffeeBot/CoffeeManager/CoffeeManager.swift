//
//  CoffeeManager.swift
//  SwiftBot
//

import Foundation
import BotsKit
internal protocol CoffeeManagerProtocol {
    func process(activity:Activity)
}

class CoffeeManager {
    
    //MARK: Properties
    fileprivate let session : Session
    weak var botDelegate : CoffeeBot?
    
    //MARK: Lifecycle
    init() {
        self.session = Session()
    }
    
    //MARK: Private
    fileprivate func refreshSession() {
        //read the current message session from db or disk
    }
    
    fileprivate func hasEveryoneReplied(for activity:Activity) -> Bool {
        return self.session.membersReplied.count == activity.conversation.members.count
    }
    
    fileprivate func acknowledgeInputs(with activity:Activity) {
        let updatedActivity = activity.replay(text: self.session.description)
        self.botDelegate?.send(activity: updatedActivity)
    }
}

extension CoffeeManager : CoffeeManagerProtocol {
    
    func process(activity: Activity) {
        self.refreshSession()
        
        if hasEveryoneReplied(for: activity) {
            self.acknowledgeInputs(with: activity)
            //proceed to next steps
        } else {
            //process message and save to session
        }
    }
}
