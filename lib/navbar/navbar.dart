import 'package:flutter/material.dart';

import 'package:soundnest_mobile/BestDeals/screens/list_bestdeals.dart';
import 'package:soundnest_mobile/products/screen/product_page.dart';
import 'package:soundnest_mobile/authentication/screen/profile.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  // Pages Navbar
  static const List<Widget> _pages = <Widget>[
    ProductPage(),
    BestDealsPage(),
    Center(child: Text('Discussions')), // Placeholder for Discussions
    Center(child: Text('Wishlist')), // Placeholder for Wishlist
    ProfilePage(),
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
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_rounded,
              color: Theme.of(context).colorScheme.secondaryContainer,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_offer_rounded,
                color: Theme.of(context).colorScheme.secondaryContainer),
            label: 'Best Deals',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.forum_rounded,
                color: Theme.of(context).colorScheme.secondaryContainer),
            label: 'Discussions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_rounded,
                color: Theme.of(context).colorScheme.secondaryContainer),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded,
                color: Theme.of(context).colorScheme.secondaryContainer),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
