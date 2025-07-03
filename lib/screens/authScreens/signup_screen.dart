import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:sportzstar/helper/basic_enum.dart';
import 'package:sportzstar/widgets/input_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController referralController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  String? selectedGender;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      dobController.text = "${picked.day}/${picked.month}/${picked.year}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // First & Last Name in Row
           Row(
                  children: [
                    Expanded(
                      child: InputWidget(
                        highlightErrorBorder: true,
                        validator: ValidationBuilder().build(),
                        keyboardType: TextInputType.text,
                        onSaved: (value) {
                          // handleSave('first_name', value);
                          // Now we will get location from backend
                          // handleSave('longitude', longitude.toString());
                          // handleSave('latitude', latitude.toString());
                        },
                        heading: 'First Name',
                        label: 'First Name',
                        // icon: 'assets/images/icons/user.png',
                        textCapitalization: TextCapitalization.words,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: InputWidget(
                        highlightErrorBorder: true,
                        validator: ValidationBuilder().build(),
                        keyboardType: TextInputType.text,
                        onSaved: (value) {},
                        heading: 'Last Name',
                        label: 'Last Name',
                        // icon: 'assets/images/icons/user.png',
                        textCapitalization: TextCapitalization.words,
                      ),
                    ),
                  ],
                ),
            const SizedBox(height: 16),

            // Date of Birth Picker
            TextField(
              controller: dobController,
              readOnly: true,
              onTap: () => _selectDate(context),
              decoration: const InputDecoration(
                labelText: "Date of Birth",
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
            ),
            const SizedBox(height: 16),

            // Gender Selection
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Gender", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
            RadioListTile<String>(
              title: const Text("Male"),
              value: "Male",
              groupValue: selectedGender,
              onChanged: (value) => setState(() => selectedGender = value),
            ),
            RadioListTile<String>(
              title: const Text("Female"),
              value: "Female",
              groupValue: selectedGender,
              onChanged: (value) => setState(() => selectedGender = value),
            ),
            RadioListTile<String>(
              title: const Text("Other"),
              value: "Other",
              groupValue: selectedGender,
              onChanged: (value) => setState(() => selectedGender = value),
            ),

            const SizedBox(height: 8),

             InputWidget(
                  highlightErrorBorder: true,
                  onSaved: (value) {},
                  fieldType: InputType.email,
                ),
                SizedBox(
                  height: 10,
                ),
                InputWidget(
                  highlightErrorBorder: true,
                  keyboardType: TextInputType.number,
                  onSaved: (value){},
                  showCountryCodePicker:
                      true, // Enables dropdown for country codes
                  headingWidget: const Row(
                    children: [
                      Text(
                        'Phone',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      Text(
                        ' (Optional)',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  // heading: 'Phone (Optional)',
                  label: 'Phone',
                  imageWidget: const Icon(
                    Icons.phone,
                    color: Colors.white,
                  ),
                  validator: (value) {
                    String pattern = r'^[0-9]{10,14}$';
                    RegExp regex = RegExp(pattern);
                    if (value == null || value.isEmpty) {
                      return null;
                    }
                    if (!regex.hasMatch(value)) {
                      return 'Enter a valid 10-digit phone number';
                    }
                    return null;
                  },
                ),
            const SizedBox(height: 16),

            // Referral Code
             InputWidget(
                  noValidator: true,
                  highlightErrorBorder: true,
                  headingWidget: const Row(
                    children: [
                      Text(
                        'Refferal Code',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      Text(
                        ' (Optional)',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  keyboardType: TextInputType.text,
                  onSaved: (value) =>{},
                  // heading: 'Refferal Code (Optional)',
                  label: 'Refferal Code',
                  imageWidget: const Icon(
                    Icons.recommend_outlined,
                    color: Colors.white,
                  ),
                ),
            const SizedBox(height: 16),

            // Password Field
         InputWidget(
                  highlightErrorBorder: true,
                  validator: ValidationBuilder()
                      .minLength(8, 'Minimum 8 Characters')
                      .build(),
                  onSaved: (value){},
                  controller: passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  heading: 'Password',
                  label: 'Password',
                  // icon: 'assets/images/icons/key.png',
                  obscureText: !obscurePassword,
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
                        // print(source);
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                InputWidget(
                  highlightErrorBorder: true,
                  validator: (value) {
                    if (value.isEmpty || value == '') {
                      return 'Please Enter Confirm Password';
                    } else if (value != passwordController.text) {
                      return 'Password Not Matched';
                    }
                  },
                  onSaved: (value) {},
                      
                  keyboardType: TextInputType.visiblePassword,
                  heading: 'Confirm Password',
                  label: 'Password',
                  // icon: 'assets/images/icons/key.png',
                  obscureText: !obscureConfirmPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureConfirmPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Theme.of(context).primaryColorDark,
                    ),
                    onPressed: () {
                      setState(() {
                        obscureConfirmPassword = !obscureConfirmPassword;
                        // print(source);
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                ElevatedButton(
              onPressed: () {

              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text("Sign Up"),
            ),
                // Container(
                //   padding: EdgeInsets.symmetric(vertical: buttonPadding),
                //   child: CustomButton(
                //     fullWidth: true,
                //     rounded: 16.0,
                //     padding: EdgeInsets.symmetric(vertical: buttonPadding),
                //     bgColor: Palette.basicSecondaryColor,
                //     onPressed: () {
                    
                //     },
                //     widget: Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         const Text(
                //           'Sign Up',
                //           style: TextStyle(fontSize: 14, color: Colors.white),
                //         ),
                //         const SizedBox(
                //           width: 6,
                //         ),
                //         Image.asset(
                //           'assets/images/icons/sheart.png',
                //           scale: 1.8,
                //         )
                //       ],
                //     ),
                //   ),
                // ),
          ],
        ),
      ),
    );
  }
}