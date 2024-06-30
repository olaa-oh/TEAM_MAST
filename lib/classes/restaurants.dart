
import 'package:quickly/classes/food.dart';


class Restaurant {
  final String name;
  final String image;
  final String location;
  final List<Food> menu;

  Restaurant({
    required this.name,
    required this.image,
    required this.location,
    required this.menu,
  });

  static List<Restaurant> getRestaurants() {
    return [
      Restaurant(
        name: 'KFC',
        image: 'assets/images/dinner.png',
        location: '123 Main St',
        menu: [
          Food(name: 'Fried Chicken', image: 'assets/images/fod8.jpeg', description: 'Crispy fried chicken', price: 8.99),
          Food(name: 'Mashed Potatoes', image: 'assets/images/fod7.jpeg', description: 'Creamy mashed potatoes', price: 2.99),
        ],
      ),
      Restaurant(
        name: 'Pizza Place',
        image: 'assets/images/dinner.png',
        location: '456 Elm St',
        menu: [
          Food(name: 'Pepperoni Pizza', image: 'assets/images/fod1.jpeg', description: 'Cheesy pepperoni pizza', price: 7.99),
          Food(name: 'Garlic Bread', image: 'assets/images/fod2.jpeg', description: 'Toasted garlic bread', price: 3.99),
        ],
      ),
      // Add more restaurants here
      Restaurant(
        name: 'Burger King',
        image: 'assets/images/burger-king.png',
        location: '789 Oak St',
        menu: [
          Food(name: 'Whopper', image: 'assets/images/fod3.jpeg', description: 'Juicy beef burger', price: 5.99),
          Food(name: 'Fries', image: 'assets/images/fod4.jpeg', description: 'Crispy golden fries', price: 2.99),
        ],
      ),
      Restaurant(
        name: 'Subway',
        image: 'assets/images/ramen.png',
        location: '101 Pine St',
        menu: [
          Food(name: 'Sub Sandwich', image: 'assets/images/fod5.jpeg', description: 'Fresh sub sandwich', price: 6.99),
          Food(name: 'Cookies', image: 'assets/images/fod6.jpeg', description: 'Delicious cookies', price: 1.99),
        ],
      ),
      // Continue adding more restaurants
    ];
  }
}
