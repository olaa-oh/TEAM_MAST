import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:quickly/constants/colors.dart';
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
                height: MediaQuery.of(context).size.height, // Specify a height or width to see the container
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/motorcycle_rider.jpg'),
                    fit: BoxFit
                        .cover, // This will make the image cover the entire container
                  ),
                ),
              ),
               const Padding(
                  padding: EdgeInsets.only(top: 50,left: 20, right: 20),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                            Text(
                              "Get your food",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 45,
                              ),
                            ),
                      SizedBox(height: 5,),
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
              Positioned(
                bottom: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 160,
                  color: Colors.white,
                  child:  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 8.0),
                          child: Text("Get started with Quickly",style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                              MaterialPageRoute(builder: (context) => const Login()),);
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            // ignore: prefer_const_constructors
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20),
                              child: const Center(
                                child: Text(
                                  "Get Started",
                                  style: TextStyle(
                                      fontSize: 22,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // const SizedBox(height: 20,)
                      ],
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
