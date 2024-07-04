import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';

class completeOrder extends StatefulWidget {
  const completeOrder({super.key});

  @override
  State<completeOrder> createState() => _completeOrderState();
}

class _completeOrderState extends State<completeOrder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Row(
                children: [
                  IconButton(
                    // ignore: prefer_const_constructors
                    icon: Icon(Icons.arrow_back_ios_new_outlined,
                        color: Colors.deepPurple),
                    onPressed: () {
                      Navigator.pop(context, '/rtrack_rider');
                    },
                  ),
                  // const SizedBox(width: 8),
                  const Text('Order Completed',
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                          color: Colors.deepPurple)),
                ],
              ),
            ),
            const SizedBox(height: 15),
            const Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 50),
                child: Text('Enjoy your meal!',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
              ),
            ),
            Container(
              // height of screen
              height: (MediaQuery.of(context).size.height * 0.5),
              child: Center(
                child: Lottie.asset(
                  'assets/lottie/b.json',
                  width: 550,
                  height: 500,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
