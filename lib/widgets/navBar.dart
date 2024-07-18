import 'package:flutter/material.dart';
import 'package:quickly/constants/colors.dart';

class CustomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabTapped;

  const CustomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTabTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTabTapped,
      showUnselectedLabels: true,
      selectedItemColor: AppColors.primary,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      unselectedItemColor: Colors.grey[500],
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home,
        ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list,
        ),
          label: 'Orders',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart,
         ),
          label: 'Cart',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle,
         ),
          label: 'Account',
        ),
      ],
    );
  }
}
