import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import '../helper/api.dart';
import '../helper/local_storage.dart';

class EventProvider with ChangeNotifier {
  Future<dynamic> userData() async {
    final data = await getDataFromLocalStorage(name: 'userData');
    final userData = json.decode(data);
    return userData;
  }

  Future<dynamic> createEvent({
    required Map<String, String> formData,
    required List<File> files,
  }) async {
    final user = await userData();

    formData.addAll({'user_id': user['id'], 'event_title': 'my event'});
    try {



    if (files != null && files.isNotEmpty) {
      List<String> imageList = [];

      for (File file in files) {
        final bytes = await file.readAsBytes();
        String base64Image = base64Encode(bytes);

        final mimeType = lookupMimeType(file.path) ?? 'image/jpeg';
        final String dataUri = 'data:$mimeType;base64,$base64Image';

        imageList.add(dataUri);
      }

      // Option 1: send as JSON array string (recommended)
      // formData.addAll({'event_images': jsonEncode(imageList)});

      // Option 2: send as comma-separated string
      formData.addAll({'event_images': imageList.join(',')});
    } else {
      print("No images to upload.");
    }

      // final response = await http.post(
      //   Uri.parse(createEventApi),
      //   headers: {'Accept': 'application/json'},
      //   // body: {'comment_id': commentId, 'user_id': user['id'].toString()},
      // );
    } catch (e) {
      print('error in create event function------->>>$e');
    }
  }
}
