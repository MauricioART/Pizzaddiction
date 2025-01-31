//
//  FavoritesTableViewController.swift
//  pizzapp
//
//  Created by Diplomado on 25/01/25.
//

import UIKit

class FavoritesTableViewController: UITableViewController {

    private let viewModel = FavoritesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: viewModel.pizzaViewModel.pizzaCellIdentifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: viewModel.pizzeriaViewModel.pizzeriaCellIdentifier)
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Favorites"
        viewModel.delegate = self

        NotificationCenter.default.addObserver(self, selector: #selector(updateFavorites), name: .favoritesUpdated, object: nil)

    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        let authenticationViewController = AuthenticationViewController()
//        present(authenticationViewController, animated: true)
//    }

    @objc func updateFavorites(){
        viewModel.updateFavorites()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section){
        case 0:
            return viewModel.pizzaViewModel.favoritePizzaCount
        case 1:
            return viewModel.pizzeriaViewModel.favoritePizzeriaCount
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.pizzaViewModel.pizzaCellIdentifier, for: indexPath )
            var cellConfiguration = cell.defaultContentConfiguration()
            
            var pizza = viewModel.pizza(at: indexPath)
            
            cellConfiguration.text = viewModel.pizza(at: indexPath).name
            cellConfiguration.secondaryText = viewModel.pizzaViewModel.getIngredients(at: indexPath)
            
            cell.contentConfiguration = cellConfiguration
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.pizzeriaViewModel.pizzeriaCellIdentifier, for: indexPath )
            var cellConfiguration = cell.defaultContentConfiguration()
            
            let pizzeria = viewModel.pizzeria(at: indexPath)
            
            cellConfiguration.text = pizzeria.name
            cellConfiguration.secondaryText = pizzeria.address
            cell.contentConfiguration = cellConfiguration
            
            return cell
        }
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch(indexPath.section){
        case 0:
            let pizza = viewModel.pizza(at: indexPath)
            let pizzaViewController = PizzaViewController(pizza: pizza)
            
            navigationController?.pushViewController(pizzaViewController,
                                                     animated: true)
        case 1:
            let pizzeria = viewModel.pizzeria(at: indexPath)
            let pizzeriaDetailViewController = PizzeriaDetailViewController(pizzeria: pizzeria)
            
            navigationController?.pushViewController(pizzeriaDetailViewController,
                                                         animated: true)
        default:
            break
        }
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            switch section {
            case 0:
                return "Favorite Pizzas"
            case 1:
                return "Favorite Pizza Places"
            default:
                return nil
            }
        }

}

extension FavoritesTableViewController: FavoritesViewModelDelegate{
    func shouldReloadTable() {
        tableView.reloadData()
    }
    
    
}
