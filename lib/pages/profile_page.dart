import 'package:flutter/material.dart';
import 'package:quickly/constants/colors.dart';
import 'package:quickly/pages/update_profile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
        ),
        body: Container(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              // Profile Picture
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: const Image(
                            image: AssetImage('assets/images/de.jpeg'),
                            fit: BoxFit.cover)),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: AppColors.primary),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
        
              const SizedBox(height: 20),
        
              // Name
              const Text(
                'John Doe',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
        
              // Email
              const Text(
                'something@gmail.com',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
        
              const SizedBox(height: 20),
        
              // Edit Profile
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // go to update profile page
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const UpdateProfile()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Edit Profile',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                ),
              ),
        
              const SizedBox(height: 20),
              

              const Spacer(),
        
              // logout
             const Divider(),
              ListTile(
                onTap: () {
                  // logout
                },
                leading: Container(
                  width: 50,
                  height: 50,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.red[100],
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: const Center(
                      child: Icon(Icons.logout, color: Colors.red)),
                ),
                title: const Text('Logout',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ));
  }
}
