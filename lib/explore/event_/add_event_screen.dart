import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final ImagePicker _picker = ImagePicker();
  List<XFile> _images = [];
      final _formKey = GlobalKey<FormState>();

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
    return Scaffold(
      appBar: AppBar(title: const Text("Create Event")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // TOP MAIN CONTAINER
            GestureDetector(
              onTap: () {
                if (_images.length < 5) {
                  _pickImageAtIndex(_images.length); // Pick new image at next index
                } else {
                  // Optionally show dialog: limit reached
                }
              },
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  image:
                      _images.isNotEmpty
                      ? DecorationImage(
                          image: FileImage(File(_images[currentImageIndex].path)),
                          fit: BoxFit.cover,
                        )
                      :
                      null,
                ),
                child: _images.isEmpty
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
                      color: Colors.grey[300],
                      image:
                           _images.length > index
                          ? DecorationImage(
                              image: FileImage(File(_images[index].path)),
                              fit: BoxFit.cover,
                            )
                          :
                          null,
                    ),
                    child: _images.length <= index
                        ? const Icon(Icons.image, color: Colors.black54)
                        : null,
                  ),
                );
              }),
            ),

            const SizedBox(height: 20),
            _buildTextField("Title Of Event", _titleController),
            const SizedBox(height: 10),
            _buildTextField("About Event", _aboutController, maxLines: 4),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Select Date",
                    suffixIcon: const Icon(Icons.calendar_today),
                    border: OutlineInputBorder(),
                  ),
                  controller: TextEditingController(
                    text: 
                    _selectedDate
                    != null
                        ? DateFormat.yMMMMd().format(_selectedDate!)
                        :
                        '',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            _buildTextField(
              "Enter time Of Event",
              _timeController,
              hint: "5:30 PM to 9:00 PM",
            ),
            const SizedBox(height: 10),
            _buildTextField(
              "Location",
              _locationController,
              hint: "Bahria Town VII Islamabad",
            ),
            const SizedBox(height: 10),
            _buildTextField(
              "Host Details",
              _hostController,
              hint: "host name here",
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  // Submit event logic here
                },
                child: const Text("Create Now", style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
    String? hint,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint ?? "Please enter $label".toLowerCase(),
        border: OutlineInputBorder(),
      ),
    );
  }
}
