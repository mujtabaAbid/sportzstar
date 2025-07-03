import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:sportzstar/helper/basic_enum.dart';
import 'package:sportzstar/screens/authScreens/signup_screen.dart';
import 'package:sportzstar/widgets/Layout/main_layout_widget.dart';
import 'package:sportzstar/widgets/input_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
   bool _isLoading = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return MainLayoutWidget(
      isLoading: _isLoading,
      appBar: AppBar(title: const Text("Login")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              InputWidget(
                highlightErrorBorder: true,
                controller: emailController,
                onSaved: (value) {},
                fieldType: InputType.email,
              ),
        
                      SizedBox(
                        height: 20,
                      ),
                      InputWidget(
                        highlightErrorBorder: true,
                        onSaved: (value) {
                          
                        },
                        validator: ValidationBuilder()
                            .minLength(8, 'Minimum 8 Characters')
                            .build(),
                        keyboardType: TextInputType.visiblePassword,
                        heading: 'Password',
                        label: 'Password',
                        // icon: 'assets/images/icons/key.png',
                        controller: passwordController,
                        obscureText: obscurePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Theme.of(context).primaryColorDark,
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
                  onPressed: () {
                    // TODO: Implement forget password action
                  },
                  child: const Text('Forget Password?'),
                ),
              ),
        
              const SizedBox(height: 24),
        
              // Sign In Button
              ElevatedButton(
                onPressed: () {
                  // TODO: Handle sign in logic
                },
                child: const Text('Sign In'),
              ),
        
              const SizedBox(height: 24),
        
              // Sign Up Redirect
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()));
                      // pushNamedNavigate(context: context, pageName: );
                    },
                    child: const Text("Sign Up"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}