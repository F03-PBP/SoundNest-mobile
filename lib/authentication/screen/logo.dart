import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:soundnest_mobile/authentication/models/user_model.dart';
import 'package:soundnest_mobile/authentication/screen/login.dart';
import 'package:soundnest_mobile/reviews/screen/reviews.dart';

class LogoPage extends StatefulWidget {
  const LogoPage({super.key});

  @override
  State<LogoPage> createState() => _LogoPageState();
}

class _LogoPageState extends State<LogoPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userModel = Provider.of<UserModel>(context, listen: false);
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          if (userModel.isLoggedIn) {
            // Sudah pernah login
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ReviewsPage(
                      productId: 'e87e8646-7fc1-429a-ad46-50349e44a99f'),
                ) // TODO: Ganti ReviewsPage
                );
          } else {
            // Belum login
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.secondary,
        child: const Center(
          child: Text(
            "SoundNest",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
            ),
          ),
        ),
      ),
    );
  }
}
