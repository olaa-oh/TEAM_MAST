import 'package:quickly/classes/food.dart';

enum DeliveryStatus {
  Delivery_Only,
  Pickup_Only,
  Deliver_and_Pickup
}

class Restaurant {
  final String name;
  final String image;
  final String backgroundImage;
  final String location;
  final DeliveryStatus deliveryStatus;
  final List<Food> menu;

  Restaurant({
    required this.name,
    required this.image,
    required this.backgroundImage,
    required this.location,
    required this.deliveryStatus,
    required this.menu,
  });

  static List<Restaurant> getRestaurants() {
    return [
      Restaurant(
        name: 'KFC',
        image: 'assets/images/dinner.png',
        backgroundImage: 'assets/images/p1.jpeg',
        location: '123 Main St',
        deliveryStatus: DeliveryStatus.Deliver_and_Pickup,
        menu: [
          Food(
              name: 'Fried Chicken',
              image: 'assets/images/fod8.jpeg',
              description: 'Crispy fried chicken',
              price: 8.99),
          Food(
              name: 'Mashed Potatoes',
              image: 'assets/images/fod7.jpeg',
              description: 'Creamy mashed potatoes',
              price: 2.99),
          Food(
              name: 'Something',
              image: 'assets/images/fod7.jpeg',
              description: "description",
              price: 4.99),
          Food(
              name: 'Something',
              image: 'assets/images/fod7.jpeg',
              description: "description",
              price: 4.99)
        ],
      ),
      Restaurant(
        name: 'Pizza Place',
        image: 'assets/images/dinner.png',
        backgroundImage: 'assets/images/p2.jpeg',
        location: '456 Elm St',
        deliveryStatus: DeliveryStatus.Pickup_Only,
        menu: [
          Food(
              name: 'Pepperoni Pizza',
              image: 'assets/images/fod1.jpeg',
              description: 'Cheesy pepperoni pizza',
              price: 7.99),
          Food(
              name: 'Garlic Bread',
              image: 'assets/images/fod2.jpeg',
              description: 'Toasted garlic bread',
              price: 3.99),
        ],
      ),
      // Add more restaurants here
      Restaurant(
        name: 'Burger King',
        image: 'assets/images/burger-king.png',
        backgroundImage: 'assets/images/p3.jpeg',
        location: '789 Oak St',
        deliveryStatus: DeliveryStatus.Delivery_Only,
        menu: [
          Food(
              name: 'Whopper',
              image: 'assets/images/fod3.jpeg',
              description: 'Juicy beef burger',
              price: 5.99),
          Food(
              name: 'Fries',
              image: 'assets/images/fod4.jpeg',
              description: 'Crispy golden fries',
              price: 2.99),
        ],
      ),
      Restaurant(
        name: 'Subway',
        image: 'assets/images/ramen.png',
        backgroundImage: 'assets/images/p4.jpeg',
        location: '101 Pine St',
        deliveryStatus: DeliveryStatus.Deliver_and_Pickup,
        menu: [
          Food(
              name: 'Sub Sandwich',
              image: 'assets/images/fod5.jpeg',
              description: 'Fresh sub sandwich',
              price: 6.99),
          Food(
              name: 'Cookies',
              image: 'assets/images/fod6.jpeg',
              description: 'Delicious cookies',
              price: 1.99),
        ],
      ),
      // Continue adding more restaurants
    ];
  }
}
