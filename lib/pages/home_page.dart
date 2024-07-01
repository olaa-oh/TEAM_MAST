import 'package:flutter/material.dart';
import 'package:quickly/classes/restaurants.dart';
import 'package:quickly/pages/food_page.dart';
import 'package:quickly/pages/restuarant_page.dart';
// import 'package:quickly/widgets/custom_nav_bar.dart';
import 'package:quickly/pages/order_page.dart';
import 'package:quickly/pages/cart_page.dart';
import 'package:quickly/pages/account_page.dart';
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
    OrderPage(),
    CartPage(),
    AccountPage(),
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
                    const EdgeInsets.symmetric(vertical: 70, horizontal: 25),
                child: Column(
                  children: [
                    // heading
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Welcome, Richard",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                        Row(
                          children: [
                            Icon(Icons.shop_2_outlined, size: 30),
                            Icon(Icons.notifications_outlined, size: 30),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // searchbox
                    Container(
                      margin: const EdgeInsets.only(top: 8, bottom: 16),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.search),
                          hintText: "Search for food,drinks etc",
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // billboard
                    Container(
                      height: 120,
                      width: 350,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 4, 22, 40),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            child: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Container(
                                width: 220,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      const Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          "Want some salad?",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      const Text(
                                        "Get free delivery for Jun Tao salad today",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15),
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                133, 179, 201, 190),
                                            borderRadius:
                                                BorderRadius.circular(13),
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5.0,
                                                horizontal: 18),
                                            child: Text(
                                              "Order Now",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 250),
                            child: Image(
                              image: AssetImage("assets/images/foodie.png"),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    // restaurant row list
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Restaurants",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w500),
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
                                  // const SizedBox(height: 8),
                                  // Text(restaurants[index].name),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // const SizedBox(height: 20),
                    // Popular Foods header
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Popular Foods",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w500),
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
                              decoration:
                                  const BoxDecoration(color: Colors.white),
                              margin: const EdgeInsets.only(right: 16),
                              child: Column(
                                children: 
                                [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.asset(
                                      popularFoods[index].image,
                                      height: 200,
                                      width: 200,
                                      fit: BoxFit.fill,
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
