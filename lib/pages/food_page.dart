import 'package:flutter/material.dart';
import 'package:quickly/classes/food.dart';
import 'package:quickly/constants/colors.dart';
import 'package:quickly/pages/cart_page.dart';

class FoodDetailsPage extends StatefulWidget {
  final Food food;

  FoodDetailsPage({required this.food});

  @override
  _FoodDetailsPageState createState() => _FoodDetailsPageState();
}

class _FoodDetailsPageState extends State<FoodDetailsPage> {
  int _quantity = 1;
  final double _deliveryFee = 5.00;

  @override
  Widget build(BuildContext context) {
    double _subtotal = widget.food.price * _quantity;
    double _total = _subtotal + _deliveryFee;

    return Scaffold(
      // appBar: AppBar(
      //   leading: IconButton(
      //     icon: Icon(Icons.arrow_back),
      //     onPressed: () {
      //       // go back to restaurant page
      //       Navigator.pop(context, '/restaurant_page');
      //     },
      //   ),
      //
      // ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height*0.4,
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(widget.food.image),
                  fit: BoxFit.cover,
                )
            ),
            child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(

        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: (){   // go back to restaurant page
                  Navigator.pop(context, '/restaurant_page');},
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
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.food.name,
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '\$${widget.food.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Description",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    widget.food.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 8),

                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 3),
                        decoration: BoxDecoration(

                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.primary),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                setState(() {
                                  if (_quantity > 1) _quantity--;
                                });
                              },
                            ),
                            const SizedBox(width: 5),
                            Text(
                              _quantity.toString(),
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(width: 5),
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
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CartPage(food: widget.food),
                                    ),
                                  );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'Add to Cart',
                            style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                          ),

                        ),
                      ),
                      // ElevatedButton(
                      //   onPressed: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) => CartPage(food: widget.food),
                      //       ),
                      //     );
                      //   },
                      //   child: const Text('Add to Cart'),
                      //   style: ElevatedButton.styleFrom(
                      //     padding: const EdgeInsets.symmetric(
                      //         horizontal: 40, vertical: 16),
                      //     textStyle: const TextStyle(fontSize: 18),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                // const SizedBox(height: 12),
                // Container(
                //   child: const Text(
                //     "REVIEWS",
                //     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
