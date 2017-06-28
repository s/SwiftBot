//
//  SpellCheckingService.swift
//  SpellCheckingService
//

internal protocol SpellCheckerServiceProtocol {
    func normalize(_ text:String) -> String
}

internal class SpellCheckingService {}

extension SpellCheckingService : SpellCheckerServiceProtocol {
    func normalize(_ text: String) -> String {
        //TODO: Normalize the text via removing the symbols, numbers, irrelevant features,
        //checking disambiguations and returning the normalized text
        return text
    }
}
