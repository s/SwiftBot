//
//  TextProcessingService.swift
//  TextProcessingService
//

internal enum TextProcessingServiceResult<T> {
    case success([T])
    case error(Error)
}

internal protocol TextProcessingServiceProtocol {
    func process(_ text:String) -> TextProcessingServiceResult<Coffee>
}

internal class TextProcessingService {
    
    //MARK: Properties
    fileprivate let spellCheckerService : SpellCheckingService
    fileprivate let entityRecognitionService : EntityRecognitionService
    
    //MARK: Lifecycle
    init(spellCheckerService:SpellCheckingService, entityRecognitionService:EntityRecognitionService) {
        self.spellCheckerService = spellCheckerService
        self.entityRecognitionService = entityRecognitionService
    }
}

extension TextProcessingService : TextProcessingServiceProtocol {
    
    func process(_ text:String) -> TextProcessingServiceResult<Coffee> {    
        let normalizedString = self.spellCheckerService.normalize(text)
        let coffeesRequested = self.entityRecognitionService.parse(normalizedString)
        return TextProcessingServiceResult.success(coffeesRequested)
    }
}
