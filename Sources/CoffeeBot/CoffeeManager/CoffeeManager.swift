//
//  CoffeeManager.swift
//  SwiftBot
//

import Foundation
import BotsKit
import LoggerAPI

internal protocol CoffeeManagerProtocol {
    func process(activity:Activity)
}

class CoffeeManager {
    
    //MARK: Properties
    fileprivate var session : Session? = nil
    fileprivate let textProcessingService : TextProcessingService
    fileprivate let appointingService : AppointingService
    fileprivate let sessionService : SessionService
    weak var botDelegate : CoffeeBot?
    
    //MARK: Lifecycle
    init(textProcessingService:TextProcessingService, appointingService:AppointingService, sessionService:SessionService) {
        self.textProcessingService = textProcessingService
        self.appointingService = appointingService
        self.sessionService = sessionService
    }
    
    //MARK: Private
    fileprivate func hasEveryoneReplied(in conversation:Conversation, with currentSession:Session) -> Bool {
        return currentSession.membersReplied.count == conversation.members.count
    }
    
    fileprivate func isTimeoutPeriodFinished() -> Bool {
        //TODO: Set a timeout for messages
        //E.g. all coffee requests should be made within 2 minutes.
        return false
    }
    
    fileprivate func acknowledgeInputs(with activity:Activity, for session:Session) {
        self.post(update: session.description, on: activity)
    }
    
    fileprivate func postProcessingResult(chosenPerson:Account, session:Session, activity:Activity) {
        let update = "\(chosenPerson.name) was selected to retrieve \(session.description). Congrats! ☕️"
        self.post(update: update, on: activity)
    }
    
    fileprivate func post(update text:String, on activity:Activity) {
        let updatedActivity = activity.replay(text: text)
        self.botDelegate?.send(activity: updatedActivity)
    }
}

extension CoffeeManager : CoffeeManagerProtocol {
    
    func process(activity: Activity) {
        
        //Restoring current context
        self.session = self.sessionService.restoreSession()
        guard var session = self.session else { return }
        
        //Processing the current message
        let processingResult = self.textProcessingService.process(activity.text)
        
        //Saving the coffee to session
        switch processingResult {
        case .success(let coffees):
            let coffeesRequested = CoffeeRequest(person: activity.from, coffees: coffees)
            session.coffeesRequested.append(coffeesRequested)
            self.sessionService.save(session: session)
            
        case .error(let error):
            Log.error("An error occured during processing message:\(error.localizedDescription)")
            return
        }
        
        //Dispatching further events
        if
            hasEveryoneReplied(in: activity.conversation, with: session) ||
            isTimeoutPeriodFinished()
        {
            //Printing acknowledgement of current requests
            self.acknowledgeInputs(with: activity, for: session)
            
            self.post(update: "Finding the lucky one...", on: activity)
            
            //proceed to next steps
            let luckyPerson = self.appointingService.appointJobToAPerson(with: session)
            self.postProcessingResult(chosenPerson: luckyPerson, session: session, activity: activity)
        }
    }
}
