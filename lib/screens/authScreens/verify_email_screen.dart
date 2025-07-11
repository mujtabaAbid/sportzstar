import 'package:flutter/material.dart';
import 'package:sportzstar/helper/basic_enum.dart';
import 'package:sportzstar/screens/authScreens/otp_verify_screen.dart';
import 'package:sportzstar/screens/bottom_navigation_bar.dart';
import 'package:sportzstar/widgets/custom_button.dart';
import 'package:sportzstar/widgets/input_widget.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool isEmailSent = false;

  void _resendEmail() {
    setState(() {
      isEmailSent = true;
    });
      _continue();
    // TODO: Add actual resend logic (e.g., Firebase)
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Verification email resent')));
  }

  void _continue() {
    // TODO: Check if email is verified before allowing navigation
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const OTPScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                highlightErrorBorder: true,
                onSaved: (value) {
                },
                fieldType: InputType.email,
              ),
          
              if (isEmailSent) ...[
                const SizedBox(height: 10),
                const Text(
                  'Verification email has been resent.',
                  style: TextStyle(color: Colors.green),
                ),
              ],
                  const SizedBox(height: 40),
                  CustomButton(onPressed: _resendEmail, text: 'Continue'),
              // SizedBox(
              //   width: double.infinity,
              //   child: ElevatedButton(
              //     onPressed: _continue,
              //     child: const Text('Continue'),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
