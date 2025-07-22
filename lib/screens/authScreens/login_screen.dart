import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:provider/provider.dart';
import 'package:sportzstar/helper/basic_enum.dart';
import 'package:sportzstar/helper/close_keyboard.dart';
import 'package:sportzstar/helper/page_navigate.dart';
import 'package:sportzstar/provider/user_provider.dart';
import 'package:sportzstar/routing/routing_constrants.dart';
import 'package:sportzstar/screens/authScreens/forget_password_screen.dart';
import 'package:sportzstar/screens/authScreens/signup_screen.dart';
import 'package:sportzstar/screens/bottom_navigation_bar.dart';
import 'package:sportzstar/widgets/Layout/main_layout_widget.dart';
import 'package:sportzstar/widgets/custom_button.dart';
import 'package:sportzstar/widgets/input_widget.dart';

import '../../widgets/alerts/alert_notification_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  // final TextEditingController emailController = TextEditingController();
  // final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {};

  String handleSave(String type, String value) {
    return _formData[type] = value;
  }

  Future<void> handleSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      closeKeyboard(context: context);
      setState(() {
        _isLoading = true;
      });

      try {
        final response = await Provider.of<UserProvider>(
          context,
          listen: false,
        ).loginFunction(formData: _formData);
        if (response.statusCode == 200) {
          print('all response -fgdrgfd--> ${response.body}');
          alertNotification(
            context: context,
            message: 'Login successful!',
            messageType: AlertMessageType.success,
          );
          pushNamedAndRemoveUntilNavigate(
            pageName: bottomNavigationBarRoute,
            context: context,
          );
        } else {
          final message = json.decode(response.body);
          final msg = message['detail'];

          if (msg == 'Please verify your email') {
            try {
              final responsee = await Provider.of<UserProvider>(
                context,
                listen: false,
              ).getCode(formData: _formData);
              if (responsee['status'] == true) {
                alertNotification(
                  context: context,
                  message: 'Verification code sent to email.',
                  messageType: AlertMessageType.success,
                );
                pushNamedNavigate(
                  pageName: otpScreenRoute,
                  argument: {
                    'email': _formData['email'].toString(),
                    'route': 'emailverify',
                  },
                  context: context,
                );
              } else {
                alertNotification(
                  context: context,
                  message:
                      'Something Went wrong, OTP verification error, Try again later',
                  messageType: AlertMessageType.info,
                );
              }
            } catch (e) {
              print('error---------> ${e.toString()}');
              alertNotification(
                context: context,
                message:
                    'Something Went wrong, OTP verification error, Try again later.',
                messageType: AlertMessageType.info,
              );
            }
          } else {
            alertNotification(
              context: context,
              message: msg,
              messageType: AlertMessageType.warning,
            );
          }
        }
      } catch (e) {
        print('error---------> ${e.toString()}');
        alertNotification(
          context: context,
          message: 'Something Went wrong, Try again later',
          messageType: AlertMessageType.info,
        );
      }
    } else {
      print('Form is not valid');
      alertNotification(
        context: context,
        message: 'Form is not valid',
        messageType: AlertMessageType.error,
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return MainLayoutWidget(
      isLoading: _isLoading,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              Image.asset('assets/images/start.png', height: 150, width: 150),
              const SizedBox(height: 40),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    InputWidget(
                      highlightErrorBorder: true,
                      onSaved: (value) {
                        handleSave('email', value);
                      },
                      fieldType: InputType.email,
                    ),
                    SizedBox(height: 20),
                    InputWidget(
                      highlightErrorBorder: true,
                      onSaved: (value) => handleSave('password', value),
                      validator:
                          ValidationBuilder()
                              .minLength(8, 'Minimum 8 Characters')
                              .build(),
                      keyboardType: TextInputType.visiblePassword,
                      heading: 'Password',
                      label: 'Password',
                      obscureText: obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Forget Password Button
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed:
                            () => pushNamedAndRemoveUntilNavigate(
                              context: context,
                              pageName: forgetPasswordScreenRoute,
                            ),
                        child: const Text(
                          'Forget Password?',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                    CustomButton(
                      onPressed: () {
                        handleSubmit();
                      },
                      text: 'Sign In',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // Sign Up Redirect
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  TextButton(
                    onPressed: () {
                      pushNamedNavigate(
                        context: context,
                        pageName: signupScreenRoute,
                      );
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              // TextButton(
              //   onPressed: () {
              //     pushNamedNavigate(
              //       context: context,
              //       pageName: resetPasswordScreenRoute,
              //     );
              //   },
              //   child: Text('Reset Password'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
