import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sportzstar/widgets/Layout/main_layout_widget.dart';

import '../../config/palette.dart';
import '../../helper/basic_enum.dart';
import '../../helper/close_keyboard.dart';
import '../../provider/home_provider.dart';
import '../../provider/user_provider.dart';
import '../../widgets/alerts/alert_notification_widget.dart';
import '../../widgets/input_widget.dart';

class BasicProfileScreen extends StatefulWidget {
  const BasicProfileScreen({super.key});

  @override
  State<BasicProfileScreen> createState() => _BasicProfileScreenState();
}

class _BasicProfileScreenState extends State<BasicProfileScreen> {
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {};
  List<Map<String, dynamic>> sportsCategories = [];
  final TextEditingController _categoryController = TextEditingController();
  final List<String?> selectedItems = [];
  final List<TextEditingController> controllers = [];

  final List<String> allOptions = [
    'Facebook',
    'Instagram',
    'Twitter',
    'Linkedin',
  ];

  File? _image;

  @override
  void initState() {
    super.initState();
    getSports();
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

  void addNewItem() {
    if (selectedItems.length < allOptions.length) {
      selectedItems.add(null); // Placeholder for the new dropdown
      controllers.add(TextEditingController());
      setState(() {});
    }
  }

  List<String> getRemainingOptions(int index) {
    final used =
        selectedItems.where((item) => item != null).cast<String>().toList();
    if (selectedItems[index] != null) {
      used.remove(selectedItems[index]); // Allow re-selecting the current
    }
    return allOptions.where((item) => !used.contains(item)).toList();
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _image = File(picked.path);
      });
    }
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
        ).updateBasicUserProfile(formData: _formData);

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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Basic Profile', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          margin: EdgeInsets.only(top: 80),
          child: Form(
            key: _formKey,
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              // spacing: 20,
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        _image != null
                            ? FileImage(_image!)
                            // assets/images/FB.png
                            : const AssetImage('assets/profile/user.png')
                                as ImageProvider,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Text(
                        'Bio',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextField(
                  style: const TextStyle(color: Colors.white),
                  maxLines: 5,
                  onSubmitted: (value) => handleSave('bio', value),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(51, 224, 224, 224),
                    hintText: "Add Bio here",
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
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Padding(
                    // padding: const EdgeInsets.only(left: 8),
                    // child:
                    Text(
                      'Gender',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    // ),
                  ],
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: 'Male',
                  style: TextStyle(color: Colors.white),
                  dropdownColor: const Color.fromARGB(255, 64, 64, 64),
                  // borderRadius: BorderRadius.all(Radius.circular(12),),
                  decoration: InputDecoration(
                    labelStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Color.fromARGB(51, 224, 224, 224),
                    // labelText: 'Gender',
                    // border: OutlineInputBorder(),
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

                SizedBox(height: 16),
                InputWidget(
                  keyboardType: TextInputType.number,
                  highlightErrorBorder: true,
                  onSaved: (value) {
                    handleSave('age', value);
                  },
                  fieldType: InputType.number,
                  heading: 'Age',
                  label: 'Age',
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

                // playerType,
                TextFormField(
                  controller: _categoryController,
                  readOnly: true,
                  onTap: () async {
                    final selectedCategory = await _showCategoryModal(context);
                    if (selectedCategory != null) {
                      _categoryController.text = selectedCategory;
                      handleSave('player_category', selectedCategory);
                    }
                  },
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        16,
                      ), // ✅ Rounded corners
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      ), // ✅ Invisible border
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
                    filled: true,
                    fillColor: Color.fromARGB(51, 224, 224, 224),
                    suffix: Icon(
                      Icons.arrow_drop_down_sharp,
                      color: const Color.fromARGB(255, 137, 137, 137),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        'Social Links',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                
                Column(
                  children: List.generate(selectedItems.length, (index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DropdownButtonFormField<String>(
                          value: selectedItems[index],
                          hint: Text('Select Link'),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color.fromARGB(215, 180, 13, 13),
                            // border: OutlineInputBorder(),
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
                              borderSide: BorderSide(
                                color: Palette.facebookColor,
                              ),
                            ),
                          ),
                          items:
                              getRemainingOptions(index)
                                  .map(
                                    (option) => DropdownMenuItem(
                                      value: option,
                                      child: Text(option),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedItems[index] = value!;
                            });
                          },
                        ),
                        if (selectedItems[index] == null) ...[
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: controllers[index],
                            cursorColor: Colors.white,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                            ),
                            decoration: InputDecoration(
                              labelStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              hintText: 'Enter ${selectedItems[index]} link',
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.0),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                  width: 2.0,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          if (index == selectedItems.length - 1 &&
                              selectedItems.whereType<String>().length <
                                  allOptions.length)
                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                icon: Icon(
                                  Icons.add_circle,
                                  color: Colors.blue,
                                  size: 30,
                                ),
                                onPressed: addNewItem,
                              ),
                            ),
                          const SizedBox(height: 20),
                        ],
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
