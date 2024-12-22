import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:soundnest_mobile/authentication/models/user_model.dart';
import 'package:soundnest_mobile/authentication/screen/login.dart';
import 'package:soundnest_mobile/navbar/navbar.dart';

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
            // User already logged in
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const MainNavigation(),
                ));
          } else {
            // User not logged in
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
          child: Image(
            image: AssetImage('assets/images/soundnestlogo.png'),
            width: 160, // Adjust width as needed
            height: 160, // Adjust height as needed
            fit: BoxFit.contain, // Ensures the logo fits nicely
          ),
        ),
      ),
    );
  }
}
