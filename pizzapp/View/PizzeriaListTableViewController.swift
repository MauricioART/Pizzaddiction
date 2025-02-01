//
//  PizzeriaListTableViewController.swift
//  pizzapp
//
//  Created by Diplomado on 25/01/25.
//

import UIKit

class PizzeriaListTableViewController: UITableViewController {

    let viewModel = PizzeriaListTableViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Pizza Places"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: viewModel.pizzeriaCellIdentifier)
        viewModel.delegate = self

    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.pizzeriaCount
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.pizzeriaCellIdentifier, for: indexPath )
        var cellConfiguration = cell.defaultContentConfiguration()
        
        let pizzeria = viewModel.pizzeria(at: indexPath)
        
        if viewModel.isFavorite(pizzeria: pizzeria ) {
            cellConfiguration.textProperties.color = .systemYellow
        } else {
            cellConfiguration.textProperties.color = .black
        }
        
        cellConfiguration.text = pizzeria.name
        cellConfiguration.secondaryText = pizzeria.address
        cell.contentConfiguration = cellConfiguration
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let pizzeria = viewModel.pizzeria(at: indexPath)
        let pizzeriaDetailViewController = PizzeriaDetailViewController(pizzeria: pizzeria)
            
        navigationController?.pushViewController(pizzeriaDetailViewController,
                                                     animated: true)
        
        }
        
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let pizzeriaSelected = viewModel.pizzeria(at: indexPath)
        let isFavorite = viewModel.isFavorite(pizzeria: pizzeriaSelected)
        let actionTitle = isFavorite ? "Add to favorites" : "Remove from favorites"
        
        let favoriteAction = UIContextualAction(style: .normal,
                                                title: actionTitle) { [weak self] _, _, completion in
            if (isFavorite){
                self?.viewModel.removePizzeriaFromFavorites(pizzeria: pizzeriaSelected)
            }else{
                self?.viewModel.addPizzeriaToFavorites(at: indexPath)
            }
            self?.viewModel.saveFavoritePizzeria(onFinish: {
                NotificationCenter.default.post(name: .favoritesUpdated, object: nil)
            })
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


extension PizzeriaListTableViewController: PizzeriaListViewModelDelegate {
    func shouldReloadTableData() {
        tableView.reloadData()
    }
}
