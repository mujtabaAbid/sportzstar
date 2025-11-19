import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:provider/provider.dart';
import 'package:sportzstar/config/palette.dart';
import 'package:sportzstar/helper/basic_enum.dart';
import 'package:sportzstar/helper/page_navigate.dart';
import 'package:sportzstar/provider/home_provider.dart';
import 'package:sportzstar/routing/routing_constrants.dart';
import 'package:sportzstar/screens/authScreens/verify_email_screen.dart';
import 'package:sportzstar/widgets/Layout/main_layout_widget.dart';
import 'package:sportzstar/widgets/custom_button.dart';
import 'package:sportzstar/widgets/input_widget.dart';

import '../../helper/close_keyboard.dart';
import '../../provider/user_provider.dart';
import '../../widgets/alerts/alert_notification_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController dobController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  final TextEditingController _categoryController = TextEditingController();

  String? selectedGender;

  final List<String> genders = ['male', 'female'];
  List<Map<String, dynamic>> sportsCategories = [];
  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime(2000),
  //     firstDate: DateTime(1900),
  //     lastDate: DateTime.now(),
  //   );

  //   if (picked != null) {
  //     dobController.text = "${picked.day}/${picked.month}/${picked.year}";
  //   }
  // }
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      // Set DOB text in MM/DD/YYYY format
      dobController.text =
          "${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}/${picked.year}";

      // Calculate age
      DateTime today = DateTime.now();
      int age = today.year - picked.year;

      // Adjust if birthday has not occurred yet this year
      if (today.month < picked.month ||
          (today.month == picked.month && today.day < picked.day)) {
        age--;
      }

      // Example: Print age or assign it to a variable
      print("Age is $age");
      handleSave('age', age.toString());
      // You can also set it to a controller if you have one like ageController.text = age.toString();
    }
  }

  Future<void> getSports() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response =
          await Provider.of<HomeProvider>(
            context,
            listen: false,
          ).getAllSports();

      sportsCategories.clear();
      for (var item in response) {
        sportsCategories.add(item); // store the full map
      }
      print('✅ All getSports:-------------------> $sportsCategories');
    } catch (e) {
      print('❌ Error getSports:--------e---------> $e');
    }
    setState(() {
      _isLoading = false;
    });
  }

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
      setState(() {
        _isLoading = true;
      });

      print('object--->$_formData');
      try {
        final response = await Provider.of<UserProvider>(
          context,
          listen: false,
        ).signupFunction(formData: _formData);

        // print('responmses 2342---->>>>  ${response.body}');
        if (response['status'] == true) {
          print('all response -fgdrgfd--> $response');
          final String message = response['details'][0];
          alertNotification(
            context: context,
            message: message,
            messageType: AlertMessageType.success,
          );

          pushNamedNavigate(
            pageName: otpScreenRoute,
            argument: {
              'email': _formData['email'].toString(),
              'route': 'signup',
            },
            context: context,
          );
        } else {
          print('all response -fgsdfsderrordrgfd--> ${response['details']}');

          final message = response;
          final details = message['details'] as Map<String, dynamic>;
          final firstKey = details.keys.first;
          final firstErrorList = details[firstKey];
          final msg = (firstErrorList as List).first;

          alertNotification(
            context: context,
            message: msg.toString(),
            messageType: AlertMessageType.error,
          );
        }
      } catch (e) {
        print('error--in-signup-------> ${e.toString()}');
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

  Future<String?> _showCategoryModal(BuildContext context) async {
    return await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.85,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Select Your Category',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: sportsCategories.length,
                    itemBuilder: (context, index) {
                      final sport = sportsCategories[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.pop(context, sport['game_name']);
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          height: 140,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(sport['game_picture']),
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.4),
                                BlendMode.darken,
                              ),
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            sport['game_name'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getSports();
  }

  @override
  Widget build(BuildContext context) {
    return MainLayoutWidget(
      isLoading: _isLoading,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 80),
              // full & user Name in Row
              Row(
                children: [
                  Expanded(
                    child: InputWidget(
                      highlightErrorBorder: true,
                      validator: ValidationBuilder().build(),
                      keyboardType: TextInputType.text,
                      onSaved: (value) => handleSave('full_name', value),
                      heading: 'Full Name',
                      label: 'Full Name',
                      // icon: 'assets/images/icons/user.png',
                      textCapitalization: TextCapitalization.words,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: InputWidget(
                      highlightErrorBorder: true,
                      validator: ValidationBuilder().build(),
                      keyboardType: TextInputType.text,
                      onSaved: (value) => handleSave('username', value),
                      heading: 'User Name',
                      label: 'User Name',
                      // icon: 'assets/images/icons/user.png',
                      textCapitalization: TextCapitalization.words,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

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
                heading: 'Email Address',
                label: 'Email Address',
                // icon: 'assets/images/icons/email.png',
              ),
              const SizedBox(height: 6),

              // Date of Birth Picker
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Date of Birth',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ],
              ),
              TextField(
                style: const TextStyle(color: Colors.white),
                controller: dobController,

                readOnly: true,
                onTap: () => _selectDate(context),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color.fromARGB(51, 224, 224, 224),
                  hintText: "MM/DD/YYYY",
                  labelStyle: TextStyle(color: Colors.white),
                  hintStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Palette.facebookColor),
                  ),
                  suffixIcon: Icon(Icons.calendar_today, color: Colors.white),
                ),
              ),

              const SizedBox(height: 8),

              // Gender Selection
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
                  child: Text(
                    "Gender",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
              Row(
                children:
                    genders.map((gender) {
                      final isSelected = selectedGender == gender;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedGender = gender;
                              handleSave('gender', selectedGender.toString());
                              print(
                                'selected gender =======>>>. $selectedGender',
                              );
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? Palette.facebookColor
                                      : Palette.basicgray,
                              border: Border.all(
                                color:
                                    isSelected
                                        ? Palette.facebookColor
                                        : Palette.basicgray,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                gender,
                                style: TextStyle(
                                  color:
                                      // Colors.white,
                                      isSelected ? Colors.white : Colors.black,
                                  fontWeight:
                                      isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Padding(
                  // padding: const EdgeInsets.only(left: 8),
                  // child:
                  Text(
                    'Player Type',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  // ),
                ],
              ),
              const SizedBox(height: 8),

              // // playerType,
              // TextFormField(
              //   controller: _categoryController,
              //   readOnly: true,
              //   onTap: () async {
              //     final selectedCategory = await _showCategoryModal(context);
              //     if (selectedCategory != null) {
              //       _categoryController.text = selectedCategory;
              //       handleSave('player_category', selectedCategory);
              //     }
              //   },
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Please select player category';
              //     }
              //     return null;
              //   },
              //   style: const TextStyle(color: Colors.white),
              //   decoration: InputDecoration(
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(
              //         16,
              //       ), // ✅ Rounded corners
              //       borderSide: BorderSide(
              //         color: Colors.transparent,
              //       ), // ✅ Invisible border
              //     ),
              //     enabledBorder: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(16),
              //       borderSide: BorderSide(color: Colors.transparent),
              //     ),
              //     focusedBorder: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(16),
              //       borderSide: BorderSide(color: Colors.transparent),
              //     ),
              //     hintText: 'Select Player Category',
              //     filled: true,
              //     fillColor: Color.fromARGB(51, 224, 224, 224),
              //     suffixIcon: const Icon(
              //       Icons.arrow_drop_down_outlined,
              //       color: Color.fromARGB(255, 137, 137, 137),
              //     ),
              //   ),
              // ),
              DropdownButtonFormField<String>(
                initialValue:
                    _categoryController.text.isEmpty
                        ? null
                        : _categoryController.text,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  hintText: 'Select Player Category',
                  hintStyle: const TextStyle(
                    color: Color.fromARGB(255, 180, 180, 180),
                  ),
                  filled: true,
                  fillColor: const Color.fromARGB(51, 224, 224, 224),
                ),
                dropdownColor: const Color(
                  0xFF1E1E1E,
                ), // ✅ Dark dropdown background
                icon: const Icon(
                  Icons.arrow_drop_down_outlined,
                  color: Color.fromARGB(255, 137, 137, 137),
                ),
                style: const TextStyle(
                  color: Colors.white, // ✅ Selected value color
                  fontSize: 16,
                ),
                items:
                    sportsCategories.map<DropdownMenuItem<String>>((sport) {
                      return DropdownMenuItem<String>(
                        value: sport['game_name'],
                        child:
                        // Row(
                        //   children: [
                        // ClipRRect(
                        //   borderRadius: BorderRadius.circular(8),
                        //   child: Image.network(
                        //     sport['game_picture'],
                        //     width: 40,
                        //     height: 40,
                        //     fit: BoxFit.cover,
                        //   ),
                        // ),
                        // const SizedBox(width: 10),
                        Text(
                          sport['game_name'],
                          style: const TextStyle(
                            color:
                                Colors.white, // ✅ White text in dropdown list
                          ),
                        ),
                        // ],
                        // ),
                      );
                    }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    _categoryController.text = value;
                    handleSave('player_category', value);
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select player category';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),
              // Password Field
              InputWidget(
                onSaved: (value) => handleSave('pass', value),
                heading: 'Password',
                label: 'Password',
                controller: passwordController,
                obscureText: obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      obscurePassword = !obscurePassword;
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
                onSaved: (value) => handleSave('password', value),
                heading: 'Confirm Password',
                label: 'Confirm Password',
                controller: confirmPasswordController,
                obscureText: obscureConfirmPassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    obscureConfirmPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      obscureConfirmPassword = !obscureConfirmPassword;
                    });
                  },
                ),
                validator: (value) {
                  if (value != passwordController.text) {
                    return "Passwords do not match.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              CustomButton(
                background: Palette.facebookColor,
                onPressed: () {
                  print('object-----sam,i');
                  handleSubmit();
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => const VerifyEmailScreen(),
                  //   ),
                  // );
                },
                text: 'Sign Up',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
