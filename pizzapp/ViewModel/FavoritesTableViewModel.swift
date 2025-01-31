//
//  FavoritesTableViewModel.swift
//  pizzapp
//
//  Created by Diplomado on 25/01/25.
//

import Foundation

protocol FavoritesViewModelDelegate{
    func shouldReloadTable()
}

class FavoritesViewModel {
    private let favoritePizzaDataName = "favorite-pizza"
    private let favoritePizzeriaDataName = "favorite-pizzeria"
    private let DataExtension = "json"
    
    private(set) var favoritePizzaList: [Pizza] = []
    private(set) var favoritePizzeriaList: [Pizzeria] = []
    
    let pizzaViewModel = PizzaListTableViewModel()
    let pizzeriaViewModel = PizzeriaListTableViewModel()
    
    weak var delegate: FavoritesViewModelDelegate?
    
    var numberOfSections: Int { 2 }
    
    init() {
        favoritePizzaList = pizzaViewModel.loadFavoritePizzaData()
        favoritePizzeriaList = pizzeriaViewModel.loadFavoritePizzeriaData()
    }
    
    func pizza(at indexPath: IndexPath) -> Pizza {
        favoritePizzaList[indexPath.row]
    }
    func pizzeria(at indexPath: IndexPath) -> Pizzeria {
        favoritePizzeriaList[indexPath.row]
    }

    func updateFavorites() {
        favoritePizzaList = pizzaViewModel.loadFavoritePizzaData()
        favoritePizzeriaList = pizzeriaViewModel.loadFavoritePizzeriaData()

    }
    
//    private func loadFavoritePizza() -> [Pizza] {
//        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
//            return []
//        }
//        
//        let favoritePokemonURL = documentsURL.appendingPathComponent("\(favoritePizzaList).\(DataExtension)")
//        
//        do {
//            let favoritePizzaData = try Data(contentsOf: favoritePokemonURL)
//            let favoritePizzaList = try JSONDecoder().decode([Pizza].self,
//                                                             from: favoritePizzaData)
//            
//            return favoritePizzaList
//        } catch {
//            return []
//        }
//        
//    }
//    private func loadFavoritePizzeria() -> [Pizzeria] {
//        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
//            return []
//        }
//        
//        let favoritePokemonURL = documentsURL.appendingPathComponent("\(favoritePizzeriaList).\(DataExtension)")
//        
//        do {
//            let favoritePizzeriaData = try Data(contentsOf: favoritePokemonURL)
//            let favoritePizzeriaList = try JSONDecoder().decode([Pizzeria].self,
//                                                                from: favoritePizzeriaData)
//            
//            return favoritePizzeriaList
//        } catch {
//            return []
//        }
//        
//    }
}
