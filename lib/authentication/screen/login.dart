import 'package:flutter/material.dart';

import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:soundnest_mobile/BestDeals/screens/list_bestdeals.dart';
import 'package:soundnest_mobile/authentication/models/user_model.dart';

import 'package:soundnest_mobile/authentication/screen/register.dart';
import 'package:soundnest_mobile/reviews/screen/reviews.dart';
import 'package:soundnest_mobile/authentication/widgets/input.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Align(
          alignment: Alignment.topLeft,
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.only(top: 64, left: 16, right: 16, bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sign in',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  CustomInputField(
                    labelText: "Username",
                    hintText: "Enter your username",
                    controller: _usernameController,
                  ),
                  const SizedBox(height: 12.0),
                  CustomInputField(
                      labelText: "Password",
                      hintText: "Enter your password",
                      controller: _passwordController,
                      isPassword: true),
                  const SizedBox(height: 24.0),
                  ElevatedButton(
                    onPressed: () async {
                      String username = _usernameController.text;
                      String password = _passwordController.text;

                      // Untuk menyambungkan Android emulator dengan Django pada localhost,
                      // gunakan URL http://10.0.2.2/
                      final response = await request
                          .login("http://127.0.0.1:8000/auth/flutter/login/", {
                        'username': username,
                        'password': password,
                      });

                      if (request.loggedIn) {
                        String message = response['message'];
                        String uname = response['username'];
                        bool isSuperuser = response['is_superuser'] ?? true;

                        if (context.mounted) {
                          Provider.of<UserModel>(context, listen: false)
                              .setUser(uname, isSuperuser);

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const BestDealsPage()),
                          );
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(
                              SnackBar(
                                  content:
                                      Text("$message Selamat datang, $uname dengan role $isSuperuser.")),
                            );
                        }
                      } else {
                        if (context.mounted) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Login Gagal'),
                              content: Text(response['message']),
                              actions: [
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterPage()),
                      );
                    },
                    child: Text.rich(
                      TextSpan(
                        text: 'Don\'t have an account? ', // Teks biasa
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 14.0,
                        ),
                        children: const <TextSpan>[
                          TextSpan(
                            text: 'Register', // Teks bold
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
