//
//  Pizza.swift
//  pizzapp
//
//  Created by Diplomado on 25/01/25.
//
import Foundation

struct Pizza: Codable{
    var name: String
    var ingredients: [String]
}
extension Pizza: Hashable, Equatable{
    static func == (lhs: Pizza, rhs: Pizza) -> Bool {
        lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}
