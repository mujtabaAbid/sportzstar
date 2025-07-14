import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportzstar/helper/basic_enum.dart';
import 'package:sportzstar/helper/page_navigate.dart';
import 'package:sportzstar/routing/routing_constrants.dart';
import 'package:sportzstar/widgets/Layout/main_layout_widget.dart';
import 'package:sportzstar/widgets/Layout/reset_password_layout.dart';
import 'package:sportzstar/widgets/alerts/alert_notification_widget.dart';
import 'package:sportzstar/widgets/custom_button.dart';
import 'package:sportzstar/widgets/input_widget.dart';

import 'package:flutter/material.dart';

import '../../helper/close_keyboard.dart';
import '../../provider/user_provider.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isloading = false;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  void _resetPassword(String email) async {
    setState(() {
      _isloading = true;
    });
    closeKeyboard(context: context);

    if (_formKey.currentState!.validate()) {
      print('confirm password--->>>${_confirmPasswordController.text}');
      print('confirm password--->>>$email`');

      try {
        final response = await Provider.of<UserProvider>(
          context,
          listen: false,
        ).updatePassword(
          formData: {
            'email': email,
            'new_password': _confirmPasswordController.text,
          },
        );

        if (response['status'] == true) {
          print('osfjsoifj--->>> ${response['details']}');
          alertNotification(
            context: context,
            message: response['details'],
            messageType: AlertMessageType.success,
          );
          pushNamedAndRemoveUntilNavigate(
            pageName: loginScreenRoute,
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
        print('error in resendOtp function--->>>>$e');
      }
      setState(() {
        _isloading = false;
      });

      // Navigator.pop(context); // Or navigate to login screen
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as String;

    print("Received arguments: $arguments");
    return MainLayoutWidget(
      isLoading: _isloading,
      appBar: AppBar(title: const Text("Reset Password"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 40),
                Icon(Icons.lock_open_outlined, size: 130),
                const Text(
                  "Enter your new password below",
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),

                // New Password Field
                InputWidget(
                  onSaved: (value) {},
                  heading: 'New Password',
                  label: 'New Password',
                  controller: _newPasswordController,
                  obscureText: _obscureNewPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureNewPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureNewPassword = !_obscureNewPassword;
                      });
                    },
                  ),

                  validator: (value) {
                    if (value == null || value.length < 8) {
                      return "Password must be at least 8 characters.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Confirm Password Field
                InputWidget(
                  onSaved: (value) {},
                  heading: 'Confirm Password',
                  label: 'Confirm Password',
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value != _newPasswordController.text) {
                      return "Passwords do not match.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),

                // Reset Button
                CustomButton(
                  onPressed: () => _resetPassword(arguments),
                  text: 'Reset Password',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
