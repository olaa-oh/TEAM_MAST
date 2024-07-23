// homepage servce

import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
import 'package:http/http.dart' as http;
// import 'package:quickly/loaders/loaders.dart';
import 'dart:convert';
// import 'package:quickly/pages/home_page.dart';
import 'package:get_storage/get_storage.dart';

final storage = GetStorage();

// fetch data from featured foods
Future<Map<String, dynamic>> fetchRestaurants() async {
  const String restaurantUrl =
      'https://us-central1-quicklyfoodapi.cloudfunctions.net/quicklyfoodapi/restaurants';
  try {
    final response = await http.get(Uri.parse(restaurantUrl));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load restaurants');
    }
  } catch (e) {
    print(e);
    return {};
  }
}

// fectch data from restaurant details
Future<Map<String, dynamic>> fetchRestaurantDetails(dynamic restaurantId) async {
  String restaurantDetailsUrl =
        'https://us-central1-quicklyfoodapi.cloudfunctions.net/quicklyfoodapi/restaurants/$restaurantId/details';
  
  try {
    final response = await http.get(
      Uri.parse(restaurantDetailsUrl),
      headers: {'Content-Type': 'application/json'},
      // body: jsonEncode({'restaurant_id': restaurantId}),
    );
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load restaurant details');
    }
  } catch (e) {
    print(e);
    return {};
  }
}

// fetch data from popular foods
Future<List<Map<String, dynamic>>> fetchPopularFoods() async {
  const String popularFoodsUrl =
      'https://us-central1-quicklyfoodapi.cloudfunctions.net/quicklyfoodapi/popular_meals';
  try {
    final response = await http.get(Uri.parse(popularFoodsUrl));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load popular foods');
    }
  } catch (e) {
    print(e);
    return [];
  }
}

// get food details
Future<Map<String, dynamic>> fetchFoodDetails(dynamic foodId) async {
  String foodDetailsUrl =
      'https://us-central1-quicklyfoodapi.cloudfunctions.net/quicklyfoodapi/food/$foodId/details';
  try {
    final response = await http.get(Uri.parse(foodDetailsUrl));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load food details');
    }
  } catch (e) {
    print(e);
    return {};
  }
}

// get featured meals in the restaurant
Future<List<Map<String, dynamic>>> fetchFeaturedMeals(dynamic restaurantId) async {
  String featuredMealsUrl =
      'https://us-central1-quicklyfoodapi.cloudfunctions.net/quicklyfoodapi/restaurants/$restaurantId/meals';
  try {
    final response = await http.get(Uri.parse(featuredMealsUrl));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data.containsKey('meals') && data['meals'] is List) {
        return List<Map<String, dynamic>>.from(data['meals']);
      } else {
        print('Unexpected data structure: $data');
        return [];
      }
    } else {
      throw Exception('Failed to load meals');
    }
  } catch (e) {
    print('Error fetching meals: $e');
    return [];
  }
}

// place an order for a meal with the userid, mealid, and and restaurantid and passing the quantity in the body
class OrderService {
  static Future<Map<String, dynamic>> placeOrder(String userId, String restaurantId, String mealId, int quantity) async {
    final url = 'https://us-central1-quicklyfoodapi.cloudfunctions.net/quicklyfoodapi/users/$userId/restaurants/$restaurantId/meals/$mealId/place_order';
    
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'quantity': quantity}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to place order');
    }
  }
}

