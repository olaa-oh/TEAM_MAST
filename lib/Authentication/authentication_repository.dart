import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quickly/authentication/Screens/login/log_in.dart';
// import 'package:myapp/authentication/screens/onboarding/onboarding.dart';
// import 'package:myapp/authentication/screens/signup/verify_email.dart';
import 'package:quickly/Exceptions/firebase_exceptions.dart';
import 'package:quickly/pages/create_account.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();
  // final GlobalKey<FormState> formKey = GlobalKey<FormState>();


  // Variables
  // final deviceStorage = GetStorage();
  final _auth = FirebaseAuth.instance;

  // Calling this from main.dart on app launch
  @override
  void onReady() {
    screenRedirect();
  }

  // Functions to show relevant Screen based on authentication
  screenRedirect() async {
    final user = _auth.currentUser;
    if (user != null) {
      if (user.emailVerified) {
        Get.offAll(() => const Login());
      } else {
        Get.off(() => const CreateAccount());
      }
    } else {
      // Local Storage
      // deviceStorage.writeIfNull('isFirstTime', true);
      // // If it is the first time for the user, we visit the onboardingscreen else the LoginScreen
      // deviceStorage.read('isFirstTime') != true
      //     ? Get.offAll(() => const LoginScreen())
      //     : Get.offAll(const onBoardingScreen());
    }
  }

  /*---- Email & Password Sign-in */
  Future<UserCredential> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw QuicklyFirebaseException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  // EmailAuthentication - SignIn

  // EmailAuthentication - Register
  // Future<UserCredential> registerWithEmailAndPassword(
  //     String email, String password) async {
  //   return await _auth.createUserWithEmailAndPassword(
  //       email: email, password: password);
  // }

  // ReAuthenticate - Reauthenticate user

  // EmailVerification
  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw QuicklyFirebaseException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  // EmailAuthentication - Forgot Password

  /*--- Federated Identity & Social Sign In */

  // GoogleAuthentication
  Future<UserCredential?> signInwithGoogle() async {
    try {
      final GoogleSignInAccount? userAccont = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await userAccont?.authentication;

      // Create a new credential
      final credentials = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Store data to firestore
      return await _auth.signInWithCredential(credentials);
    } on FirebaseAuthException catch (e) {
      throw QuicklyFirebaseException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  // FacebookAuthentication

  /*--- End of Federated Identity & Social Sign In */

  //LogoutUser - Valid for any authentication
  // Future<void> logout() async {
  //   try {
  //     await FirebaseAuth.instance.signOut();
  //     Get.offAll(() => const LoginScreen());
  //   } on FirebaseAuthException catch (e) {
  //     throw MFirebaseException(e.code).message;
  //   } catch (e) {
  //     throw 'Something went wrong. Please try again';
  //   }
  // }

  // Delete User - Remove User Auth and Firestore account
}
