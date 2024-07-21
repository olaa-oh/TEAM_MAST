import 'package:flutter/material.dart';
import 'package:quickly/Authentication/services/account_service.dart';
import 'package:shimmer/shimmer.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:quickly/constants/colors.dart';
import 'package:quickly/pages/update_profile.dart';
import 'package:quickly/loaders/loaders.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoading = true;
  Map<String, dynamic>? _profileData;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    try {
      final profileData = await getProfile();
      setState(() {
        _profileData = profileData;
        _isLoading = false;

        print(_profileData);
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      Loaders.errorSnackBar(
        title: 'Failed to load profile',
        message: 'Please check your internet connection',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: _isLoading
          ? _buildShimmerLoading()
          : _buildProfileContent(),
    );
  }

  Widget _buildShimmerLoading() {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: Column(
        children: [
          _buildShimmerCircle(),
          const SizedBox(height: 20),
          _buildShimmerLine(width: 100),
          const SizedBox(height: 10),
          _buildShimmerLine(width: 200),
          const Spacer(),
          _buildShimmerLine(width: double.infinity),
        ],
      ),
    );
  }

  Widget _buildShimmerCircle() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
        ),
      ),
    );
  }

  Widget _buildShimmerLine({required double width}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: 20,
        color: Colors.white,
      ),
    );
  }

  Widget _buildProfileContent() {
    final user = _profileData?['user'] ?? {};

    return Container(
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
                  child: user['profile_image']?.isNotEmpty ?? false
                    ? Image.network(
                        user['profile_image'],
                        fit: BoxFit.cover,
                      )
                    :const Image(
                    image: AssetImage('assets/images/de.jpeg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: AppColors.primary,
                  ),
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
          Text(
            user['name'] ?? 'John Doe',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          // Email
          Text(
            user['email'] ?? 'something@gmail.com',
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          // Edit Profile
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const UpdateProfile()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.all(15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Edit Profile',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const Spacer(),
          // Logout
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
                child: Icon(Icons.logout, color: Colors.red),
              ),
            ),
            title: const Text(
              'Logout',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}