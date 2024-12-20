import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import 'package:soundnest_mobile/authentication/models/user_model.dart';
import 'package:soundnest_mobile/authentication/screen/profile.dart';
import 'package:soundnest_mobile/authentication/screen/register.dart';
import 'package:soundnest_mobile/authentication/services/auth_service.dart';
import 'package:soundnest_mobile/authentication/widgets/input.dart';
import 'package:soundnest_mobile/widgets/toast.dart';

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
    final userModel = Provider.of<UserModel>(context);

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

                      // AuthService
                      final response = await AuthService.loginUser(
                          request, username, password, userModel);

                      if (context.mounted) {
                        if (response['success']) {
                          // Get data dari response
                          String message = response['data']['message'];
                          String uname = response['data']['username'];
                          bool isSuperuser =
                              response['data']['is_superuser'] ?? false;
                          String userToken = response['data']['token'];

                          Provider.of<UserModel>(context,
                                  listen: false) // Pass data ke UserModel
                              .setUser(uname, isSuperuser, userToken);

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ProfilePage()),
                          );

                          Toast.success(context, "$message Welcome, $uname!");
                        } else {
                          Toast.error(
                            context,
                            response['message'],
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor:
                          Theme.of(context).colorScheme.secondaryContainer,
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
                        text: 'Don\'t have an account? ',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 14.0,
                        ),
                        children: const <TextSpan>[
                          TextSpan(
                            text: 'Register',
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
