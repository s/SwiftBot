//
//  AppointingService.swift
//  AppointingService
//
//  Created by Said Ozcan on 28/06/2017.
//

import BotsKit

internal protocol AppointingServiceProtocol {
    func appointJobToAPerson(with session:Session) -> Account
}

internal class AppointingService {
    
    //MARK: Private
    fileprivate func chooseAPerson(from persons:[Account]) -> Account {
        let randomPersonIndex = generateRandomNumber(in: 0..<persons.count)
        return persons[randomPersonIndex]
    }
    
    fileprivate func generateRandomNumber(in range:Range<Int>) -> Int {
        //TODO: Generate random number here
        return 0
    }
}

extension AppointingService : AppointingServiceProtocol {
    
    func appointJobToAPerson(with session: Session) -> Account {
        //TODO: There could be some logic to not to choose previously chosen members maybe.
        //Or choose the person who asks for a lot of things
        return self.chooseAPerson(from: session.membersReplied)
    }
}
