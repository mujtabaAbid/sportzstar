import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sportzstar/helper/basic_enum.dart';
import 'package:sportzstar/helper/page_navigate.dart';
import 'package:sportzstar/provider/user_provider.dart';
import 'package:sportzstar/routing/routing_constrants.dart';
import 'package:sportzstar/screens/bottom_navigation_bar.dart';
import 'package:sportzstar/widgets/Layout/main_layout_widget.dart';
import 'package:sportzstar/widgets/alerts/alert_notification_widget.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final List<TextEditingController> _controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  late Timer _timer;
  int _remainingTime = 60;
  bool _canResend = false;
  final bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _remainingTime = 60;
    _canResend = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _canResend = true;
          _timer.cancel();
        }
      });
    });
  }

  Future<void> resendOTP(String email) async {
    try {
      final response = await Provider.of<UserProvider>(
        context,
        listen: false,
      ).getCode(formData: {'email': email});

      if (response['status'] == true) {
        print('osfjsoifj--->>> ${response['details'][0]}');
        alertNotification(
          context: context,
          message: response['details'][0],
          messageType: AlertMessageType.success,
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
    _startTimer();
  }

  Future<void> verifyOtp(Map args, String otp) async {
    // Logic to resend OTP here
    print('verifyOtp email---->>>>   ${args['email']} and $otp');
    try {
      final response = await Provider.of<UserProvider>(
        context,
        listen: false,
      ).verifyOTP(formData: {'email': args['email'], 'code': otp});

      if (response['status'] == true) {
        print('verifyOtp--->>> ${response['details']}');
        alertNotification(
          context: context,
          message: response['details'],
          messageType: AlertMessageType.success,
        );
        args['route'] == 'forgetPassword'
            ? pushNamedAndRemoveUntilNavigate(
              pageName: resetPasswordScreenRoute,
              argument: args['email'],
              context: context,
            )
            : pushNamedAndRemoveUntilNavigate(
              pageName: loginScreenRoute,
              argument: args['email'],
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
      print('error in verifyOtp function--->>>>$e');
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _timer.cancel();
    super.dispose();
  }

  void _onDigitEntered(int index, String value) {
    if (value.length == 1 && index < _controllers.length - 1) {
      _focusNodes[index + 1].requestFocus();
    }
  }

  void _onKeyPressed(RawKeyEvent event, int index) {
    if (event is RawKeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as Map;

    print("Received arguments: $arguments");
    return MainLayoutWidget(
      isLoading: _isLoading,
      appBar: AppBar(title: const Text("Verify OTP")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "Enter the 4-digit OTP sent to your email",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                4,
                (index) => SizedBox(
                  width: 60,
                  child: RawKeyboardListener(
                    focusNode: FocusNode(),
                    onKey: (event) => _onKeyPressed(event, index),
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      cursorColor: Colors.black,
                      maxLength: 1,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 20, color: Colors.black),
                      decoration: InputDecoration(
                        counterText: '',
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onChanged: (value) => _onDigitEntered(index, value),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _canResend
                ? TextButton(
                  onPressed: () => resendOTP(arguments['email']),
                  child: const Text("Resend OTP"),
                )
                : Text(
                  "Resend OTP in 00:${_remainingTime.toString().padLeft(2, '0')}",
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                String otp = _controllers.map((c) => c.text).join();
                if (otp.length < 4) {
                  alertNotification(
                    context: context,
                    message: 'Please Enter 4 digit OTP',
                    messageType: AlertMessageType.error,
                  );
                } else {
                  verifyOtp(arguments, otp);
                }
                print("Entered OTP: $otp");
                // Add OTP verification logic here
              },
              child: const Text("Verify"),
            ),
          ],
        ),
      ),
    );
  }
}
