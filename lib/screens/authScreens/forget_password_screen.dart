import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportzstar/config/palette.dart';
import 'package:sportzstar/widgets/custom_button.dart';
import 'package:sportzstar/widgets/input_widget.dart';

import '../../helper/basic_enum.dart';
import '../../helper/close_keyboard.dart';
import '../../helper/page_navigate.dart';
import '../../provider/user_provider.dart';
import '../../routing/routing_constrants.dart';
import '../../widgets/Layout/main_layout_widget.dart';
import '../../widgets/alerts/alert_notification_widget.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  bool _isLoading = false;
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
        ).getCode(formData: _formData);

        // print('responmses 2342---->>>>  ${response.body}');
        if (response['status'] == true) {
          print('osfjsoifj--->>> ${response['details'][0]}');
          alertNotification(
            context: context,
            message: response['details'][0],
            messageType: AlertMessageType.success,
          );

          pushNamedNavigate(
            pageName: otpScreenRoute,
            argument: {
              'email': _formData['email'].toString(),
              'route': 'forgetPassword',
            },
            context: context,
          );
        } else {
          final msg = response['details'];

          alertNotification(
            context: context,
            message: msg,
            messageType: AlertMessageType.error,
          );
        }
      } catch (e) {
        print('error----11-----> ${e.toString()}');
      }
    } else {
      print('Form is not valid');
      // alertNotification(
      //   context: context,
      //   message: 'Please Fill the form.',
      //   messageType: AlertMessageType.error,
      // );
    }
    setState(() {
      _isLoading = false;
    });
  }
  // final TextEditingController _emailController = TextEditingController();

  // void _sendResetLink() {
  //   final email = _emailController.text.trim();

  //   if (email.isNotEmpty) {
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text('Reset link sent to $email')));
  //   } else {
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(const SnackBar(content: Text('Please enter your email')));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return MainLayoutWidget(
      isLoading: _isLoading,

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              Center(
                child: Icon(
                  Icons.lock_reset,
                  size: 80,
                  color: Palette.basicgreen,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Forgot your password?',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Enter your email address below to receive a Verification Code.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    InputWidget(
                      onSaved: (value) => handleSave('email', value),
                      highlightErrorBorder: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required';
                        }
                        final emailRegex = RegExp(
                          r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$",
                        );
                        if (!emailRegex.hasMatch(value)) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                      // controller: _emailController,
                      heading: 'Email Address',
                      label: 'Email Address',
                      // icon: 'assets/images/icons/email.png',
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      onPressed: () => handleSubmit(),
                      text: 'submit',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // Go back to Login
                  },
                  child: const Text(
                    'Back to Login',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
