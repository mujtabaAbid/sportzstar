import 'package:flutter/material.dart';

import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:sportzstar/config/palette.dart';
import 'package:sportzstar/widgets/custom_button.dart';
import 'package:sportzstar/widgets/input_widget.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  File? _image;
  final _usernameController = TextEditingController();
  final _bioController = TextEditingController();
  final _medalController = TextEditingController();
  final _ageController = TextEditingController();
    final TextEditingController dobController = TextEditingController();
 String _selectCateory = 'Professional';
  String _selectedGender = 'Male';
    String? _selectedPlatform;
 final TextEditingController _linkController = TextEditingController();
  bool _isSaved = false;
  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _image = File(picked.path);
      });
    }
  }

  void _saveProfile() {
    final username = _usernameController.text.trim();
    final age = _ageController.text.trim();

    if (username.isEmpty || age.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields')),
      );
      return;
    }

    // TODO: Save profile logic here (e.g., update database or local storage)

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully')),
    );
  }
 
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
  void dispose() {
    _usernameController.dispose();
    _ageController.dispose();
    _linkController.dispose();
    super.dispose();
  }

void _saveData() {
    if (_formKey.currentState != null &&
        _formKey.currentState!.validate() &&
        _selectedPlatform != null) {
      setState(() {
        _isSaved = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Saved: $_selectedPlatform → ${_linkController.text}'),
        ),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile Image Picker
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage:
                      _image != null
                          ? FileImage(_image!)
                          : const AssetImage('assets/profile/profile.jpeg')
                              as ImageProvider,
                  child:
                      _image == null
                          ? const Icon(
                            Icons.camera_alt,
                            size: 30,
                            color: Colors.white,
                          )
                          : null,
                ),
              ),
              const SizedBox(height: 20),

              // Username Field
              InputWidget(
                controller: _usernameController,
                highlightErrorBorder: true,
                onSaved: (value) {
                  // handleSave('email', value);
                },
                heading: 'Full Name',
                label: 'Full Name',
              ),
              const SizedBox(height: 16),
               Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Date of Birth',
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ),
                ),
              ],
            ),
               TextField(
              style: const TextStyle(color: Colors.black),
              controller: dobController,
              readOnly: true,
              onTap: () => _selectDate(context),
              decoration: InputDecoration(
                filled: true,
                fillColor: Palette.basicgray,
                hintText: "DD/MM/YYYY",
                labelStyle: TextStyle(color: Colors.black),
                hintStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
            ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text('Gender', style: TextStyle(color: Colors.black, fontSize: 14),),
                  ),
                ],
              ),
                const SizedBox(height: 8),
              // Gender Dropdown
              DropdownButtonFormField<String>(
                value: _selectedGender,
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
                  setState(() {
                    _selectedGender = value!;
                  });
                },
              ),
               const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text('Player Category', style: TextStyle(color: Colors.black, fontSize: 14),),
                  ),
                ],
              ),
                const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectCateory,
                decoration: const InputDecoration(
                  labelStyle: TextStyle(color: Colors.black),
                  filled: true,
                  fillColor: Color.fromARGB(255, 224, 224, 224),
                  // labelText: 'Gender',
                  border: OutlineInputBorder(),
                ),
                items:
                    ['Professional', 'Practice', 'Timepass']
                        .map(
                          (category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectCateory = value!;
                  });
                },
              ),
              const SizedBox(height: 8),
               InputWidget(
                controller: _bioController,
                highlightErrorBorder: true,
                onSaved: (value) {
                  // handleSave('email', value);
                },
                heading: 'Bio',
                label: 'Bio',
              ),
             
              // Age Field
             
            const SizedBox(height: 8),
              InputWidget(
                controller: _medalController,
                highlightErrorBorder: true,
                onSaved: (value) {
                  // handleSave('email', value);
                },
                heading: 'Medals',
                label: 'Medals',
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Select Platform',
                  border: OutlineInputBorder(),
                ),
                value: _selectedPlatform,
                items: ['Instagram', 'Twitter', 'Facebook']
                    .map((platform) => DropdownMenuItem<String>(
                          value: platform,
                          child: Text(platform),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPlatform = value;
                    _linkController.clear();
                    _isSaved = false;
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select a platform' : null,
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
                  onPressed: _saveData,
                  icon: const Icon(Icons.save),
                  label: const Text('Save'),
                ),

            ],
          ),
        ),
      ),
    );
  }
}
