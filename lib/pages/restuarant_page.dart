import 'package:flutter/material.dart';
import 'package:quickly/Authentication/services/homepage_service.dart';
import 'package:quickly/pages/food_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RestaurantPage extends StatefulWidget {
  final String restaurantId;

  RestaurantPage({required this.restaurantId});

  @override
  State<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  late Future<Map<String, dynamic>> _futureRestaurantDetails;
  late Future<List<Map<String, dynamic>>> _futureMeals;

  @override
  void initState() {
    super.initState();
    _futureRestaurantDetails = fetchRestaurantDetails(widget.restaurantId);
    _futureRestaurantDetails.then((value) {
      print(value);
    });
        _futureMeals = fetchFeaturedMeals(widget.restaurantId);
    _futureMeals.then((value) {
      print(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: _futureRestaurantDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final restaurant = snapshot.data!;
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: Image.network(
                          restaurant['banner'] ?? '',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/images/res_banner.png',
                              fit: BoxFit.contain,
                            );
                          },
                        ),
                      ),
                      Positioned(
                        top: 15,
                        left: 15,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(Icons.arrow_back),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 20),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          child: ClipOval(
                            child: Image.network(
                              restaurant['logo'] ?? '',
                              fit: BoxFit.cover,
                              width: 80,
                              height: 80,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/images/restaurant.png',
                                  fit: BoxFit.cover,
                                  width: 80,
                                  height: 80,
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                restaurant['name'] ?? '',
                                style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(restaurant['address'] ?? ''),
                              Text(restaurant['contact'] ?? ''),
                            ],
                          ),
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
                        const SizedBox(height: 10),
                        FutureBuilder<List<Map<String, dynamic>>>(
                          future: _futureMeals,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
                            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                              return Center(
                                child: Wrap(
                                  alignment: WrapAlignment.center,
                                  spacing: 10,
                                  runSpacing: 10,
                                  children: 
                                  snapshot.data!.map((food) 
                                  {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                FoodDetailsPage(food: food, restaurantName: restaurant['name'] ?? ''),
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
                                              child: Image.network(
                                                food['meal_image'] ?? '',
                                                width: double.infinity,
                                                height: 250,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) {
                                                  return Image.asset(
                                                    'assets/images/placeholder_food.png',
                                                    width: double.infinity,
                                                    height: 250,
                                                    fit: BoxFit.cover,
                                                  );
                                                },
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              food['name'] ?? '',
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "\GHS ${food['price']?.toStringAsFixed(2) ?? ''}",
                                              style: const TextStyle(fontSize: 15),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              );
                            } else {
                              return const Center(child: Text('No menu items available'));
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}