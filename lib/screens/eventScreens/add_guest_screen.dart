import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sportzstar/config/palette.dart';
import 'package:sportzstar/screens/bottom_navigation_bar.dart';
import 'package:sportzstar/widgets/Layout/main_layout_widget.dart';
import 'package:sportzstar/widgets/custom_button.dart';

import '../../helper/basic_enum.dart';
import '../../helper/close_keyboard.dart';
import '../../provider/event_provider.dart';
import '../../widgets/alerts/alert_notification_widget.dart';
import 'tabbar_screen.dart';
import 'package:mime/mime.dart';

class AddGuestScreen extends StatefulWidget {
  final String eventId;
  const AddGuestScreen({super.key, required this.eventId});

  @override
  State<AddGuestScreen> createState() => _AddGuestScreenState();
}

class _AddGuestScreenState extends State<AddGuestScreen> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {};

  File? _selectedImage;
  final TextEditingController _nameController = TextEditingController();

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

  Future<void> handleSubmit() async {
    // setState(() {
    //   _isLoading = true;
    // });
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedImage != null) {
        _formKey.currentState?.save();
        closeKeyboard(context: context);

        final bytes = await _selectedImage!.readAsBytes();
        String base64Image = base64Encode(bytes);
        final mimeType = lookupMimeType(_selectedImage!.path) ?? 'image/jpeg';
        final String dataUri = 'data:$mimeType;base64,$base64Image';

        final guestData = {
          'event_id': widget.eventId,
          'event_guests': [
            {
              'guest_name': _nameController.text,
              'guest_image': dataUri,
            }, //all data set
          ],
        };

        _formData.addAll(guestData);

        final response = await Provider.of<EventProvider>(
          context,
          listen: false,
        ).addGuestInEvent(formData: _formData);

        if (response.statusCode == 201) {
          alertNotification(
            context: context,
            message: 'Guest Added',
            messageType: AlertMessageType.success,
          );

          showDialog(
            context: context,
            barrierDismissible: false, // Prevent closing by tapping outside
            builder:
                (context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  contentPadding: const EdgeInsets.all(20),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 60,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Success!',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Image and guest name successfully added.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      if (_selectedImage != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            _selectedImage!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      const SizedBox(height: 8),
                      Text(
                        _nameController.text,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => BottomNavigationBarScreen(
                                        pageIndex: 2,
                                        eventIndex: 1,
                                      ),
                                ),
                                (route) => false,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[300],
                              foregroundColor: Colors.black,
                            ),
                            child: const Text('Done'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context); // close dialog
                              setState(() {
                                _selectedImage = null;
                                _nameController.clear();
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.lightBlue,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Add More'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
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

  // void _addNow() {
  //   String name = _nameController.text.trim();
  //   if (name.isEmpty || _selectedImage == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Please add image and name')),
  //     );
  //     return;
  //   }
  //   // showDialog(
  //   //   context: context,
  //   //   barrierDismissible: false, // Prevent closing by tapping outside
  //   //   builder:
  //   //       (context) => AlertDialog(
  //   //         shape: RoundedRectangleBorder(
  //   //           borderRadius: BorderRadius.circular(16),
  //   //         ),
  //   //         contentPadding: const EdgeInsets.all(20),
  //   //         content: Column(
  //   //           mainAxisSize: MainAxisSize.min,
  //   //           children: [
  //   //             const Icon(Icons.check_circle, color: Colors.green, size: 60),
  //   //             const SizedBox(height: 16),
  //   //             const Text(
  //   //               'Success!',
  //   //               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  //   //             ),
  //   //             const SizedBox(height: 10),
  //   //             Text(
  //   //               'Image and guest name successfully added.',
  //   //               textAlign: TextAlign.center,
  //   //               style: const TextStyle(fontSize: 16),
  //   //             ),
  //   //             const SizedBox(height: 16),
  //   //             if (_selectedImage != null)
  //   //               ClipRRect(
  //   //                 borderRadius: BorderRadius.circular(10),
  //   //                 child: Image.file(
  //   //                   _selectedImage!,
  //   //                   width: 100,
  //   //                   height: 100,
  //   //                   fit: BoxFit.cover,
  //   //                 ),
  //   //               ),
  //   //             const SizedBox(height: 8),
  //   //             Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
  //   //             const SizedBox(height: 20),
  //   //             Row(
  //   //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //   //               children: [
  //   //                 ElevatedButton(
  //   //                   onPressed: () {
  //   //                     // Navigator.pushAndRemoveUntil(
  //   //                     //   context,
  //   //                     //   MaterialPageRoute(
  //   //                     //     builder:
  //   //                     //         (context) => BottomNavigationBarScreen(
  //   //                     //           pageIndex: 2,
  //   //                     //           eventIndex: 1,
  //   //                     //         ),
  //   //                     //   ),
  //   //                     //   (route) => false,
  //   //                     // );
  //   //                     // Navigator.pop(context); // close dialog
  //   //                     // Navigator.pop(context); // go back to previous screen
  //   //                   },
  //   //                   style: ElevatedButton.styleFrom(
  //   //                     backgroundColor: Colors.grey[300],
  //   //                     foregroundColor: Colors.black,
  //   //                   ),
  //   //                   child: const Text('Done'),
  //   //                 ),
  //   //                 ElevatedButton(
  //   //                   onPressed: () {
  //   //                     Navigator.pop(context); // close dialog
  //   //                     setState(() {
  //   //                       _selectedImage = null;
  //   //                       _nameController.clear();
  //   //                     });
  //   //                   },
  //   //                   style: ElevatedButton.styleFrom(
  //   //                     backgroundColor: Colors.lightBlue,
  //   //                     foregroundColor: Colors.white,
  //   //                   ),
  //   //                   child: const Text('Add More'),
  //   //                 ),
  //   //               ],
  //   //             ),
  //   //           ],
  //   //         ),
  //   //       ),
  //   // );
  // }

  @override
  Widget build(BuildContext context) {
    return MainLayoutWidget(
      isLoading: _isLoading,
      appBar: AppBar(
        title: Text('Add Guest', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                'Add spicial guest in your envent',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(40, 224, 224, 224),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child:
                      _selectedImage == null
                          ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.add, size: 30),
                              SizedBox(height: 8),
                              Text('Add image here'),
                            ],
                          )
                          : ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              _selectedImage!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 250,
                            ),
                          ),
                ),
              ),
              const SizedBox(height: 16),
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Guest Name here',
                    filled: true,
                    fillColor: const Color.fromARGB(51, 224, 224, 224),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Name is required';
                    }
                    return null; // return null when validation passes
                  },
                ),
              ),
              const SizedBox(height: 30),

              // const Spacer(), // Or use: SizedBox(height: 20),
              Column(
                children: [
                  CustomButton(
                    onPressed: handleSubmit,
                    background: Palette.facebookColor,
                    text: 'Add Now',
                  ),
                  //  ElevatedButton(

                  //   onPressed: _addNow,
                  //   style: ElevatedButton.styleFrom(

                  //     backgroundColor: Colors.lightBlue,
                  //     foregroundColor: Colors.white,
                  //     padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 80),
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(10),
                  //     ),
                  //   ),
                  //   child: const Text('Add Now'),
                  // ),
                  TextButton(
                    onPressed: () {
                      // Navigator.pop(context);
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => BottomNavigationBarScreen(
                                pageIndex: 2,
                                eventIndex: 1,
                              ),
                        ),
                        (route) => false,
                      );
                    },
                    child: Text('Skip', style: TextStyle(color: Colors.white)),
                  ),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     Navigator.pop(context);
                  //   },
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: Colors.grey[300],
                  //     foregroundColor: Colors.black,
                  //     padding: const EdgeInsets.symmetric(vertical: 14),
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(10),
                  //     ),
                  //   ),
                  //   child: const Text('Skip'),
                  // ),
                  const SizedBox(width: 12),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
