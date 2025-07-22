import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sportzstar/config/palette.dart';
import 'package:sportzstar/helper/captaliza.dart';
import 'package:sportzstar/helper/local_storage.dart';
import 'package:sportzstar/provider/user_provider.dart';
import 'package:sportzstar/widgets/Layout/main_layout_widget.dart';
import 'package:sportzstar/widgets/custom_button.dart';
import 'package:sportzstar/widgets/input_widget.dart';

import '../../helper/basic_enum.dart';
import '../../helper/close_keyboard.dart';
import '../../provider/home_provider.dart';
import '../../widgets/alerts/alert_notification_widget.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  Map<String, dynamic> userData = {};
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {};
  List<String> sportsCategories = [];

  File? _image;
  final _usernameController = TextEditingController();
  final _bioController = TextEditingController();
  final _medalController = TextEditingController();
  final _ageController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  // String _selectCateory = 'Professional';
  // String _selectedGender = 'male';
  String? _selectedPlatform;
  final TextEditingController _linkController = TextEditingController();
  final bool _isSaved = false;
  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _image = File(picked.path);
      });
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _ageController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  Future<void> _selectYear(BuildContext context) async {
    final currentYear = DateTime.now().year;
    int? selectedYear;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select Year'),
          content: SizedBox(
            width: 300,
            height: 300,
            child: YearPicker(
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
              initialDate: DateTime(
                int.tryParse(userData['start_year']) ?? 2000,
              ),
              selectedDate: DateTime(
                int.tryParse(userData['start_year']) ?? 2000,
              ),
              onChanged: (DateTime dateTime) {
                selectedYear = dateTime.year;
                Navigator.of(context).pop();
                handleSave('start_year', selectedYear.toString());
              },
            ),
          ),
        );
      },
    );

    if (selectedYear != null) {
      dobController.text = "$selectedYear";
    }
  }

  Future<void> getUserData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final pref = await getDataFromLocalStorage(name: 'userData');
      userData = json.decode(pref);
      print('userData =====>>>$userData');
      // _selectedGender = userData['gender'];
    } catch (e) {
      print('error in getting user data------>>>>>>>$e');
    }
    // setState(() {
    //   _isLoading = false;
    // });
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

      // final sports = List<Map<String, dynamic>>.from(response);

      sportsCategories.clear(); // optional: clear previous data
      for (var item in response) {
        sportsCategories.add(item['game_name']);
      }
      print('✅ All getSports:-------------------> $sportsCategories');
    } catch (e) {
      print('❌ Error getSports:--------e---------> $e');
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getUserData();
    getSports();
    super.initState();
  }

  String handleSave(String type, String value) {
    return _formData[type] = value;
  }

  Future<void> handleSubmit(StateSetter setModalState) async {
    setState(() {
      _isLoading = true;
    });
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      closeKeyboard(context: context);

      try {
        final response = await Provider.of<UserProvider>(
          context,
          listen: false,
        ).updateUserProfile(formData: _formData);

        // alertNotification(
        //   context: context,
        //   message: 'Comment Saved',
        //   messageType: AlertMessageType.success,
        // );
      } catch (e) {
        alertNotification(
          context: context,
          message: 'Something went wrong, try again later.',
          messageType: AlertMessageType.error,
        );
        print('Error saving comment: $e');
      }
    } else {
      alertNotification(
        context: context,
        message: 'Please enter a valid comment.',
        messageType: AlertMessageType.error,
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainLayoutWidget(
      isLoading: _isLoading,
      appBar: AppBar(title: const Text('Edit Profile'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage:
                        _image != null
                            ? FileImage(_image!)
                            : userData['profile_picture'] != null &&
                                userData['profile_picture']
                                    .toString()
                                    .isNotEmpty
                            ? NetworkImage(userData['profile_picture'])
                            : const AssetImage('assets/profile/profile.jpeg')
                                as ImageProvider,
                  ),
                ),
                const SizedBox(height: 20),

                // FirstName Field
                InputWidget(
                  highlightErrorBorder: true,
                  onSaved: (value) {
                    handleSave('full_name', value ?? userData['full_name']);
                  },
                  heading: 'Full Name',
                  label: userData['full_name'],
                ),
                const SizedBox(height: 16),
                // Email Field
                InputWidget(
                  onSaved:
                      (value) =>
                          handleSave('email', value ?? userData['email']),
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
                  label: userData['email'] ?? 'Email Address',
                  // icon: 'assets/images/icons/email.png',
                ),
                const SizedBox(height: 16),
                // age
                InputWidget(
                  keyboardType: TextInputType.number,
                  highlightErrorBorder: true,
                  onSaved: (value) {
                    handleSave('age', value ?? userData['age']);
                  },
                  fieldType: InputType.number,
                  heading: 'Date of Birth',
                  label: userData['age'].toString(),
                ),
                const SizedBox(height: 16),
                // Gender Dropdown
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        'Gender',
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: capitalize(userData['gender'] ?? 'Male'),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  decoration: const InputDecoration(
                    labelStyle: TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Color.fromARGB(255, 224, 224, 224),
                    // labelText: 'Gender',
                    border: OutlineInputBorder(),
                  ),
                  items:
                      ['Male', 'Female', 'Other']
                          .map(
                            (gender) => DropdownMenuItem(
                              value: gender,
                              child: Text(gender),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    handleSave('gender', value!.toLowerCase());
                    // setState(() {
                    //   _selectedGender = value!;
                    // });
                  },
                ),
                const SizedBox(height: 16),
                //Player Category
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        'Player Category',
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value:
                      sportsCategories.contains(userData['player_category'])
                          ? userData['player_category']
                          : 'Batminton',
                  decoration: const InputDecoration(
                    labelStyle: TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Color.fromARGB(255, 224, 224, 224),
                    // labelText: 'Gender',
                    border: OutlineInputBorder(),
                  ),
                  items:
                      sportsCategories
                          // ['Professional', 'Practice', 'Timepass']
                          .map(
                            (category) => DropdownMenuItem(
                              value: category,
                              child: Text(category),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    print(
                      'ksdjfhsdjhifgsdihfgiusdghiusdhfiusdjhf----->>>>$value',
                    );
                    handleSave('player_category', value!);
                    // setState(() {
                    //   _selectCateory = value!;
                    // });
                  },
                ),
                const SizedBox(height: 16),
                //bios
                InputWidget(
                  controller: _bioController,
                  highlightErrorBorder: true,
                  onSaved: (value) {
                    handleSave('bio', value ?? userData['bio']);
                  },
                  heading: 'Bio',
                  label: userData['bio'] ?? 'Bio',
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Padding(
                    // padding: const EdgeInsets.all(8.0),
                    // child:
                    Text(
                      'Start Year',
                      style: TextStyle(color: Colors.black, fontSize: 14),
                      // ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextField(
                  style: const TextStyle(color: Colors.black),
                  controller: dobController,
                  readOnly: true,
                  onTap: () => _selectYear(context),

                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Palette.basicgray,
                    hintText: userData['start_year'] ?? "YYYY",
                    labelStyle: TextStyle(color: Colors.black),
                    hintStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                ),
                // Age Field
                const SizedBox(height: 16),
                // Medals
                InputWidget(
                  controller: _medalController,
                  highlightErrorBorder: true,
                  onSaved: (value) {
                    // handleSave('email', value);
                    handleSave('medals', value ?? userData['medals']);
                  },
                  heading: 'Medals',
                  label: userData['medals'] ?? 'Medals',
                ),

                const SizedBox(height: 16),
                //social_links
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        'Social Links',
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  hint: Text('Slelct Link'),
                  decoration: const InputDecoration(
                    labelStyle: TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Color.fromARGB(255, 224, 224, 224),
                    // labelText: 'Gender',
                    border: OutlineInputBorder(),
                  ),
                  items:
                      ['Facebook', 'Instagram', 'Twitter']
                          .map(
                            (category) => DropdownMenuItem(
                              value: category,
                              child: Text(category),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    print(
                      'ksdjfhsdjhifgsdihfgiusdghiusdhfiusdjhf----->>>>$value',
                    );
                    // handleSave('platform', value!);
                    // setState(() {
                    //   _selectCateory = value!;
                    // });
                  },
                ),
                const SizedBox(height: 16),
                //social_links
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        'Career History',
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  hint: Text('Career History'),
                  decoration: const InputDecoration(
                    labelStyle: TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Color.fromARGB(255, 224, 224, 224),
                    // labelText: 'Gender',
                    border: OutlineInputBorder(),
                  ),
                  items:
                      ['Facebook', 'Instagram', 'Twitter']
                          .map(
                            (category) => DropdownMenuItem(
                              value: category,
                              child: Text(category),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    print(
                      'ksdjfhsdjhifgsdihfgiusdghiusdhfiusdjhf----->>>>$value',
                    );
                    // handleSave('platform', value!);
                    // setState(() {
                    //   _selectCateory = value!;
                    // });
                  },
                ),

                const SizedBox(height: 20),

                // Show editable or read-only field depending on saved status
                if (_selectedPlatform != null)
                  !_isSaved
                      ? TextFormField(
                        controller: _linkController,
                        decoration: InputDecoration(
                          labelText: 'Enter $_selectedPlatform link',
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter the link';
                          }
                          if (!Uri.parse(value.trim()).isAbsolute) {
                            return 'Please enter a valid URL';
                          }
                          return null;
                        },
                      )
                      : TextFormField(
                        enabled: false,
                        decoration: InputDecoration(
                          labelText: _selectedPlatform,
                          hintText: _linkController.text,
                          border: const OutlineInputBorder(),
                        ),
                      ),

                const SizedBox(height: 20),

                // Show save button only if not saved yet
                if (_selectedPlatform != null && !_isSaved)
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.save),
                    label: const Text('Save'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
