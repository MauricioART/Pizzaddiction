//
//  PizzeriaListTableViewModel.swift
//  pizzapp
//
//  Created by Diplomado on 25/01/25.
//

import UIKit

protocol PizzeriaListViewModelDelegate {
    func shouldReloadTableData()
}

class PizzeriaListTableViewModel {
    
    private let pizzeriaInfoFileName = "pizzeria-info"
    private let favoritePizzeriaFileName = "favorite-pizzeria"
    private let pizzeriaInfoFileExtension = "json"
    
    let pizzeriaCellIdentifier = "pizzeria-cell"
    
    private var pizzeriaList: [Pizzeria] = []
        
    private var favoritePizzeria: Set<Pizzeria> = []
    
    var pizzeriaCount: Int { pizzeriaList.count }
    
    var favoritePizzeriaCount : Int { favoritePizzeria.count }
    
    var delegate: PizzeriaListViewModelDelegate?
    
    init() {
        self.pizzeriaList = loadPizzeriaData()
        self.favoritePizzeria = Set(loadFavoritePizzeriaData())
        
        NotificationCenter.default.addObserver(self,
                                                       selector: #selector(saveFavoritePizzeria),
                                                       name: UIApplication.willResignActiveNotification,
                                                       object: nil)
    }
    
    func loadPizzeriaData() -> [Pizzeria] {
        guard let fileURL = Bundle.main.url(forResource: pizzeriaInfoFileName,
                                            withExtension: pizzeriaInfoFileExtension),
              let pizzeriaData = try? Data(contentsOf: fileURL),
              let pizzeriaList = try? JSONDecoder().decode([Pizzeria].self,
                                                          from: pizzeriaData)
        else {
            assertionFailure("Cannot find \(pizzeriaInfoFileName).\(pizzeriaInfoFileExtension)")
            return []
        }
        
        return pizzeriaList
    }
    
     func loadFavoritePizzeriaData() -> [Pizzeria] {
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return []
        }
        
        let favoritePizzeriaURL = documentsURL.appending(component: "\(favoritePizzeriaFileName).\(pizzeriaInfoFileExtension)")
        
        do {
            let favoritePizzeriaData = try Data(contentsOf: favoritePizzeriaURL)
            let favoritePizzeriaList = try JSONDecoder().decode([Pizzeria].self,
                                                               from: favoritePizzeriaData)
            return favoritePizzeriaList
        } catch {
            assertionFailure("Cannot load favorite pizzeria file")
            return []
        }
    }
    
    func pizzeria(at position: IndexPath) -> Pizzeria {
        pizzeriaList[position.row]
    }
    
    func isFavorite(pizzeria: Pizzeria) -> Bool {
        favoritePizzeria.contains(pizzeria)
    }
    
    func addPizzeriaToFavorites(at indexPath: IndexPath) {
        let pizzeria = pizzeria(at: indexPath)
        
        favoritePizzeria.insert(pizzeria)
        delegate?.shouldReloadTableData()
    }
    
    func removePizzeriaFromFavorites(pizzeria: Pizzeria) {
        favoritePizzeria.remove(pizzeria)
        delegate?.shouldReloadTableData()
    }
    
    @objc
    func saveFavoritePizzeria() {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory,
                                                                in: .userDomainMask).first
        else {
            assertionFailure("Couldn't find documents directory")
            return
        }
        
        let filename = "\(favoritePizzeriaFileName).\(pizzeriaInfoFileExtension)"
        let fileURL = documentsDirectory.appending(component: filename)
        
        let favoritePizzeria = Array(favoritePizzeria)
        
        do {
            let favoritePizzeriaData = try JSONEncoder().encode(favoritePizzeria)
            
            let jsonFavoritePizzeria = String(data: favoritePizzeriaData, encoding: .utf8)
            
            try jsonFavoritePizzeria?.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
            assertionFailure("Cannot encode favorite pizzeria: \(error.localizedDescription)")
        }
    }
}

