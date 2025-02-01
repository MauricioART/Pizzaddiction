//
//  IngredientsTableViewModel.swift
//  pizzapp
//
//  Created by Diplomado on 25/01/25.
//

import Foundation

protocol IngredientsViewModelDelegate{
    func shouldReloadTableData()
}
class IngredientsTableViewModel{
    private let ingredientsInfoFileName = "ingredients"
    private let ingredientsInfoFileExtension = "json"
    
    let ingredientCellIdentifier = "ingredient-cell"
    
    private var ingredients : [String] = []
        
    private var selectedIngredients: Set<String> = []
    
    var ingredientsCount: Int { ingredients.count }
    
    var selectedIngredientsCount : Int { selectedIngredients.count }
    
    var delegate: IngredientsViewModelDelegate?
    
    init() {
        self.ingredients = loadData()
        
//        NotificationCenter.default.addObserver(self,
//                                                       selector: #selector(saveFavoritePizza),
//                                                       name: UIApplication.willResignActiveNotification,
//                                                   object: nil)
        
    }
    
    func ingredient(at position: IndexPath) -> String {
        ingredients[position.row]
    }
    
    func addIngredient(at indexPath: IndexPath) {
        let ingredient = ingredient(at: indexPath)
        
        selectedIngredients.insert(ingredient)
        delegate?.shouldReloadTableData()
    }
    
    func removeIngredient(at indexPath: IndexPath) {
        let ingredient = ingredient(at: indexPath)
        
        selectedIngredients.remove(ingredient)
        delegate?.shouldReloadTableData()
    }

    func removeAllIngredients(){
        selectedIngredients.removeAll()
        delegate?.shouldReloadTableData()
    }

    func removeIngredient(ingredient: String){
        selectedIngredients.remove(ingredient)
        delegate?.shouldReloadTableData()
    }

    func createPizza(name: String)->Bool{
        guard !name.isEmpty else { return false }
        let pizza = Pizza(name: name, ingredients: Array(selectedIngredients))
        var pizzaList = PizzaListTableViewModel().getPizzaList()
        pizzaList.append(pizza)
        PizzaListTableViewModel().updatePizzaData(pizzaList)
        return true
        
    }
    
    func isSelected(ingredient: String) -> Bool {
        selectedIngredients.contains(ingredient)
    }
    func loadData()->[String]{
        guard let fileURL = Bundle.main.url(forResource: ingredientsInfoFileName,
                                            withExtension: ingredientsInfoFileExtension),
              let ingredientsData = try? Data(contentsOf: fileURL),
              let ingredientsList = try? JSONDecoder().decode([String].self,
                                                              from: ingredientsData)
        else {
            assertionFailure("Cannot find \(ingredientsInfoFileName).\(ingredientsInfoFileExtension)")
            return []
        }
        
        return ingredientsList
    }
}
