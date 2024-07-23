// account_service.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:quickly/loaders/loaders.dart';
import 'dart:convert';
import 'package:quickly/pages/home_page.dart';
import 'package:get_storage/get_storage.dart';

final storage = GetStorage();

class EmailVerificationService {
  Timer? _verificationTimer;

  Future<void> startEmailVerificationTimer(
      BuildContext context, String email, String password) async {
    _verificationTimer?.cancel(); // Cancel any existing timer
    _verificationTimer = Timer.periodic(
      const Duration(seconds: 30), // Check every 30 seconds
      (timer) => _checkEmailVerification(context, email, password, timer),
    );
  }

  Future<void> _checkEmailVerification(
      BuildContext context, String email, String password, Timer timer) async {
    try {
      bool isVerified = await _attemptLogin(context, email, password);

      if (isVerified) {
        timer.cancel();
        await storage.write('email_verified', true);

        // Close the verification dialog if it's open
        Navigator.of(context).popUntil((route) => route.isFirst);

        Loaders.successSnackBar(
          title: 'Email Verified',
          message: 'Your email has been successfully verified.',
        );
        Get.offAll(() =>  HomePage());
      }
    } catch (e) {
      print('Error checking email verification: $e');
    }
  }

  Future<bool> _attemptLogin(
      BuildContext context, String email, String password) async {
    const url =
        'https://us-central1-quicklyfoodapi.cloudfunctions.net/quicklyfoodapi/login';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        return responseBody['email_verified'] ?? false;
      }
    } catch (e) {
      print('Error attempting login: $e');
    }
    return false;
  }

  void stopEmailVerificationTimer() {
    _verificationTimer?.cancel();
    _verificationTimer = null;
  }
}

// Modify your showEmailVerificationDialog function
void showEmailVerificationDialog(
    BuildContext context, String message, String email, String password) {
  final emailVerificationService = EmailVerificationService();
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async {
          emailVerificationService.stopEmailVerificationTimer();
          return true;
        },
        child: AlertDialog(
          title: const Text('Verify your email'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                emailVerificationService.stopEmailVerificationTimer();
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        ),
      );
    },
  );

  emailVerificationService.startEmailVerificationTimer(
      context, email, password);
}

Future<void> createAccount({
  required BuildContext context,
  required String name,
  required String email,
  required String dob,
  required String contact,
  required String password,
}) async {
  const url =
      'https://us-central1-quicklyfoodapi.cloudfunctions.net/quicklyfoodapi/signup';
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
  );
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'email': email,
        'dob': dob,
        'contact': contact,
        'password': password,
      }),
    );

    Navigator.of(context).pop();

    if (response.body.isEmpty) {
      Loaders.errorSnackBar(
        title: 'Failed to sign up',
        message: 'Empty response from the server',
      );
      return;
    }

    final responseBody = jsonDecode(response.body);

    // Debug prints to inspect the response
    print('Response status: ${response.statusCode}');
    print('Response body: $responseBody');

    if (response.statusCode == 201) {
      bool isVerified = responseBody['email_verified'] ?? false;
      String message = responseBody['message'] ??
          'User created successfully. Please check your email to verify your account.';

      //
      await storage.write('email_verified', isVerified);
      await storage.write('user_email', email);

      if (isVerified) {
        Loaders.successSnackBar(
          title: 'Sign up successful',
          message: 'Your email has been verified. You can now log in.',
        );

        await storage.write('name', name);
        await storage.write('dob', dob);
        await storage.write('contact', contact);

        Get.offAll(() =>  HomePage());
      } else {
        Loaders.successSnackBar(
          title: 'Sign up successful',
          message: message,
        );
        showEmailVerificationDialog(context, message, email, password);
      }
    } else {
      Loaders.errorSnackBar(
        title: 'Failed to sign up',
        message: responseBody['message'],
      );
    }
  } catch (e) {
    Navigator.of(context).pop();
    Loaders.errorSnackBar(
      title: 'Failed to sign up',
      message: e.toString(),
    );
    print('Network error: $e');
  }
}

