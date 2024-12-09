import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:soundnest_mobile/authentication/models/user_model.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userModel = Provider.of<UserModel>(context);

    final username = userModel.username;
    final initials = generateInitials(username);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 32),
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 50,
                child: Text(
                  initials,
                  style: TextStyle(
                      fontSize: 40,
                      color: Theme.of(context).colorScheme.primary),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                username,
                style: const TextStyle(fontSize: 24, color: Colors.white),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DevelopersPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.primary,
                  backgroundColor: Colors.white,
                ),
                child: const Text('About Us'),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  userModel.logout();
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Text(
                  'Sign Out',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  String generateInitials(String name) {
    return name.length >= 2
        ? name.substring(0, 2).toUpperCase()
        : name.toUpperCase(); // Jika username hanya 1 karakter
  }
}

// TODO: Implement DevelopersPage
class DevelopersPage extends StatelessWidget {
  const DevelopersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Developers'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: const Center(
        child: Text(
          'Developer Names Here',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
