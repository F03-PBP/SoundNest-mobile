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
            secondary: Color(0xFFC5A684),
            secondaryContainer: Color(0xFF958069),
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
          '/review': (context) => const ReviewsPage(
              productId: 'e87e8646-7fc1-429a-ad46-50349e44a99f'),
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
  late Future<void> _loadUserFuture;

  @override
  void initState() {
    super.initState();
    final userModel = Provider.of<UserModel>(context, listen: false);
    _loadUserFuture = Future.delayed(const Duration(seconds: 3), () async {
      await userModel.loadUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadUserFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LogoPage(); // LogoPage on loading
        } else if (snapshot.connectionState == ConnectionState.done) {
          final userModel = Provider.of<UserModel>(context, listen: false);
          if (userModel.isLoggedIn) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacementNamed(context, '/review');
            });
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacementNamed(context, '/login');
            });
          }
          return const SizedBox.shrink();
        } else {
          return const LogoPage();
        }
      },
    );
  }
}