// log in
Future<void> logIn({
  required BuildContext context,
  required String email,
  required String password,
}) async {
  const url =
      'https://us-central1-quicklyfoodapi.cloudfunctions.net/quicklyfoodapi/login';
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
  );
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    Navigator.of(context).pop();

    if (response.body.isEmpty) {
      Loaders.errorSnackBar(
        title: 'Failed to log in',
        message: 'Empty response from the server',
      );
      return;
    }

    final responseBody = jsonDecode(response.body);

    // Debug prints to inspect the response
    print('Response status: ${response.statusCode}');
    print('Response body: $responseBody');

    if (response.statusCode == 200) {
      Loaders.successSnackBar(
        title: 'Log in successful',
        message: 'Welcome back',
      );
      await storage.write('email_verified', true);
      Get.offAll(() =>  HomePage());
      await storage.write('user_email', email);
    } else {
      Loaders.errorSnackBar(
        title: 'Failed to log in',
        message: '$responseBody',
      );
    }
  } catch (e) {
    // Handle network error
    Navigator.of(context).pop();
    Loaders.errorSnackBar(
      title: 'Failed to log in',
      message: 'Please check your internet connection',
    );
    print('Network error: $e');
  }
}

// get profile
Future<Map<String, dynamic>> getProfile() async {
  final storage = GetStorage();
  final userEmail = storage.read('user_email') ?? '';

  if (userEmail.isEmpty) {
    throw Exception('No email found in storage');
  }

  final url =
      'https://us-central1-quicklyfoodapi.cloudfunctions.net/quicklyfoodapi/profile?email=$userEmail';

  try {
    final response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.body.isEmpty) {
      throw Exception('Empty response from the server');
    }

    final responseBody = jsonDecode(response.body);

    // Debug prints to inspect the response
    print('Response status: ${response.statusCode}');
    print('Response body: $responseBody');

    if (response.statusCode == 200) {
      return responseBody;
    } else {
      throw Exception(responseBody['message'] ?? 'Unknown error occurred');
    }
  } catch (e) {
    print('Network error: $e');
    throw Exception('Failed to get profile: $e');
  }
}

// update profile
Future<void> updateProfile({
  required BuildContext context,
  required String contact,
  required String userEmail,
}) async {
  final storage = GetStorage();
  final name = storage.read('name') ?? '';
  final dob = storage.read('dob') ?? '';

  if (userEmail.isEmpty) {
    Loaders.errorSnackBar(
      title: 'Failed to update profile',
      message: 'No email found',
    );
    return;
  }

  const url =
      'https://us-central1-quicklyfoodapi.cloudfunctions.net/quicklyfoodapi/edit_profile';
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
  );
  try {
    final response = await http.patch(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': userEmail,  // This is now serving as both email and userID
        'name': name,
        'dob': dob,
        'contact': contact,
      }),
    );

    Navigator.of(context).pop();

    if (response.statusCode == 400) {
      final responseBody = jsonDecode(response.body);
      Loaders.errorSnackBar(
        title: 'Failed to update profile',
        message: responseBody['error'] ?? 'Bad request',
      );
      return;
    }

    if (response.body.isEmpty) {
      Loaders.errorSnackBar(
        title: 'Failed to update profile',
        message: 'Empty response from the server',
      );
      return;
    }

    final responseBody = jsonDecode(response.body);

    // Debug prints to inspect the response
    print('Response status: ${response.statusCode}');
    print('Response body: $responseBody');

    if (response.statusCode == 201 || response.statusCode == 200) {
      Loaders.successSnackBar(
        title: 'Profile updated',
        message: 'Your profile has been successfully updated',
      );
      await storage.write('user_email', userEmail);
      await storage.write('name', name);
      await storage.write('dob', dob);
      await storage.write('contact', contact);
    } else {
      Loaders.errorSnackBar(
        title: 'Failed to update profile',
        message: responseBody['message'] ?? 'Unknown error occurred',
      );
    }
  } catch (e) {
    // Handle network error
    Navigator.of(context).pop();
    Loaders.errorSnackBar(
      title: 'Failed to update profile',
      message: 'Please check your internet connection',
    );
    print('Network error: $e');
  }
}