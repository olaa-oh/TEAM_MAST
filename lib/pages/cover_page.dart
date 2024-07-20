// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/widgets.dart';
// import 'package:quickly/pages/first_page.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen>
//     with SingleTickerProviderStateMixin {
//   @override
//   void initState() {
//     super.initState();
//     // removes the status bar at the top of the screen
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

//     // set a timer when it moves to another page
//     Future.delayed(const Duration(seconds: 3), () {
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(
//           builder: (_) => const FirstPage(),
//         ),
//       );
//     });
//   }

//   @override
//   void dispose() {
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
//         overlays: SystemUiOverlay.values);
//     super.dispose();
//   }

//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(color: Colors.white),
//         child: const Center(
//           child: Text(
//             "QUICKLY",
//             style: TextStyle(
//               fontFamily: 'DM Sans',
//               fontSize: 30,
//               fontWeight: FontWeight.bold,
//               color: Colors.purple,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:quickly/Authentication/Screens/login/log_in.dart';
import 'package:quickly/pages/first_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    // Check user authentication state
    Future.delayed(const Duration(seconds: 3), () async {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final User? user = _auth.currentUser; // Fetch the current user

      if (user != null) {
        if (user.emailVerified) {
          Get.offAll(() => const FirstPage());
        } else {
          Get.offAll(() => const Login()); // Navigate to Login if email is not verified
        }
      } else {
        Get.offAll(() => const Login()); // Navigate to Login if user is not authenticated
      }
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: const Center(
          child: Text(
            "QUICKLY",
            style: TextStyle(
              fontFamily: 'DM Sans',
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.purple,
            ),
          ),
        ),
      ),
    );
  }
}
