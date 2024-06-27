import 'package:flutter/material.dart';
import 'package:quickly/pages/home_page.dart';
import 'package:quickly/pages/log_in.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.only(top: 70, left: 40, right: 40, bottom: 40),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Create an account",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 15),
              const Text(
                "Welcome! Please enter your details.",
                style: TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 74, 84, 88),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Name",
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
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.manage_accounts,
                      color: Colors.grey,
                    ),
                    hintText: "Thomas Sarpong",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
              ),
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
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.email,
                      color: Colors.grey,
                    ),
                    hintText: "quarshiemorgan@gmail.com",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
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
                child: TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.lock, color: Colors.grey),
                    hintText: "**********",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                ),
              ),
              const Text(
                "Repeat Password",
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
                child: TextFormField(
                  controller: _repeatPasswordController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.lock, color: Colors.grey),
                    hintText: "**********",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please repeat your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
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
                  if (_formKey.currentState?.validate() ?? false) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  }
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
                    "Sign Up",
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
              const SizedBox(height: 30),
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
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account?",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Login()),
                      );
                    },
                    child: const Text(
                      "Log In",
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
      ),
    );
  }
}
