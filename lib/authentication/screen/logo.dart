import 'package:flutter/material.dart';
import 'package:soundnest_mobile/authentication/screen/login.dart';

class LogoPage extends StatefulWidget {
  const LogoPage({super.key});

  @override
  State<LogoPage> createState() => _LogoPageState();
}

class _LogoPageState extends State<LogoPage> {
  @override
  void initState() {
    super.initState();

    // Menunggu selama 3 detik sebelum berpindah ke halaman login
    Future.delayed(const Duration(seconds: 3), () {
      // Navigasi ke halaman login setelah 3 detik
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.primary,
        child: const Center(
          child: Text(
            "SoundNest",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.0,
              fontFamily: 'Inter',
            ),
          ),
        ),
      ),
    );
  }
}
