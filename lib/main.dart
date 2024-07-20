import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickly/Authentication/authentication_repository.dart';
import 'package:quickly/connections/network_manager.dart'; // Add this import
import 'package:quickly/firebase_options.dart';
import 'package:quickly/pages/cover_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((FirebaseApp value) {
    Get.put(AuthenticationRepository());
    Get.put(NetworkManager()); // Ensure NetworkManager is put here
  });
  
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            fontFamily: 'DM Sans',
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true),
        home: const SplashScreen());
  }
}
