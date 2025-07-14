import 'package:flutter/material.dart';
import 'package:sportzstar/helper/basic_enum.dart';
import 'package:sportzstar/routing/routing_constrants.dart';
import 'package:sportzstar/screens/authScreens/otp_verify_screen.dart';
import 'package:sportzstar/screens/bottom_navigation_bar.dart';
import 'package:sportzstar/widgets/Layout/main_layout_widget.dart';
import 'package:sportzstar/widgets/custom_button.dart';
import 'package:sportzstar/widgets/input_widget.dart';

import '../../helper/close_keyboard.dart';
import '../../helper/page_navigate.dart';
import '../../widgets/alerts/alert_notification_widget.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {};

  String handleSave(String type, String value) {
    return _formData[type] = value;
  }

  Future<void> handleSubmit() async {
    setState(() {
      _isLoading = true;
    });
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      closeKeyboard(context: context);

      print('object--->$_formData');

      // pushNamedAndRemoveUntilNavigate(
      //   pageName: otpScreenRoute,
      //   argument: {'email': _formData['email'].toString()},
      //   context: context,
      // );
    } else {
      print('Form is not valid');
      alertNotification(
        context: context,
        message: 'Please Enter Valid Email.',
        messageType: AlertMessageType.error,
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as String;

    print("Received arguments: $arguments");

    return MainLayoutWidget(
      isLoading: _isLoading,
      appBar: AppBar(title: const Text('Verify Email')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Icon(Icons.mark_email_read, size: 80, color: Colors.green),
              const SizedBox(height: 20),
              const Text(
                'Verify your email',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'We have sent a verification link to your email address. Please check your inbox and click the link to verify your account.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              InputWidget(
                // initialValue: arguments,
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
                heading: 'Email Address',
                label: 'Email Address',
              ),

              const SizedBox(height: 40),
              CustomButton(onPressed: () => handleSubmit(), text: 'Continue'),
            ],
          ),
        ),
      ),
    );
  }
}
