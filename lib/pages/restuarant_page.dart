import 'package:flutter/material.dart';
import 'package:quickly/classes/restaurants.dart';
import 'package:quickly/pages/food_page.dart';

class RestaurantPage extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantPage({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height*0.3,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(restaurant.backgroundImage),
                  fit: BoxFit.cover,
                )
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(

                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: (){Navigator.pop(context);},
                      child: Container(

                        padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                        child: const Icon(Icons.arrow_back),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(restaurant.image),
                    radius: 40,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        restaurant.name,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(restaurant.location),
                      Text(
                          restaurant.deliveryStatus.toString().split('.').last),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Menu",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "View all",
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 10,
                      runSpacing: 10,
                      children: restaurant.menu.map((food) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    FoodDetailsPage(food: food),
                              ),
                            );
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 1.0,
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    food.image,
                                    width: double.infinity,
                                    height: 250,
                                    fit: BoxFit.cover,
                                    // scale: 5.0,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  food.name,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                Text("\$${food.price}", style: const TextStyle(fontSize: 15),),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
