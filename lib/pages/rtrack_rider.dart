import 'package:flutter/material.dart';
import 'package:quickly/classes/food.dart';
import 'package:quickly/pages/confirm_order.dart';
import 'package:quickly/pages/order_completed.dart';

class TrackRider extends StatefulWidget {
  final Food food;

  const TrackRider({required this.food, super.key});

  @override
  State<TrackRider> createState() => _TrackRiderState();
}

class _TrackRiderState extends State<TrackRider> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Order'),
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
               Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Your order is on the way!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Arriving in 15 minutes',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const CircleAvatar(
                          radius: 30,
                          child: Icon(Icons.restaurant_menu),
                        ),
                        const CircleAvatar(
                          radius: 30,
                          child: Icon(Icons.bike_scooter),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (_) => const completeOrder(),
                              ),
                            );
                          },
                          child: const CircleAvatar(
                            radius: 30,
                            child: Icon(Icons.check_outlined),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(),
              const SizedBox(height: 8),
              const Text(
                "Your courier is heading to you with your order!",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 30),
              ListTile(
                leading: const CircleAvatar(
                  radius: 30,
                ),
                title: const Text('Delivery Service',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    )),
                subtitle: const Text(
                  'Driver 1',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.call),
                  onPressed: () {
                    // Add call functionality here
                  },
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
