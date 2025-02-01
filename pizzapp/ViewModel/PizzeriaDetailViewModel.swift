
import Foundation

class PizzeriaDetailViewModel {
    
    let pizzeria: Pizzeria
    
    init(pizzeria: Pizzeria) {
        self.pizzeria = pizzeria
    }
    
    var name: String { pizzeria.name }
    var address: String { pizzeria.address }
    

    func hasLocation() -> Bool {
        return pizzeria.location != nil
    }

}
