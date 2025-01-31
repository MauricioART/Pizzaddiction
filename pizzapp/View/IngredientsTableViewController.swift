//
//  IngredientsTableViewController.swift
//  pizzapp
//
//  Created by Diplomado on 25/01/25.
//

import UIKit

class IngredientsTableViewController: UITableViewController {

    let viewModel = IngredientsTableViewModel()

    private var createPizzaButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.title = "Create custom pizza"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: viewModel.ingredientCellIdentifier)
        viewModel.delegate = self

        // Configurar el botón y deshabilitarlo por defecto
        createPizzaButton = UIBarButtonItem(title: "Create Pizza",
                                            style: .plain,
                                            target: self,
                                            action: #selector(didTapCreatePizzaButton))
        createPizzaButton.isEnabled = false
        navigationItem.rightBarButtonItem = createPizzaButton
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.ingredientsCount
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.ingredientCellIdentifier, for: indexPath)
        var cellConfiguration = cell.defaultContentConfiguration()

        let ingredient = viewModel.ingredient(at: indexPath)

        if viewModel.isSelected(ingredient: ingredient) {
            cellConfiguration.textProperties.font = UIFont.boldSystemFont(ofSize: 16)
            cellConfiguration.image = UIImage(systemName: "checkmark")
            cellConfiguration.imageProperties.alignment = .leading
        } else {
            cellConfiguration.textProperties.color = .black
        }

        cellConfiguration.text = ingredient
        cell.contentConfiguration = cellConfiguration

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let ingredientSelected = viewModel.ingredient(at: indexPath)

        if viewModel.isSelected(ingredient: ingredientSelected) {
            viewModel.removeIngredient(ingredient: ingredientSelected)
        } else {
            viewModel.addIngredient(at: indexPath)
        }

        tableView.reloadData()
        updateCreatePizzaButtonState()
    }

    private func updateCreatePizzaButtonState() {
        createPizzaButton.isEnabled = viewModel.selectedIngredientsCount > 0
    }

    @objc private func didTapCreatePizzaButton() {
        showInputAlert(in: self){
            [weak self] pizzaName in
            viewModel.createPizza(name: pizzaName)
            viewModel.removeAllIngredients()
            self?.tableView.reloadData()
        }
    }
}

extension IngredientsTableViewController: IngredientsViewModelDelegate {
    func shouldReloadTableData() {
        tableView.reloadData()
        updateCreatePizzaButtonState()
    }
}
