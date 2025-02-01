import UIKit

extension Notification.Name {
    static let favoritesUpdated = Notification.Name("favoritesUpdated")
}

func showInputAlert(in viewController: UIViewController, completion: @escaping (String?) -> Void) {
    let alert = UIAlertController(title: "Enter Name", message: "Type name for the pizza", preferredStyle: .alert)
    
    alert.addTextField { textField in
        textField.placeholder = "Pizza name"
    }
    
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
        let userInput = alert.textFields?.first?.text
        completion(userInput)
    }))
    
    viewController.present(alert, animated: true, completion: nil)
}


