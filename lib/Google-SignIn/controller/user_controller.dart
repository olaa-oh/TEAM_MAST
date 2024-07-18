import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:quickly/Model/user_model.dart';
import 'package:quickly/repository/user_repository.dart';
// import 'package:myapp/utils/loaders/loaders.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  final userRepository = Get.put(UserRepository());

  Future<void> SaveUserRecord(UserCredential? userCredentials) async {
    try {
      if (userCredentials != null) {
        // final nameParts =
        //     UserModel.nameParts(userCredentials.user!.displayName ?? '');
        // final username =
            // UserModel.generateUsername(userCredentials.user!.displayName ?? '');

        // Map data
        final user = UserModel(
          id: userCredentials.user!.email ?? '',
          name: userCredentials.user!.displayName ?? '',
          email: userCredentials.user!.email ?? '',
          contact: userCredentials.user!.phoneNumber ?? '',
          dob: '',
          profile_image: userCredentials.user!.photoURL ?? '',
        );

        // Save user data
        await userRepository.saveUserRecord(user);
      }
    } catch (e) {
    //   Loaders.warningSnackBar(
    //       title: 'Data not saved',
    //       message: 'Something went wrong trying to save');
    // }
  }
}
}