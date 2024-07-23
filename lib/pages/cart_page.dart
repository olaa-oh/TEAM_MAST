import 'package:flutter/material.dart';
import 'package:quickly/Authentication/services/homepage_service.dart';
import 'package:quickly/pages/order_page.dart';
import 'package:quickly/pages/rtrack_rider.dart';

class CartPage extends StatefulWidget {
  final Map<String, dynamic> food;
  // final String restaurantName;
  final String restaurantName;

  CartPage({required this.food, required this.restaurantName});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  int _quantity = 1;
  

  @override
  void initState() {
    // TODO: implement initState
    
  }

  @override
  Widget build(BuildContext context) {
    double _subtotal = (widget.food['price'] as num).toDouble() * _quantity;
    final double _deliveryFee = widget.food['price'] * 0.3;
    double _total = _subtotal + _deliveryFee;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Column(
          children: [
            // const SizedBox(height: 15),
            Expanded(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      widget.restaurantName ?? '',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                  // const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            widget.food['meal_image'] ?? '',
                            width: 250,
                            height: 200,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/images/res_banner.png',
                                width: 250,
                                height: 200,
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 201, 192, 217),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                setState(() {
                                  if (_quantity > 1) _quantity--;
                                });
                              },
                            ),
                            Text(
                              _quantity.toString(),
                              style: const TextStyle(fontSize: 18),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  _quantity++;
                                });
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Container(
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(widget.food['name'] ?? 'Unnamed Food'),
                          trailing: Text(
                            'GHS${(widget.food['price'] as num).toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    title: const Text("Delivery Fee"),
                    trailing: Text('GHS${_deliveryFee.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 18)),
                  ),
                  ListTile(
                    title: const Text("Total"),
                    trailing: Text('GHS${_total.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 18)),
                  ),
                  const Spacer(),
                  // Align(
                  //   alignment: Alignment.bottomCenter,
                  //   child: ElevatedButton(
                  //     onPressed: _showPaymentDialog,
                  //     child: const Text('Pay'),
                  //     style: ElevatedButton.styleFrom(
                  //       padding: const EdgeInsets.symmetric(
                  //         horizontal: 40,
                  //         vertical: 16,
                  //       ),
                  //       textStyle: const TextStyle(fontSize: 18),
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => TrackRider(food: widget.food),
                        //   ),
                        // );
                      },
                      child: const Text('Go to checkout'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 16,
                        ),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPaymentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Choose Payment Method"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Image.asset('assets/images/momo.png'),
                title: const Text("Mobile Money"),
                onTap: () {
                  Navigator.of(context).pop();
                  // Handle Mobile Money payment
                },
              ),
              ListTile(
                leading: Image.asset('assets/images/visa.png'),
                title: const Text("Credit Card"),
                onTap: () {
                  Navigator.of(context).pop();
                  _navigateToOrderPage();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _navigateToOrderPage() {
    // Implement navigation to OrderPage
  }
}
