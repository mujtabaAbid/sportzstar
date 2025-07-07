import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:sportzstar/helper/basic_enum.dart';
import 'package:sportzstar/helper/page_navigate.dart';
import 'package:sportzstar/routing/routing_constrants.dart';
import 'package:sportzstar/screens/bottom_navigation_bar.dart';
import 'package:sportzstar/widgets/custom_button.dart';
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

  final List<String> genders = ['Male', 'Female', 'Other'];

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: 80),
            // First & Last Name in Row
           Row(
                  children: [
                    Expanded(
                      child: InputWidget(
                        highlightErrorBorder: true,
                        validator: ValidationBuilder().build(),
                        keyboardType: TextInputType.text,
                        onSaved: (value) {
                          
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
              style: const TextStyle(color: Colors.black),
              controller: dobController,
              readOnly: true,
              onTap: () => _selectDate(context),
              decoration: const InputDecoration(
                labelText: "Date of Birth",
                
                hintText: "DD/MM/YYYY",
                labelStyle: TextStyle(color: Colors.black,),
                hintStyle: TextStyle(color: Colors.black),
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
               Row(
              children: genders.map((gender) {
                final isSelected = selectedGender == gender;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedGender = gender;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color.fromARGB(255, 109, 185, 112) : Colors.white,
                        border: Border.all(
                          color: isSelected ? const Color.fromRGBO(27, 104, 52, 1) : Colors.grey,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          gender,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
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
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      ),
                      Text(
                        ' (Optional)',
                        style: TextStyle(
                          color: Colors.black,
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
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      ),
                      Text(
                        ' (Optional)',
                        style: TextStyle(
                          color: Colors.black,
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
             CustomButton(onPressed: () {
                  pushNamedNavigate(context: context, pageName: bottomNavigationBarRoute);
                },
                text: 'Sign Up',
                ),

          ],
        ),
      ),
    );
  }
}