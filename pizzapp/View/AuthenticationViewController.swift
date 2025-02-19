//
//  AuthenticationViewController.swift
//  pizzapp
//
//  Created by Diplomado on 01/02/25.
//

import UIKit
import LocalAuthentication

class AuthenticationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        isModalInPresentation = true
        
        view.backgroundColor = .systemBackground
        
        var configuration = UIButton.Configuration.borderedProminent()
        configuration.title = "Authenticate"
        
        let authenticationButton = UIButton(configuration: configuration)
        authenticationButton.translatesAutoresizingMaskIntoConstraints = false
        
        authenticationButton.addTarget(self,
                                       action: #selector(didTapAuthenticateButton),
                                       for: .touchUpInside)
        
        view.addSubview(authenticationButton)
        
        NSLayoutConstraint.activate([
            authenticationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            authenticationButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    @objc
    func didTapAuthenticateButton() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                   localizedReason: reason) { success, error in
                DispatchQueue.main.async {
                    if success {
                        self.dismiss(animated: true)
                    }
                }
            }
        }
    }
    
}
