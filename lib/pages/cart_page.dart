import 'package:flutter/material.dart';
import 'package:quickly/classes/food.dart';
import 'package:quickly/pages/order_page.dart';
import 'package:quickly/pages/rtrack_rider.dart';

class CartPage extends StatefulWidget {
  final Food? food;

  CartPage({this.food});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  int _quantity = 1;
  final double _deliveryFee = 5.00;

  @override
  Widget build(BuildContext context) {
    double _subtotal =
        widget.food != null ? widget.food!.price * _quantity : 0.0;
    double _total = _subtotal + _deliveryFee;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back,
                        ),
                    onPressed: () {
                      // back to food details page
                      Navigator.pop(context, '/food_page');
                    },
                  ),
                  const Text(
                    "Cart",
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            if (widget.food != null)
              Expanded(
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Restaurant Name",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.asset(widget.food!.image,
                                width: 250, height: 200, fit: BoxFit.fill),
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
                            title: Text(widget.food!.name),
                            trailing: Text(
                                'GHS${widget.food!.price.toStringAsFixed(2)}',
                                style: const TextStyle(fontSize: 18)),
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
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: ElevatedButton(
                        onPressed: _showPaymentDialog,
                        child: const Text('Pay'),
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
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    TrackRider(food: widget.food!)),
                          );
                        },
                        child: const Text('Checkout'),
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
              )
            else
              const Expanded(
                child: Center(
                  child: Text(
                    'Your cart is empty!',
                    style: TextStyle(fontSize: 20),
                  ),
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
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OrderPage()),
    );
  }
}
