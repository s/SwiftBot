//
//  Coffee.swift
//  Coffee
//

internal struct Coffee {
    let amount : Int
    let type : CoffeeType
    let additions : [CoffeeAddition]
    var description : String {
        get {
            let additionsDescription = self.additions.map { (addition) -> String in
                return addition.rawValue
            }
            return "\(self.type.rawValue) with \(additionsDescription)"
        }
    }
}
