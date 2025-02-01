//
//  PizzaListTableViewModel.swift
//  pizzapp
//
//  Created by Diplomado on 25/01/25.
//

import UIKit

protocol PizzaListViewModelDelegate : AnyObject{
    func shouldReloadTableData()
}

class PizzaListTableViewModel {
    private let pizzaInfoFileName = "pizza-info"
    private let favoritePizzaFileName = "favorite-pizza"
    private let pizzaInfoFileExtension = "json"
    
    let pizzaCellIdentifier = "pizza-cell"
    
    private var pizzaList: [Pizza] = []
    private var favoritePizza: Set<Pizza> = []
    
    var pizzaCount: Int { pizzaList.count }
    var favoritePizzaCount: Int { favoritePizza.count }
    
    func getPizzaList()->[Pizza]{
        pizzaList
    }
    
    weak var delegate: PizzaListViewModelDelegate?
    
    init() {
        copyPizzaInfoToDocumentsIfNeeded()
        self.pizzaList = loadPizzaData()
        self.favoritePizza = Set(loadFavoritePizzaData())
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(saveFavoritePizza),
                                               name: UIApplication.willResignActiveNotification,
                                               object: nil)
    }
    
    private func getPizzaInfoFileURL() -> URL? {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("\(pizzaInfoFileName).\(pizzaInfoFileExtension)")
    }
    
    private func copyPizzaInfoToDocumentsIfNeeded() {
        let fileManager = FileManager.default
        guard let bundleURL = Bundle.main.url(forResource: pizzaInfoFileName, withExtension: pizzaInfoFileExtension),
              let documentURL = getPizzaInfoFileURL() else { return }
        
        if !fileManager.fileExists(atPath: documentURL.path) {
            do {
                try fileManager.copyItem(at: bundleURL, to: documentURL)
            } catch {
                print("Error copying pizza-info.json: \(error)")
            }
        }
    }
    
    func loadPizzaData() -> [Pizza] {
        guard let fileURL = getPizzaInfoFileURL(),
              let pizzaData = try? Data(contentsOf: fileURL),
              let pizzaList = try? JSONDecoder().decode([Pizza].self, from: pizzaData) else {
            print("Cannot load pizza-info.json")
            return []
        }
        return pizzaList
    }
    
    func updatePizzaData(_ newPizzaList: [Pizza]) {
        guard let fileURL = getPizzaInfoFileURL() else { return }
        
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(newPizzaList)
            try data.write(to: fileURL, options: .atomic)
            print("Pizza data updated successfully!")
            self.pizzaList = newPizzaList
            delegate?.shouldReloadTableData()
        } catch {
            print("Error saving updated pizza-info.json: \(error)")
        }
    }
    
    func getIngredients(at indexPath: IndexPath) -> String {
        let ingredients = pizzaList[indexPath.row].ingredients
        return ingredients.joined(separator: ", ")
    }
    
    func loadFavoritePizzaData() -> [Pizza] {
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return []
        }
        
        let favoritePizzaURL = documentsURL.appendingPathComponent("\(favoritePizzaFileName).\(pizzaInfoFileExtension)")
        
        do {
            let favoritePizzaData = try Data(contentsOf: favoritePizzaURL)
            return try JSONDecoder().decode([Pizza].self, from: favoritePizzaData)
        } catch {
            print("Cannot load favorite pizza file")
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
    
    func removePizzaFromFavorites(pizza: Pizza) {
        favoritePizza.remove(pizza)
        delegate?.shouldReloadTableData()
    }
    
    @objc
    func saveFavoritePizza() {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Couldn't find documents directory")
            return
        }
        
        let filename = "\(favoritePizzaFileName).\(pizzaInfoFileExtension)"
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        
        let favoritePizzaArray = Array(favoritePizza)
        
        do {
            let favoritePizzaData = try JSONEncoder().encode(favoritePizzaArray)
            try favoritePizzaData.write(to: fileURL, options: .atomic)
        } catch {
            print("Cannot encode favorite pizza: \(error.localizedDescription)")
        }
    }
}
