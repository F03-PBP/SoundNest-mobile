import 'package:flutter/material.dart';

import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:soundnest_mobile/authentication/models/user_model.dart';

import 'package:soundnest_mobile/authentication/screen/login.dart';
import 'package:soundnest_mobile/authentication/screen/logo.dart';
import 'package:soundnest_mobile/authentication/screen/profile.dart';
import 'package:soundnest_mobile/reviews/screen/reviews.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final userModel = UserModel();
  await userModel.loadUser(); // Load user from SharedPreferences

  runApp(MyApp(userModel: userModel));
}

class MyApp extends StatelessWidget {
  final UserModel userModel;

  const MyApp({super.key, required this.userModel});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (_) => CookieRequest(),
        ),
        ChangeNotifierProvider.value(
          value: userModel,
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
        home: const SplashScreen(),
        routes: {
          '/login': (context) => const LoginPage(),
          '/profile': (context) => const ProfilePage(),
          '/review': (context) => const ReviewsPage(),
        },
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();

    final userModel = Provider.of<UserModel>(context, listen: false);
    Future.delayed(const Duration(seconds: 3), () async {
      await userModel.loadUser();

      if (!_hasNavigated && mounted) {
        setState(() {
          _hasNavigated = true;
        });

        final currentRoute = ModalRoute.of(context)?.settings.name;
        if (userModel.isLoggedIn) {
          if (currentRoute != '/') {
            Navigator.pushReplacementNamed(context, '/review');
          }
        } else {
          Navigator.pushReplacementNamed(context, '/login');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const LogoPage();
  }
}
