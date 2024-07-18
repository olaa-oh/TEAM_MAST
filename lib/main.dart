import 'package:flutter/material.dart';
import 'package:quickly/pages/cover_page.dart';
import 'package:quickly/pages/home_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'DM Sans',
        colorScheme:ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true
      ),
      home: const SplashScreen()
    );
  }
}
