//
//  NavigationTabViewController.swift
//  pizzapp
//
//  Created by Diplomado on 25/01/25.
//

import UIKit

class NavigationTabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
    }
    
    func setupViewControllers(){
        let pizzaListViewController = UINavigationController(rootViewController: PizzaListTableViewController())
        pizzaListViewController.tabBarItem.title = "Pizzas"
        pizzaListViewController.tabBarItem.image = UIImage(systemName: "circle.grid.2x2")
        
        let pizzeriaListViewController = UINavigationController(rootViewController: PizzeriaListTableViewController())
        pizzeriaListViewController.tabBarItem.title = "Pizzería"
        pizzeriaListViewController.tabBarItem.image = UIImage(systemName: "house.circle")
        
        let favoritesTableViewController = UINavigationController(rootViewController: FavoritesTableViewController())
        favoritesTableViewController.tabBarItem.title = "Favorites"
        favoritesTableViewController.tabBarItem.image = UIImage(systemName: "heart")
        
        let ingredientsTableViewController = UINavigationController(rootViewController: IngredientsTableViewController())
        ingredientsTableViewController.tabBarItem.title = "Ingredients"
        ingredientsTableViewController.tabBarItem.image = UIImage(systemName: "carrot")
        
        viewControllers = [pizzaListViewController, pizzeriaListViewController, favoritesTableViewController, ingredientsTableViewController]
    }

}
