import 'package:flutter/material.dart';

class confirmPage extends StatefulWidget {
  const confirmPage({super.key});

  @override
  State<confirmPage> createState() => _confirmPageState();
}

class _confirmPageState extends State<confirmPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: 
      Center(
        child: Text("Confirm Order"),
        )
    );
  }
}