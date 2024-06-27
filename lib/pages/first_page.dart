import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:quickly/pages/log_in.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 650, // Specify a height or width to see the container
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/del.jpeg'),
                    fit: BoxFit
                        .cover, // This will make the image cover the entire container
                  ),
                ),
              ),
              const Positioned(
                top: 100,
                left: 30,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Get your food",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 45,
                      ),
                    ),
                    Text(
                      "Quickly",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 50,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 30, bottom: 10, right: 50),
                child: Text(
                  "Get started with Quickly",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.start,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Login()),);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 178, 80, 196),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  // ignore: prefer_const_constructors
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 90, vertical: 20),
                    child: const Text(
                      "Get Started",
                      style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
