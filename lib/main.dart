import 'package:flutter/material.dart';

import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import 'package:soundnest_mobile/authentication/screen/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider(
        create: (_) {
          CookieRequest request = CookieRequest();
          return request;
        },
        child: MaterialApp(
          title: 'SoundNest',
          theme: ThemeData(
            colorScheme: const ColorScheme(
              primary: Color(0xFF362417),
              primaryContainer: Color(0xFF3B3D77),
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
          home: const LoginPage(),
        ));
  }
}
