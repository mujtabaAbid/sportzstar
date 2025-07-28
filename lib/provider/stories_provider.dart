import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../helper/api.dart';
import '../helper/local_storage.dart';
import 'package:mime/mime.dart';

class StoriesProvider with ChangeNotifier {
  Future<dynamic> userData() async {
    final data = await getDataFromLocalStorage(name: 'userData');
    final userData = json.decode(data);
    print('object--->>>$userData');
    print('object--->>>${userData['id']}');
    return userData;
  }

  Future<dynamic> getStories() async {
    final user = await userData();
    try {
      final response = await http.get(
        Uri.parse(getStoryWithUserIdApi(id: user['id'])),
        headers: {'Accept': 'application/json'},
        // body: {'comment_id': commentId, 'user_id': user['id'].toString()},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        print('get stories success response -------->>>>>   $responseData');
        return responseData;
      } else {
        print('get stories success response -------->>>>>   ${response.body}');
      }
    } catch (e) {
      print('get stories error response -------->>>>>   $e');
    }
  }

  // Future<dynamic> addStory({required Map<String, String> formData}) async {
  //   final user = await userData();
  //   try {
  //     final response = await http.post(
  //       Uri.parse(createStoryApi),
  //       headers: {'Accept': 'application/json'},
  //       body: formData,
  //     );

  //     if (response.statusCode == 200) {
  //       final responseData = json.decode(response.body);

  //       print('object');
  //     }
  //   } catch (e) {}
  // }
  Future<dynamic> addStory({
    required Map<String, String> formData,
    File? file,
    required String postType,
  }) async {
    final user = await userData();
    formData.addAll({'user_id': user['id'].toString()});

    final request = http.MultipartRequest('POST', Uri.parse(createStoryApi));
    print("Form fields:");
    formData.forEach((key, value) {
      request.fields[key] = value;
      print("$key => $value");
    });

    if (file != null) {
      final mimeType = lookupMimeType(file.path);
      print("Adding file:---- $file-----and  type ------>>>>$mimeType");
      request.files.add(
        await http.MultipartFile.fromPath(
          'video', // ✅ always "video"
          file.path,
        ),
      );
    } else {
      print("No file attached!");
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 201) {
      print("Upload success: ${response.body}");
      return jsonDecode(response.body);
    } else {
      print("Upload failed [${response.statusCode}]: ${response.body}");
      throw Exception('Failed to upload story');
    }
  }
}
