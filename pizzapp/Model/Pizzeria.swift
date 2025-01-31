//
//  Pizzeria.swift
//  pizzapp
//
//  Created by Diplomado on 25/01/25.
//

import Foundation

struct Pizzeria: Codable{

    struct Coordinates: Codable{
        var latitude : Double
        var longitude : Double
    }
    
    var name: String
    var address: String
    var location: Coordinates?
    
    private enum CodingKeys: String, CodingKey {
        case name
        case address
        case location = "coordinates"
    }
}

extension Pizzeria: Hashable, Equatable{
    static func == (lhs: Pizzeria, rhs: Pizzeria) -> Bool {
        lhs.address == rhs.address
    }
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(address)
    }
}
