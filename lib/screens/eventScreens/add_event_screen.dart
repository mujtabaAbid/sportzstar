import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sportzstar/config/palette.dart';
import 'package:sportzstar/provider/event_provider.dart';
import 'package:sportzstar/widgets/Layout/main_layout_widget.dart';
import 'package:sportzstar/widgets/custom_button.dart';
import 'package:sportzstar/widgets/input_widget.dart';

import '../../helper/basic_enum.dart';
import '../../helper/close_keyboard.dart';
import '../../helper/page_navigate.dart';
import '../../widgets/alerts/alert_notification_widget.dart';
import 'package:mime/mime.dart';

import '../bottom_navigation_bar.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final ImagePicker _picker = ImagePicker();
  List<XFile> _images = [];
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {};
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _hostNameController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  File? _selectedImage;
  bool _isLoading = false;

  DateTime? _selectedDate;
  int currentImageIndex = 0;

  Future<void> _pickImages() async {
    final picked = await _picker.pickMultiImage();
    setState(() {
      _images = picked.take(5).toList();
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  // Updated pick single image at specific index
  Future<void> _pickImageAtIndex(int index) async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        if (_images.length > index) {
          _images[index] = picked;
        } else {
          _images.add(picked);
        }
        currentImageIndex = index;
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  String handleSave(String type, String value) {
    return _formData[type] = value;
  }

  Future<void> handleSubmit() async {
    // setState(() {
    //   _isLoading = true;
    // });
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedImage != null) {
        if (_images.isNotEmpty) {
          _formKey.currentState?.save();

          closeKeyboard(context: context);

          if (_selectedImage != null) {
            final bytes = await _selectedImage!.readAsBytes();
            String base64Image = base64Encode(bytes);
            final mimeType =
                lookupMimeType(_selectedImage!.path) ?? 'image/jpeg';
            // Create valid data URI
            final String dataUri = 'data:$mimeType;base64,$base64Image';
            _formData.addAll({'profile_picture': dataUri});
          }

          List<String> imageList = [];
          for (XFile xfile in _images) {
            final bytes = await xfile.readAsBytes();
            String base64Image = base64Encode(bytes);

            final mimeType = lookupMimeType(xfile.path) ?? 'image/jpeg';
            final String dataUri = 'data:$mimeType;base64,$base64Image';

            imageList.add(dataUri);
          }
          _formData.addAll({'event_images': imageList});
          final eventHost = {
            'host_name': _hostNameController.text,
            'host_image': imageList.join(','),
          };
          _formData.addAll({'event_host': eventHost});

          final response = await Provider.of<EventProvider>(
            context,
            listen: false,
          ).createEvent(formData: _formData);

          if (response.statusCode == 201) {
            final responseData = json.decode(response.body);

            print('response of create Event ----->>> $responseData');
            alertNotification(
              context: context,
              message: responseData['message'],
              messageType: AlertMessageType.success,
            );

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => BottomNavigationBarScreen(pageIndex: 2),
              ),
            );
          } else {
            print('response of create Event -errror---->>> ${response.body}');
          }
        } else {
          alertNotification(
            context: context,
            message: 'Event Images Are Required',
            messageType: AlertMessageType.error,
          );
        }
      } else {
        alertNotification(
          context: context,
          message: 'Host Image is Required',
          messageType: AlertMessageType.error,
        );
      }
    } else {
      print('Form is not valid');
      alertNotification(
        context: context,
        message: 'Please Enter Required data.',
        messageType: AlertMessageType.error,
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      final now = DateTime.now();
      final dt = DateTime(
        now.year,
        now.month,
        now.day,
        pickedTime.hour,
        pickedTime.minute,
      );
      final formattedTime = TimeOfDay.fromDateTime(dt).format(context);
      _timeController.text = formattedTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayoutWidget(
      isLoading: _isLoading,
      appBar: AppBar(
        title: const Text(
          "Create Event",
          style: TextStyle(color: Colors.white),
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // TOP MAIN CONTAINER
              GestureDetector(
                onTap: () {
                  if (_images.length < 5) {
                    _pickImageAtIndex(
                      _images.length,
                    ); // Pick new image at next index
                  } else {
                    // Optionally show dialog: limit reached
                  }
                },
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(40, 224, 224, 224),
                    borderRadius: BorderRadius.circular(12),
                    image:
                        _images.isNotEmpty
                            ? DecorationImage(
                              image: FileImage(
                                File(_images[currentImageIndex].path),
                              ),
                              fit: BoxFit.cover,
                            )
                            : null,
                  ),
                  child:
                      _images.isEmpty
                          ? const Center(child: Icon(Icons.add, size: 40))
                          : null,
                ),
              ),
              const SizedBox(height: 10),

              // BOTTOM 5 IMAGE SELECTORS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () {
                      _pickImageAtIndex(index);
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Color.fromARGB(71, 224, 224, 224),
                        image:
                            _images.length > index
                                ? DecorationImage(
                                  image: FileImage(File(_images[index].path)),
                                  fit: BoxFit.cover,
                                )
                                : null,
                      ),
                      child:
                          _images.length <= index
                              ? const Icon(Icons.image, color: Colors.black54)
                              : null,
                    ),
                  );
                }),
              ),

              const SizedBox(height: 10),
              InputWidget(
                heading: 'Title of Event',
                label: 'Title of Event',
                onSaved: (value) => handleSave('event_title', value ?? ''),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: InputWidget(
                    suffixIcon: const Icon(
                      Icons.calendar_today,
                      color: Colors.white,
                    ),
                    onSaved: (value) => handleSave('event_date', value ?? ''),
                    heading: 'Select Date',
                    label: 'Select Date',
                    controller: TextEditingController(
                      text:
                          _selectedDate != null
                              ? DateFormat.yMMMMd().format(_selectedDate!)
                              : '',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              InputWidget(
                heading: 'Description of Event',
                label: 'Description of Event',
                controller: _titleController,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                onSaved:
                    (value) => handleSave('event_description', value ?? ''),
                maxLines: 5,
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => _selectTime(context),
                child: AbsorbPointer(
                  child: InputWidget(
                    heading: 'Enter time of Event',
                    label: 'Enter time 0f Event',
                    controller: _timeController,
                    onSaved: (value) => handleSave('event_time', value ?? ''),
                  ),
                ),
              ),

              const SizedBox(height: 10),
              InputWidget(
                heading: 'Location',
                label: 'Add Location',
                onSaved: (value) => handleSave('event_location', value ?? ''),
              ),

              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Host Details',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
              SizedBox(height: 6),
              Row(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage:
                          _selectedImage != null
                              ? FileImage(_selectedImage!)
                              : null,
                      child:
                          _selectedImage == null
                              ? const Icon(Icons.person, color: Colors.black)
                              : null,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      // onSaved: (value) => handleSave('host_name', value ?? ''),
                      controller: _hostNameController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Host name is required';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        hintText: 'Host Details',
                        hintStyle: const TextStyle(color: Colors.grey),

                        // ✅ This shows +XX prefix inside the input field
                        //  prefixText: widget.showCountryCodePicker ? '$selectedCountryCode ' : null,
                        prefixStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),

                        filled: true,
                        fillColor: const Color.fromARGB(51, 224, 224, 224),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(
                            color: Colors.transparent,
                            width: 2.0,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 16.0,
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              CustomButton(
                color: Palette.facebookColor,
                onPressed: () {
                  handleSubmit();
                },
                text: 'Create Now',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
