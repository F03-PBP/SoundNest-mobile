import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import 'package:soundnest_mobile/authentication/screen/login.dart';
import 'package:soundnest_mobile/authentication/services/auth_service.dart';
import 'package:soundnest_mobile/authentication/widgets/input.dart';
import 'package:soundnest_mobile/widgets/toast.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Container(
            padding:
                const EdgeInsets.only(top: 13, left: 15, bottom: 13, right: 15),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 16,
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
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
                    'Register',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  CustomInputField(
                      labelText: "Username",
                      hintText: "Enter your username",
                      useTextFormField: true,
                      controller: _usernameController,
                      errorText: "Please enter your username"),
                  const SizedBox(height: 12.0),
                  CustomInputField(
                    labelText: "Password",
                    hintText: "Enter your password",
                    useTextFormField: true,
                    controller: _passwordController,
                    errorText: "Please enter your password",
                    isPassword: true,
                  ),
                  const SizedBox(height: 12.0),
                  CustomInputField(
                      labelText: "Confirm Password",
                      hintText: "Confirm your password",
                      useTextFormField: true,
                      controller: _confirmPasswordController,
                      errorText: "Please confirm your password",
                      isPassword: true),
                  const SizedBox(height: 24.0),
                  ElevatedButton(
                    onPressed: () async {
                      String username = _usernameController.text;
                      String password1 = _passwordController.text;
                      String password2 = _confirmPasswordController.text;

                      // AuthService
                      final response = await AuthService.registerUser(
                          request, username, password1, password2);

                      if (context.mounted) {
                        if (response['success']) {
                          Toast.success(context, 'Successfully registered!');
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()),
                          );
                        } else {
                          Toast.error(context, 'Failed to register!');
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
                    child: const Text('Register'),
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
