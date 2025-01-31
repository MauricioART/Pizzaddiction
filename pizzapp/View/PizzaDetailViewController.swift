//
//  PizzaViewController.swift
//  pizzapp
//
//  Created by Diplomado on 25/01/25.
//

import UIKit
import Lottie

class PizzaDetailViewController: UIViewController {

    private let viewModel : PizzaDetailViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    init(pizza: Pizza) {
        self.viewModel = PizzaDetailViewModel(pizza: pizza)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        
        return view
    }()
    
    private lazy var ingredientsStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private lazy var ingredientsTitleLabel : UILabel = {
        let label = UILabel()
        label.text = "Ingredients"
        label.font = UIFont.italicSystemFont(ofSize: 18)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    func setupView() {
        view.backgroundColor = .systemBackground
        self.title = viewModel.pizzaName
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        let heightAnchor = contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        heightAnchor.isActive = true
        heightAnchor.priority = .required - 1
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
        
        let animationView = LottieAnimationView(name: "pizza-animation")
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(animationView)

        contentView.addSubview(ingredientsTitleLabel)

        contentView.addSubview(ingredientsStackView)
       
        NSLayoutConstraint.activate([
            animationView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 10),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            ingredientsTitleLabel.topAnchor.constraint(equalTo: animationView.bottomAnchor,constant: 10),
            ingredientsTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ingredientsStackView.topAnchor.constraint(equalTo: ingredientsTitleLabel.bottomAnchor,constant: 10),
            ingredientsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            ingredientsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
        
        addIngredientsToStack()
        
    }
    
    func addIngredientsToStack() {
        guard !viewModel.ingredients.isEmpty else { return }
        let ingredients = viewModel.ingredients
        for (index,ingredient) in ingredients.enumarated() {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "\(index + 1).-" + ingredient
            label.adjustsFontForContentSizeCategory = true
            label.font = .preferredFont(forTextStyle: .subheadline)
            label.textAligment = .left
            ingredientsStackView.addArrangedSubview(label)
        }
    }
}
