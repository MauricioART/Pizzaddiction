//
//  PizzaListTableViewModel.swift
//  pizzapp
//
//  Created by Diplomado on 25/01/25.
//

import UIKit

protocol PizzaListViewModelDelegate{
    func shouldReloadTableData()
}
class PizzaListTableViewModel {
    
    private let pizzaInfoFileName = "pizza-info"
    private let favoritePizzaFileName = "favorite-pizza"
    private let pizzaInfoFileExtension = "json"
    
    let pizzaCellIdentifier = "pizza-cell"
    
    private var pizzaList : [Pizza] = []
        
    private var favoritePizza: Set<Pizza> = []
    
    var pizzaCount: Int { pizzaList.count }
    
    var favoritePizzaCount : Int { favoritePizza.count }
    
    var delegate: PizzaListViewModelDelegate?
    
    init() {
        self.pizzaList = loadPizzaData()
        self.favoritePizza = Set(loadFavoritePizzaData())
        
        NotificationCenter.default.addObserver(self,
                                                       selector: #selector(saveFavoritePizza),
                                                       name: UIApplication.willResignActiveNotification,
                                                   object: nil)
        
    }
    func loadPizzaData()->[Pizza]{
        guard let fileURL = Bundle.main.url(forResource: pizzaInfoFileName,
                                            withExtension: pizzaInfoFileExtension),
              let pizzaData = try? Data(contentsOf: fileURL),
              let pizzaList = try? JSONDecoder().decode([Pizza].self,
                                                          from: pizzaData)
        else {
            assertionFailure("Cannot find \(pizzaInfoFileName).\(pizzaInfoFileExtension)")
            return []
        }
        
        return pizzaList
    }
    
    func getIngredients(at indexPath: IndexPath)->String{
        let ingredients =  pizzaList[indexPath.row].ingredients
        return ingredients.reduce(""){
            result, ingredient in
            if(ingredient != ingredients.last){
                return result + ingredient + ", "
            }else{
                return result + ingredient
            }
        }
    }
    
    
     func loadFavoritePizzaData() -> [Pizza] {
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return []
        }
        
        let favoritePizzaURL = documentsURL.appending(component: "\(favoritePizzaFileName).\(pizzaInfoFileExtension)")
        
        do {
            let favoritePizzaData = try Data(contentsOf: favoritePizzaURL)
            let favoritePizzaList = try JSONDecoder().decode([Pizza].self,
                                                               from: favoritePizzaData)
            return favoritePizzaList
        } catch {
            assertionFailure("Cannot load favorite pizza file")
            return []
        }
    }
    
    func pizza(at position: IndexPath) -> Pizza {
        pizzaList[position.row]
    }
    
    func isFavorite(pizza: Pizza) -> Bool {
        favoritePizza.contains(pizza)
    }
    
    func addPizzaToFavorites(at indexPath: IndexPath) {
        let pizza = pizza(at: indexPath)
        
        favoritePizza.insert(pizza)
        delegate?.shouldReloadTableData()
    }
    
    func removePizzaFromFavorites(pizza: Pizza){
        favoritePizza.remove(pizza)
        delegate?.shouldReloadTableData()
    }
    
    @objc
    func saveFavoritePizza() {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory,
                                                                in: .userDomainMask).first
        else {
            assertionFailure("Couldn't find documents directory")
            return
        }
        
        let filename = "\(favoritePizzaFileName).\(pizzaInfoFileExtension)"
        let fileURL = documentsDirectory.appending(component: filename)
        
        let favoritePizza = Array(favoritePizza)
        
        do {
            let favoritePizzaData = try JSONEncoder().encode(favoritePizza)
            
            let jsonFavoritePizza = String(data: favoritePizzaData, encoding: .utf8)
            
            try jsonFavoritePizza?.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
            assertionFailure("Cannot encode favorite pizza: \(error.localizedDescription)")
        }
    }
}
