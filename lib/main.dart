import 'package:flutter/material.dart';
import 'package:soundnest_mobile/BestDeals/screens/list_bestdeals.dart';

import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:soundnest_mobile/authentication/models/user_model.dart';

import 'package:soundnest_mobile/authentication/screen/login.dart';
import 'package:soundnest_mobile/authentication/screen/logo.dart';
import 'package:soundnest_mobile/authentication/screen/profile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (_) => CookieRequest(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserModel(),
        ),
      ],
      child: MaterialApp(
        title: 'SoundNest',
        theme: ThemeData(
          colorScheme: const ColorScheme(
            primary: Color(0xFF362417),
            primaryContainer: Color(0xFFF4F4F4),
            secondary: Color(0xFFF9F1E7),
            secondaryContainer: Color(0xFF3B3D77),
            surface: Colors.white,
            error: Colors.red,
            onPrimary: Colors.white,
            onSecondary: Colors.black,
            onSurface: Colors.black,
            onError: Colors.white,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),
        home: const LogoPage(),
        routes: {
          '/login': (context) => const LoginPage(),
          '/profile': (context) => const ProfilePage(),
        },
      ),
    );
  }
}