import 'package:flutter/material.dart';
import 'package:quickly/classes/restaurants.dart';
import 'package:quickly/pages/food_page.dart';
import 'package:quickly/pages/profile_page.dart';
import 'package:quickly/pages/restuarant_page.dart';
// import 'package:quickly/widgets/custom_nav_bar.dart';
import 'package:quickly/pages/order_page.dart';
import 'package:quickly/pages/cart_page.dart';
import 'package:quickly/widgets/navBar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomeContentPage(),
    // OrderPage(),
    CartPage(),
    ProfilePage(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: CustomNavBar(
        currentIndex: _currentIndex,
        onTabTapped: _onTabTapped,
      ),
    );
  }
}

class HomeContentPage extends StatelessWidget {
  const HomeContentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final restaurants = Restaurant.getRestaurants();
    final popularFoods =
        restaurants.expand((restaurant) => restaurant.menu).toList();

    // Define a default restaurant to use when no matching restaurant is found
    final defaultRestaurant = Restaurant(
      name: 'Unknown',
      image: 'assets/images/default.png', // provide a default image
      backgroundImage: 'assets/images/default.png',
      location: 'Unknown',
      deliveryStatus: DeliveryStatus.Deliver_and_Pickup,
      menu: [],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: constraints.maxHeight,
            minWidth: constraints.maxWidth,
          ),
          child: IntrinsicHeight(
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 50, horizontal: 25),
                child: Column(
                  children: [
                    // heading
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Welcome, Richard",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Icon(Icons.shop_2_outlined, size: 30),
                            SizedBox(width: 5,),
                            Icon(Icons.notifications_outlined, size: 30),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // search box
                    Container(
                      margin: const EdgeInsets.only(top: 8, bottom: 16),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.search),
                          hintText: "Search for food,drinks etc",
                          hintStyle: TextStyle(color: Colors.grey),
                          contentPadding: EdgeInsets.symmetric(vertical: 15.0),

                        ),
                      ),

                    ),
                    const SizedBox(height: 10),

                    // billboard
                    Image.asset('assets/images/order_cta.png', fit: BoxFit.cover),

                    const SizedBox(height: 20),
                    // restaurant row list
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Restaurants",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "View All",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Horizontal list of restaurants
                    Container(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: restaurants.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RestaurantPage(
                                      restaurant: restaurants[index]),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 16),
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      restaurants[index].image,
                                      height: 80,
                                      width: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(restaurants[index].name),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Popular Foods header
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Popular Foods",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "View All",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Horizontal list of popular foods
                    Container(
                      height: 300,
                      width: 330,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: popularFoods.length,
                        itemBuilder: (context, index) {
                          final restaurant = restaurants.firstWhere(
                              (restaurant) => restaurant.menu
                                  .contains(popularFoods[index]),
                              orElse: () => defaultRestaurant);
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FoodDetailsPage(
                                      food: popularFoods[index],
                                      ),
                                     
                                ),
                              );
                            },
                            child: Container(
                              height: 200,
                              width: 200,
                              margin: const EdgeInsets.only(right: 16),
                              child: Column(
                                children: 
                                [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.asset(
                                      popularFoods[index].image,
                                      height: 150,
                                      width: 190,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(height: 8),

                                  // name of restaurants
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        restaurant.name,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // name of dish
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Text(popularFoods[index].name,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.grey,
                                          )),
                                    ),
                                  ),
                                  // price of food
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Text(
                                          "\GHS${popularFoods[index].price}",
                                          style: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.grey,
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
