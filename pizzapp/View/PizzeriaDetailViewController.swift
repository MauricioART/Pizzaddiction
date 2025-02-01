
import UIKit
import Lottie

class PizzeriaDetailViewController: UIViewController{
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

    private lazy var showLocationButton: UIButton = {
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

//    private var animationView : LottieAnimationView = {}(
//        let animation = LottieAnimationView(name: "pizza-animation-2")
//        animationView.contentMode = .scaleAspectFit
//        animationView.loopMode = .loop
//        animationView.play()
//        animationView.translatesAutoresizingMaskIntoConstraints = false
//        return animation
//    ) 
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        super.viewDidLoad()
        setupView()
    }

    init(pizzeria: Pizzeria) {
        self.viewModel = PizzeriaDetailViewModel(pizzeria: pizzeria)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        
        let animation = LottieAnimationView(name: "pizza-animation-2")
        animation.contentMode = .scaleAspectFit
        animation.loopMode = .loop
        animation.play()
        animation.translatesAutoresizingMaskIntoConstraints = false
        
        
        view.addSubview(animation)
        view.addSubview(locationLabel)
        view.addSubview(addressLabel)

        NSLayoutConstraint.activate([
            animation.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            animation.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            animation.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            animation.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),

            locationLabel.topAnchor.constraint(equalTo: animation.bottomAnchor, constant: 8),
            locationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            locationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            addressLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 16),
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
