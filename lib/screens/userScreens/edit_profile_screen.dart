import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  final List<String> allOptions = ['Facebook', 'Instagram', 'Twitter'];
  final List<String?> selectedItems = [];
  final List<TextEditingController> controllers = [];

  final List<String?> selectCareerHistoryItems = [];
  File? _image;
  List<DateTime?> startDates = [];
  List<DateTime?> endDates = [];

  List<TextEditingController> startDateControllers = [TextEditingController()];
  List<TextEditingController> endDateControllers = [TextEditingController()];
  List<TextEditingController> clubNameControllers = [TextEditingController()];
  List<TextEditingController> descriptionControllers = [
    TextEditingController(),
  ];

  final _usernameController = TextEditingController();
  final _bioController = TextEditingController();
  final _medalController = TextEditingController();
  final _ageController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  // String _selectCateory = 'Professional';
  // String _selectedGender = 'male';
  final TextEditingController _linkController = TextEditingController();
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
      // final preferance = await SharedPreferences.getInstance();
      // final data = preferance.getString('userData');
      final pref = await getDataFromLocalStorage(name: 'userData');
      setState(() {
        userData = json.decode(pref);
      });
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

  void addNewItemCareerHistory() {
    setState(() {
      selectCareerHistoryItems.add('');
      controllers.add(TextEditingController());
      clubNameControllers.add(TextEditingController());
      descriptionControllers.add(TextEditingController());
      startDateControllers.add(TextEditingController());
      endDateControllers.add(TextEditingController());
      startDates.add(null);
      endDates.add(null);
      // _isLoading = false;
    });
  }

  // List<String> getRemainingOptionsCareerHistory(int index) {
  //   final used =
  //       selectCareerHistoryItems
  //           .where((item) => item != null)
  //           .cast<String>()
  //           .toList();
  //   if (selectCareerHistoryItems[index] != null) {
  //     used.remove(
  //       selectCareerHistoryItems[index],
  //     ); // Allow re-selecting the current
  //   }
  //   return allCareerHistoryOptions
  //       .where((item) => !used.contains(item))
  //       .toList();
  // }

  @override
  void initState() {
    // TODO: implement initState
    getUserData();
    getSports();
    addNewItem(); // show first dropdown initially
    addNewItemCareerHistory();
    super.initState();
  }

  String handleSave(String type, String value) {
    return _formData[type] = value;
  }

  void handleSubmit() {
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      form.save();

      // Prepare social_links array
      List<Map<String, dynamic>> socialLinks = [];
      for (int i = 0; i < selectedItems.length; i++) {
        if (selectedItems[i] != null && controllers[i].text.isNotEmpty) {
          socialLinks.add({
            "platform": selectedItems[i],
            "link": controllers[i].text,
          });
        }
      }

      // Prepare career_history array
      List<Map<String, dynamic>> careerHistory = [];
      for (int i = 0; i < selectCareerHistoryItems.length; i++) {
        careerHistory.add({
          "game_name":
              userData["player_category"] ??
              "", // or a separate field if needed
          "clubName": clubNameControllers[i].text,
          "title": controllers[i].text,
          "start_date":
              startDates[i] != null
                  ? startDates[i]!.toIso8601String().split('T')[0]
                  : "",
          "end_date":
              endDates[i] != null
                  ? endDates[i]!.toIso8601String().split('T')[0]
                  : "",
          "description": descriptionControllers[i].text,
        });
      }

      // Add start year
      String startYear = dobController.text;

      // Final data map
      Map<String, dynamic> finalData = {
        "email": _formData['email'],
        "full_name": _formData['full_name'],
        "age": int.tryParse(_formData['age'].toString()) ?? 0,
        "gender": _formData['gender'] ?? 'male',
        "player_category": _formData['player_category'],
        "bio": _formData['bio'],
        "start_year": startYear,
        "medals": _formData['medals'],
        "social_links": socialLinks,
        "career_history": careerHistory,
      };

      print('Final JSON to send: $finalData');

      // 🔁 Send this to your API
      // await ApiService.updateProfile(finalData);
    }
  }

  Future<void> pickDate(BuildContext context, int index, bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          startDates[index] = picked;
          onSaved:
          handleSave('start_date', picked.toString());
        } else {
          endDates[index] = picked;
          handleSave('end_date', picked.toString());
        }
      });
    }
  }

  String formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return MainLayoutWidget(
      isLoading: _isLoading,
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
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
                            : const AssetImage('assets/profile/user.png')
                                as ImageProvider,
                  ),
                ),
                const SizedBox(height: 20),

                // FirstName Field
                InputWidget(
                  highlightErrorBorder: true,
                  noValidator: true,
                  onSaved: (value) {
                    handleSave('email', userData['email']);
                    handleSave(
                      'full_name',
                      value.isNotEmpty ? value : userData['full_name'],
                    );
                  },
                  heading: 'Full Name',
                  label: userData['full_name'],
                  initialValue: userData['full_name'],
                ),
                // InputWidget(
                //   highlightErrorBorder: true,
                //   noValidator: true, // ValidationBuilder().build(),
                //   keyboardType: TextInputType.text,
                //   onSaved: (value) {
                //     handleSave('first_name', value);
                //   },
                //   heading: 'First Name',
                //   label: userData['first_name'] ?? 'First Name',
                //   icon: 'assets/images/icons/user.png',
                //   textCapitalization: TextCapitalization.words,
                // ),
                const SizedBox(height: 16),
                // Email Field
                // InputWidget(
                //   readOnly: true,

                //   onSaved: (value) => handleSave('email', userData['email']),
                //   highlightErrorBorder: true,
                //   heading: 'Email Address',
                //   label: userData['email'],
                // ),
                const SizedBox(height: 16),
                // age
                InputWidget(
                  keyboardType: TextInputType.number,
                  noValidator:
                      userData['age'].toString().isNotEmpty ? true : false,
                  highlightErrorBorder: true,
                  onSaved: (value) {
                    print(
                      'age value ----$value and default ----${userData['age']}',
                    );
                    handleSave(
                      'age',
                      value.isNotEmpty ? value : userData['age'].toString(),
                    );
                  },
                  fieldType: InputType.number,
                  heading: 'Age',
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
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                //gender
                DropdownButtonFormField<String>(
                  value: capitalize(userData['gender'] ?? 'Male'),
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
                const SizedBox(height: 16),
                //Player Category
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        'Player Category',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  hint: Text(
                    userData['player_category'] != null &&
                            userData['player_category'] != ''
                        ? userData['player_category']
                        : 'Select Player Category',
                  ), // <-- this shows the placeholder
                  decoration: InputDecoration(
                    labelStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Color.fromARGB(51, 224, 224, 224),
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
                      sportsCategories
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
                  },
                ),
                const SizedBox(height: 16),
                //bios
                InputWidget(
                  // controller: _bioController,
                  highlightErrorBorder: true,
                  noValidator: true,
                  onSaved: (value) {
                    handleSave(
                      'bio',
                      value.isNotEmpty ? value : userData['bio'],
                    );
                  },
                  heading: 'Bio',
                  label: userData['bio'] ?? 'Bio',
                ),
                const SizedBox(height: 16),
                //start year
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Start Year',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                      // ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextField(
                  style: const TextStyle(color: Colors.white),
                  controller: dobController,
                  readOnly: true,
                  onTap: () => _selectYear(context),

                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(51, 224, 224, 224),
                    hintText:
                        userData['start_year'].isNotEmpty
                            ? userData['start_year']
                            : "YYYY",
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
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                ),
                const SizedBox(height: 16),
                // Medals
                InputWidget(
                  controller: _medalController,
                  noValidator: true,
                  highlightErrorBorder: true,
                  onSaved: (value) {
                    // handleSave('email', value);
                    handleSave(
                      'medals',
                      value.isNotEmpty ? value : userData['medals'],
                    );
                  },
                  heading: 'Medals',
                  label:
                      userData['medals'].isNotEmpty
                          ? userData['medals']
                          : 'Medals',
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
                            fillColor: Color.fromARGB(51, 224, 224, 224),
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
                              handleSave('platform', value);
                            });
                          },
                        ),
                        if (selectedItems[index] != null) ...[
                          const SizedBox(height: 10),
                          TextFormField(
                            onSaved:
                                (newValue) => handleSave('link', newValue!),
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

                const SizedBox(height: 16),
                //social_links
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Text(
                        'Career History',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Column(
                  children: List.generate(selectCareerHistoryItems.length, (
                    index,
                  ) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          onSaved:
                              (value) => handleSave('title', value.toString()),
                          controller: controllers[index],
                          cursorColor: Colors.white,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color.fromARGB(51, 224, 224, 224),
                            labelText: 'Title',
                            labelStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            // hintText: 'e.g. Software Developer at ABC Company',
                            hintStyle: const TextStyle(color: Colors.white),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                                width: 2.0,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Club Name Field
                        TextFormField(
                          controller: clubNameControllers[index],
                          cursorColor: Colors.white,
                          onSaved:
                              (value) =>
                                  handleSave('clubName', value.toString()),
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color.fromARGB(51, 224, 224, 224),
                            labelText: 'Club Name',
                            labelStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            hintStyle: const TextStyle(color: Colors.white),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                                width: 2.0,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Description Field
                        TextFormField(
                          controller: descriptionControllers[index],
                          maxLines: 3,
                          onSaved:
                              (value) =>
                                  handleSave('description', value.toString()),
                          cursorColor: Colors.white,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color.fromARGB(51, 224, 224, 224),
                            labelText: 'Description',
                            labelStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            hintStyle: const TextStyle(color: Colors.white),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                                width: 2.0,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          style: const TextStyle(color: Colors.white),
                          controller: startDateControllers[index],
                          readOnly: true,
                          onTap: () => pickDate(context, index, true),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color.fromARGB(51, 224, 224, 224),
                            hintText:
                                startDates[index] != null
                                    ? formatDate(startDates[index]!)
                                    : "Select Start Date",
                            hintStyle: const TextStyle(color: Colors.white),
                            labelStyle: const TextStyle(color: Colors.white),
                            border: const OutlineInputBorder(),
                            suffixIcon: const Icon(Icons.calendar_today),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          style: const TextStyle(color: Colors.white),
                          controller: endDateControllers[index],
                          readOnly: true,
                          onTap: () => pickDate(context, index, false),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color.fromARGB(51, 224, 224, 224),
                            hintText:
                                endDates[index] != null
                                    ? formatDate(endDates[index]!)
                                    : "Select End Date",
                            hintStyle: const TextStyle(color: Colors.white),
                            labelStyle: const TextStyle(color: Colors.white),
                            border: const OutlineInputBorder(),
                            suffixIcon: const Icon(Icons.calendar_today),
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (index == selectCareerHistoryItems.length - 1)
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: const Icon(
                                Icons.add_circle,
                                color: Colors.blue,
                                size: 30,
                              ),
                              onPressed: addNewItemCareerHistory,
                            ),
                          ),

                        const SizedBox(height: 20),
                      ],
                    );
                  }),
                ),
                CustomButton(onPressed: () => handleSubmit(), text: 'Save'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
