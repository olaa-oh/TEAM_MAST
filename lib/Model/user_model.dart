import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:myapp/helpers/formatter.dart';

class UserModel {
  final String id;
  String name;
  final String email;
  String contact;
  String dob;
  String profile_image;

  // Constructor for UserModel
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.dob,
    required this.contact,
    required this.profile_image,
  });

  // Helper function to get the full name
  // String get fullname => '$firstname $lastname';

  // Helper function to get formatted phone number
  // String get formattedPhoneNo => Formatter.formatPhoneNumber(phoneNumber);

  // Static function to split full name into first and lastname
  // static List<String> nameParts(String fullname) => fullname.split(" ");

  // Static function to generate a username from the full name
  // static String generateUsername(String fullname) {
  //   List<String> nameParts = fullname.split(" ");

  //   // This line hmmmmmm
  //   if (nameParts.isEmpty) return "cwt_user";

  //   String firstname = nameParts[0].toLowerCase();
  //   String lastname = nameParts.length > 1 ? nameParts[1].toLowerCase() : "";

  //   String camelCaseUsername = "$firstname$lastname";
  //   String usernameWithPrefix = "cwt_$camelCaseUsername";
  //   return usernameWithPrefix;
  // }

  // Static function to create an empty user model.
  static UserModel empty() => UserModel(
        id: '',
        name: '',
        email: '',
        dob: '' ,
        contact: '',
        profile_image: '',
      );

  // Convert Model to Json structure for storing data in Firebase
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'dob': dob,
      'contact': contact,
      'profile_image': "",
    };
  }

  // Factory method to create a UserModel from a Firebase document snapshot
  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    if (data != null) {
      return UserModel(
        id: data['email'],
        name: data['name'] ?? '',
        email: data['email'] ?? '',
        dob: data['dob'] ?? '',
        contact: data['contact'] ?? '',
        profile_image: '',
      );
    } else {
      return UserModel.empty(); // Handle null data case
    }
  }
}
