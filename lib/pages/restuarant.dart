import 'package:flutter/material.dart';
import 'package:quickly/classes/restaurants.dart';
import 'package:quickly/pages/food_page.dart';


class RestaurantPage extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantPage({Key? key, required this.restaurant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(restaurant.name),
      ),
      body: ListView.builder(
        itemCount: restaurant.menu.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FoodDetailsPage(food: restaurant.menu[index]),
                ),
              );
            },
            child: ListTile(
              leading: Image.asset(
                restaurant.menu[index].image,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              title: Text(restaurant.menu[index].name),
              subtitle: Text("\$${restaurant.menu[index].price}"),
            ),
          );
        },
      ),
    );
  }
}