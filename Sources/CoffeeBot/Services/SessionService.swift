//
//  SessionService.swift
//  SessionService
//

internal protocol SessionServiceProtocol {
    func restoreSession() -> Session
    func save(session:Session)
}

internal class SessionService {}

extension SessionService : SessionServiceProtocol {
    
    func restoreSession() -> Session {
        return Session()
    }
    
    func save(session: Session) {
        
    }
}
