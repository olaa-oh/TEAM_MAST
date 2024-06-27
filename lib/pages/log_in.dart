import 'package:flutter/material.dart';
import 'package:quickly/pages/create_account.dart';
import 'package:quickly/pages/home_page.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return 
    Scaffold(
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.only(top: 100, left: 40, right: 40, bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Log in",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 15),
            const Text(
              "Welcome back! Please enter your details.",
              style: TextStyle(
                fontSize: 16,
                color: Color.fromARGB(255, 74, 84, 88),
              ),
            ),
            const SizedBox(height: 60),
            const Text(
              "Email",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 8, bottom: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
            const Text(
              "Password",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 8, bottom: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
                obscureText: true,
              ),
            ),
            const Align(
              alignment: Alignment.bottomRight,
              child: Text(
                "Forgot Password",
                style: TextStyle(
                    color: Colors.purple, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: const Text(
                  "Log In",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Center(
              child: Text(
                "Or Log in with",
                style: TextStyle(
                    color: Color.fromARGB(187, 72, 67, 67),
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: const Image(
                  image: AssetImage(
                    'assets/images/google.png',
                  ),
                  fit: BoxFit.cover,
                  width: 40,
                  height: 40,
                ),
              ),
            ),
            const SizedBox(height: 40),
             Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account?",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 5),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,MaterialPageRoute(builder: (context) => const CreateAccount()),
                );
                  },
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                        color: Colors.purple,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
