import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickly/Authentication/services/homepage_service.dart';
import 'package:quickly/pages/food_page.dart';
import 'package:quickly/pages/profile_page.dart';
import 'package:quickly/pages/restuarant_page.dart';
import 'package:quickly/pages/cart_page.dart';
import 'package:quickly/widgets/navBar.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomeContentPage(),
    // CartPage(f),
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

Widget _buildShimmerEffect({required double height, required double width}) {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      )
    ),
  );
}

Widget _buildShimmerRestaurant() {
  return Column(
    children: [
      _buildShimmerEffect(height: 80, width: 80),
      const SizedBox(height: 8),
      _buildShimmerEffect(height: 15, width: 80),
    ],
  );
}

Widget _buildShimmerPopularFood() {
  return Column(
    children: [
      _buildShimmerEffect(height: 150, width: 190),
      const SizedBox(height: 8),
      _buildShimmerEffect(height: 15, width: 120),
      const SizedBox(height: 8),
      _buildShimmerEffect(height: 15, width: 150),
      const SizedBox(height: 8),
      _buildShimmerEffect(height: 15, width: 60),
    ],
  );
}

class HomeContentPage extends StatefulWidget {
  const HomeContentPage({Key? key}) : super(key: key);

  @override
  _HomeContentPageState createState() => _HomeContentPageState();
}

class _HomeContentPageState extends State<HomeContentPage> {
  late Future<Map<String, dynamic>> _restaurantsFuture;
  late Future<List<Map<String, dynamic>>> _popularFoodsFuture;

  @override
  void initState() {
    super.initState();
    _restaurantsFuture = fetchRestaurants();
    _popularFoodsFuture = fetchPopularFoods();
  }

  Widget _buildNetworkImage(String? imageUrl, double height, double width) {
    if (imageUrl == null || imageUrl.isEmpty || imageUrl.startsWith('file:///')) {
      return Image.asset(
        'assets/images/restaurant.png',
        height: height,
        width: width,
        fit: BoxFit.cover,
      );
    }
    return Image.network(
      imageUrl,
      height: height,
      width: width,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          'assets/images/restaurant.png',
          height: height,
          width: width,
          fit: BoxFit.cover,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: Future.wait([_restaurantsFuture, _popularFoodsFuture]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 25),
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildShimmerSection("Restaurants", _buildShimmerRestaurant, 5),
                const SizedBox(height: 20),
                _buildShimmerSection("Popular Foods", _buildShimmerPopularFood, 5),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data![0]['restaurants'].isEmpty) {
          return Center(child: Text('No restaurants found'));
        } else {
          final restaurants = snapshot.data![0]['restaurants'] as List;
          final popularFoods = snapshot.data![1] as List<Map<String, dynamic>>;
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
                      padding: const EdgeInsets.symmetric(
                          vertical: 50, horizontal: 25),
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
                                  SizedBox(width: 5),
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
                                hintText: "Search for food, drinks etc",
                                hintStyle: TextStyle(color: Colors.grey),
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 15.0),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          // billboard
                          Image.asset('assets/images/order_cta.png',
                              fit: BoxFit.cover),

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
                                final restaurant = restaurants[index];
                                final restaurantEmail = restaurant['restaurant_id'];
                                return GestureDetector(
                                  onTap: () => Get.to(() => RestaurantPage(restaurantId: restaurantEmail)),
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 16),
                                    child: Column(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: _buildNetworkImage(restaurant?['logo'], 80, 80),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(restaurant['name'] ?? ''),
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
                                final popularFood = popularFoods[index];
                                final resT = popularFood['restaurant_name'];
                                final mealID = popularFood['id'];
                                return GestureDetector(
                                  onTap: () {
                                    Get.to(() => FoodDetailsPage(food: popularFood, restaurantName: resT,mealID: mealID,));
                                  },
                                  child: Container(
                                    height: 200,
                                    width: 200,
                                    margin: const EdgeInsets.only(right: 16),
                                    child: Column(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(15),
                                          child: _buildNetworkImage(popularFood['meal_image'], 150, 190),
                                        ),
                                        const SizedBox(height: 8),
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 10.0),
                                            child: Text(
                                              popularFood['restaurant_name'] ?? '',
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 10.0),
                                            child: Text(
                                              popularFood['name'] ?? '',
                                              style: const TextStyle(
                                                fontSize: 18,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 10.0),
                                            child: Text(
                                              "GHS${popularFood['price'] ?? ''}",
                                              style: const TextStyle(
                                                fontSize: 18,
                                                color: Colors.grey,
                                              ),
                                            ),
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
      },
    );
  }

  Widget _buildShimmerSection(String title, Widget Function() shimmerWidget, int itemCount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              "View All",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          height: title == "Restaurants" ? 120 : 300,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: itemCount,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(right: 16),
                child: shimmerWidget(),
              );
            },
          ),
        ),
      ],
    );
  }
}