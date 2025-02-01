//
//  PizzaListTableViewController.swift
//  pizzapp
//
//  Created by Diplomado on 25/01/25.
//

import UIKit

class PizzaListTableViewController: UITableViewController {
    
    let viewModel = PizzaListTableViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Pizzas"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: viewModel.pizzaCellIdentifier)
        viewModel.delegate = self

    }

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.pizzaCount
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.pizzaCellIdentifier, for: indexPath )
        var cellConfiguration = cell.defaultContentConfiguration()
        
        let pizza = viewModel.pizza(at: indexPath)
        
        if viewModel.isFavorite(pizza: pizza ) {
            cellConfiguration.textProperties.color = .systemPink
        } else {
            cellConfiguration.textProperties.color = .black
        }
        
        cellConfiguration.text = viewModel.pizza(at: indexPath).name
        cellConfiguration.secondaryText = viewModel.getIngredients(at: indexPath)
        
        cell.contentConfiguration = cellConfiguration
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let pizza = viewModel.pizza(at: indexPath)
        let pizzaViewController = PizzaDetailViewController(pizza: pizza)
        
        navigationController?.pushViewController(pizzaViewController,
                                                 animated: true)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let pizzaSelected = viewModel.pizza(at: indexPath)
        let isFavorite = viewModel.isFavorite(pizza: pizzaSelected)
        let actionTitle = isFavorite ? "Add to favorites" : "Remove from favorites"
        
        let favoriteAction = UIContextualAction(style: .normal,
                                                title: actionTitle) { [weak self] _, _, completion in
            if (isFavorite){
                self?.viewModel.removePizzaFromFavorites(pizza: pizzaSelected)
            }else{
                self?.viewModel.addPizzaToFavorites(at: indexPath)
            }
            self?.viewModel.saveFavoritePizza()
            NotificationCenter.default.post(name: .favoritesUpdated, object: nil)
            completion(true)
            
        }
        
        
        if ( isFavorite){
            favoriteAction.backgroundColor = .gray
            favoriteAction.image = UIImage(systemName: "heart.fill")
        }else{
            favoriteAction.backgroundColor = .red
            favoriteAction.image = UIImage(systemName: "heart")
        }
        
        
        return UISwipeActionsConfiguration(actions: [favoriteAction])
    }

}

extension PizzaListTableViewController: PizzaListViewModelDelegate {
    func shouldReloadTableData() {
        tableView.reloadData()
    }
}
