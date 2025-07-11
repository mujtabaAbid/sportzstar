import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:sportzstar/widgets/custom_button.dart';
import 'package:sportzstar/widgets/input_widget.dart';

import '../../widgets/Layout/main_layout_widget.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  void _sendResetLink() {
    final email = _emailController.text.trim();
    if (email.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reset link sent to $email')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayoutWidget(
       
      isLoading: false,
      // appBar: AppBar(
      //   backgroundColor: Colors.grey.shade50,
      //   title: const Text('Forgot Password'),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              const Center(
                child: Icon(Icons.lock_reset, size: 80, color: Colors.blue),
              ),
              const SizedBox(height: 20),
              const Text(
                'Forgot your password?',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Enter your email address below to receive a password reset link.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 30),
              InputWidget(onSaved: (value) {}, 
                highlightErrorBorder: true,
                controller: _emailController,
                heading: 'Email Address',
                label: 'Email Address',
                // icon: 'assets/images/icons/email.png',
              ),
              // TextField(
              //   controller: _emailController,
              //   keyboardType: TextInputType.emailAddress,
              //   decoration: const InputDecoration(
              //     labelText: 'Email Address',
              //     border: OutlineInputBorder(),
              //     prefixIcon: Icon(Icons.email),
              //   ),
              // ),
              const SizedBox(height: 20),
              CustomButton(onPressed: _sendResetLink, text: 'Send Reset Link', 
               
              ),
              // SizedBox(
              //   width: double.infinity,
              //   child: ElevatedButton(
              //     onPressed: _sendResetLink,
              //     child: const Text('Send Reset Link'),
              //   ),
              // ),
              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // Go back to Login
                  },
                  child: const Text(
                    'Back to Login',
                    style: TextStyle(
                      color: Colors.black,
                    ),
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

