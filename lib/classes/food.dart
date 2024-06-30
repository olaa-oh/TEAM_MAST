// food.dart
class Food {
  final String name;
  final String image;
  final String description;
  final double price;

  Food({
    required this.name,
    required this.image,
    required this.description,
    required this.price,
  });

  static List<Food> getPopularFoods() {
    return [
      Food(name: 'Burger', image: 'assets/images/fod1.jpeg', description: 'A juicy beef burger', price: 5.99),
      Food(name: 'Pizza', image: 'assets/images/fod2.jpeg', description: 'Cheesy pepperoni pizza', price: 7.99),
      Food(name: 'Salad', image: 'assets/images/fod3.jpeg', description: 'Healthy green salad', price: 4.99),
      Food(name: 'Pasta', image: 'assets/images/fod4.jpeg', description: 'Creamy Alfredo pasta', price: 6.99),
      Food(name: 'Sushi', image: 'assets/images/fod5.jpeg', description: 'Fresh sushi rolls', price: 8.99),
      Food(name: 'Ice Cream', image: 'assets/images/fod6.jpeg', description: 'Delicious vanilla ice cream', price: 3.99),
      Food(name: 'Fries', image: 'assets/images/fod7.jpeg', description: 'Crispy golden fries', price: 2.99),
      Food(name: 'Steak', image: 'assets/images/fod8.jpeg', description: 'Grilled steak with herbs', price: 14.99),
      Food(name: 'Sandwich', image: 'assets/images/fod9.jpeg', description: 'Turkey and cheese sandwich', price: 5.49),
      Food(name: 'Soup', image: 'assets/images/fod10.jpeg', description: 'Warm chicken soup', price: 4.49),
   
    ];
  }
}
