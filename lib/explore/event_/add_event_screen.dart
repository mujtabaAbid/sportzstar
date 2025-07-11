import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sportzstar/widgets/Layout/main_layout_widget.dart';
import 'package:sportzstar/widgets/custom_button.dart';
import 'package:sportzstar/widgets/input_widget.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final ImagePicker _picker = ImagePicker();
  List<XFile> _images = [];
  final _formKey = GlobalKey<FormState>();
  bool _isloading = false;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _hostController = TextEditingController();

  DateTime? _selectedDate;
  int currentImageIndex = 0;

  Future<void> _pickImages() async {
    final picked = await _picker.pickMultiImage();
    if (picked != null) {
      setState(() {
        _images = picked.take(5).toList();
      });
    }
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

  @override
  Widget build(BuildContext context) {
    return MainLayoutWidget(
      isLoading: _isloading,
      appBar: AppBar(title: const Text("Create Event")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
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
                  color: Color.fromARGB(255, 224, 224, 224),
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
                      color: Color.fromARGB(255, 224, 224, 224),
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
              controller: _titleController,
              onSaved: (value) {},
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: InputWidget(
                  suffixIcon: const Icon(Icons.calendar_today),
                  onSaved: (value) {},
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
              heading: 'Title of Event',
              label: 'Title of Event',
              controller: _titleController,
              onSaved: (value) {},
            ),
            const SizedBox(height: 10),
            InputWidget(
              heading: 'Enter time Of Event',
              label: 'Enter time Of Event',
              controller: _timeController,
              onSaved: (value) {},
            ),
          
             const SizedBox(height: 10),
            InputWidget(
              heading: 'Location',
              label: 'Add Location',
              controller: _locationController,
              onSaved: (value) {},
            ),

            const SizedBox(height: 10),
             const SizedBox(height: 10),
            InputWidget(
              heading: 'Host Details',
              label: 'Host Details',
              controller: _titleController,
              onSaved: (value) {},
            ),

            const SizedBox(height: 20),
         CustomButton(onPressed: (){}, text: 'Create Now',)
          ],
        ),
      ),
    );
  }

 
}
