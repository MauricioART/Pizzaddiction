
import UIKit
import Lottie

class pizzeriaDetailViewController{
    private let viewModel : PizzeriaDetailViewModel

    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.text = "Location"
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.address
        label.font = UIFont.italicSystemFont(ofSize: 18)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .gray
        return label
    }()

    private var showLocationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        var config = UIButton.Configuration.filled()
        config.title = "Show on map"
        config.image = UIImage(systemName: "map.fill") 
        config.imagePlacement = .leading 
        config.imagePadding = 8 
        config.baseBackgroundColor = .systemBlue
        config.baseForegroundColor = .white

        button.configuration = config

        button.addTarget(self, action: #selector(didTapShowLocationButton), for: .touchUpInside)
        return button
    }()

    private var animationView : LottieAnimationView = {}(
        let animation = LottieAnimationView(name: "pizza-animation-2")
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        animationView.translatesAutoresizingMaskIntoConstraints = false
        return animation
    ) 
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        view.title = viewModel.name
        super.viewDidLoad()
        setupView()
    }

    init(pizzeria: Pizzeria) {
        self.viewModel = PizzeriaDetailViewModel(pizzeria: pizzeria)
        super.init(nibName: nil, bundle: nil)
    }

    func setupView(){
        
        view.addSubview(animationView)
        view.addSubview(locationLabel)
        view.addSubview(addressLabel)

        NSLayoutConstraint.activate([
            animationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            animationView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            animationView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),

            locationLabel.topAnchor.constraint(equalTo: animationView.bottomAnchor, constant: 8),
            locationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            locationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            addressLabel.topAnchor.constraint(equalTo: lo.bottomAnchor, constant: 16),
            addressLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            addressLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])

        if viewModel.hasLocation() {
            view.addSubview(showLocationButton)
            NSLayoutConstraint.activate([
                showLocationButton.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 16),
                showLocationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        }

    }

    @objc func didTapShowLocationButton() {
        guard viewModel.hasLocation() else {
            return
        }
        let locationVC = PizzeriaLocationViewController(pizzeria: viewModel.pizzeria)
        present(locationVC, animated: true)
    }
}