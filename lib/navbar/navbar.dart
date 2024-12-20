import 'package:flutter/material.dart';
import 'package:soundnest_mobile/products/screen/product_page.dart';
import 'package:soundnest_mobile/authentication/screen/profile.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({Key? key}) : super(key: key);

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  // List of pages corresponding to each tab in the bottom navigation bar
  static const List<Widget> _pages = <Widget>[
    ProductPage(), // Replace with your actual Home page widget
    Center(child: Text('Best Deals')), // Placeholder for Best Deals
    Center(child: Text('Discussions')), // Placeholder for Discussions
    Center(child: Text('Wishlist')), // Placeholder for Wishlist
    ProfilePage(), // Replace with your actual Profile page widget
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Disable animation
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFF362417), // Selected item color
        unselectedItemColor: Colors.grey, // Unselected item color
        showUnselectedLabels: false,
        showSelectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_offer_outlined),
            label: 'Best Deals',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.forum_outlined),
            label: 'Discussions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border_outlined),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
