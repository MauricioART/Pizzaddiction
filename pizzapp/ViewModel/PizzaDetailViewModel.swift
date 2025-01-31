//
//  PizzaViewModel.swift
//  pizzapp
//
//  Created by Diplomado on 25/01/25.
//

import UIKit


class PizzaDetailViewModel {
    let pizza: Pizza
    
    
    var pizzaName: String { pizza.name }
    
    var ingredients: [String] { pizza.ingredients }
    
    
    init(pizza: Pizza) {
        self.pizza = pizza
        
    }
    
    
}
