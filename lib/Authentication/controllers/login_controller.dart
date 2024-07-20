import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:quickly/Authentication/authentication_repository.dart';
import 'package:quickly/Google-SignIn/controller/user_controller.dart';
import 'package:quickly/connections/network_manager.dart';
import 'package:quickly/loaders/custom_loader.dart';
import 'package:quickly/loaders/loaders.dart';

class LoginController extends GetxController {
  final email = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final userController = Get.put(UserController());
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Email and Password Sign In
  Future<void> emailAndPasswordSignIn() async {
    try {
      FullScreenLoader.openLoadingDialog("Signing you in...", 'assets/images/google-signIn.json');

      // final isConnected = await Get.find<NetworkManager>().isConnected(); // Use Get.find()
      // if (!isConnected) {
      //   FullScreenLoader.stopLoading();
      //   Loaders.errorSnackBar(title: 'Ooops...', message: 'No internet connection');
      //   return;
      // }

      if (!loginFormKey.currentState!.validate()) {
        FullScreenLoader.stopLoading();
        return;
      }

      final userCredentials = await AuthenticationRepository.instance
          .loginWithEmailAndPassword(email.text.trim(), password.text.trim());

      FullScreenLoader.stopLoading();
      AuthenticationRepository.instance.screenRedirect();
    } catch (e) {
      FullScreenLoader.stopLoading();
      Loaders.errorSnackBar(title: 'Ooops...', message: e.toString());
    }
  }

  Future<void> googleSignIn() async {
    try {
      print("Signing in with Google...");
      FullScreenLoader.openLoadingDialog('Signing you in...', 'assets/images/google-signIn.json');

      // final isConnected = await Get.find<NetworkManager>().isConnected(); // Use Get.find()
      // if (!isConnected) {
      //   FullScreenLoader.stopLoading();
      //   Loaders.errorSnackBar(title: 'Ooops...', message: 'No internet connection');
      //   return;
      // }

      final userCredentials = await AuthenticationRepository.instance.signInwithGoogle();

      await userController.SaveUserRecord(userCredentials);

      FullScreenLoader.stopLoading();
      AuthenticationRepository.instance.screenRedirect();
    } catch (e) {
      FullScreenLoader.stopLoading();
      Loaders.errorSnackBar(title: 'Ooops...', message: 'An error occurred during Google sign-in: $e');
    }
  }
}
