# Pizzeria App

The **Pizzeria App** is an iOS application built using **UIKit** and **programmatic views**. This app allows users to explore various pizzas, pizzerias, manage their favorites, and even create custom pizzas. The app also includes interactive features such as animations, a map view for pizzerias, and a favorites list that persists across app sessions.

## Features

### 1. **Pizza List**
- View a list of pizzas sourced from a **JSON** file.
- **Swipe actions** to add or remove pizzas from favorites.
- Tap on a pizza to view its details, including:
  - An animated header.
  - A list of ingredients for the selected pizza.

### 2. **Pizzeria List**
- View a list of pizzerias sourced from a **JSON** file.
- **Swipe actions** to add or remove pizzerias from favorites.
- Tap on a pizzeria to view its details, including:
  - The name and location of the pizzeria.
  - If coordinates are available, a button opens a **map view**:
    - A modal view shows the location of the pizzeria on a map.
    - A pin marks the pizzeria's location, and the user's current location is also displayed.
    - A button to get directions from the user's location to the pizzeria.

### 3. **Favorites**
- A combined list of favorite **pizzas** and **pizzerias**.
- Tap on any item to view its corresponding detailed view.

### 4. **Ingredients**
- View a list of available **ingredients** for pizzas sourced from a **JSON** file.
- Select multiple ingredients to create a custom pizza.
- Tap a button to create a new pizza:
  - A prompt allows the user to name the pizza.
  - The created pizza is saved and added to the pizza list.
  - The selected ingredients are cleared after creation.

### 5. **Persistent Favorites**
- Favorites persist across app launches, ensuring users' preferences are saved.

## Technologies Used

- **UIKit**: For the user interface and programmatic views.
- **JSON**: For storing and reading data on pizzas, pizzerias, and ingredients.
- **CoreLocation**: To get the user's location.
- **MapKit**: For displaying maps and showing pizzeria locations.
- **Lottie**: To incorporate smooth animations for UI interactions.

## Installation

1. **Clone the repository**:

   ```bash
   git clone https://github.com/username/PizzeriaApp.git
