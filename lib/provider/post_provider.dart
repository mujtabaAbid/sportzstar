import 'dart:convert';
import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart'; // ✅ Import this at the top

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../helper/api.dart';
import '../helper/local_storage.dart';
import 'package:mime/mime.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../helper/api.dart';
import '../helper/local_storage.dart';

class PostProvider with ChangeNotifier {
  Future<dynamic> userData() async {
    final data = await getDataFromLocalStorage(name: 'userData');
    final userData = json.decode(data);
    // print('object--->>>$userData');
    // print('object--->>>${userData['id']}');
    return userData;
  }

  Future<dynamic> getAllUserPosts() async {
    final user = await userData();
    try {
      final response = await http.get(
        Uri.parse(allUserPostApi(id: user['id'])),
        headers: {'Accept': 'application/json'},
        // body: {'comment_id': commentId, 'user_id': user['id'].toString()},
      );

      if (response.statusCode == 200) {
        // final resp = await getAllPosts();
        final responseData = json.decode(response.body);
        print('-------getAllUserPosts--------->>>>>>$responseData');
        return responseData;
      } else {
        print('-------getAllUserPosts-error--------->>>>>>${response.body}');
      }
    } catch (e) {
      print('--------getAllUserPosts----eee-------->$e');
    }
  }

  Future<dynamic> deletePostFunction({required int postId}) async {
    // final user = await userData();
    try {
      final response = await http.delete(
        Uri.parse(deletePostApi(id: postId)),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        // final resp = await getAllPosts();
        final responseData = json.decode(response.body);
        print('-------delete post function--------->>>>>>$responseData');
        return responseData;
      } else {
        print(
          '-------delete post function-error--------->>>>>>${response.body}',
        );
      }
    } catch (e) {
      print('--------delete post function----eee-------->$e');
    }
  }

  Future<dynamic> createPost({
    required Map<String, String> formData,
    File? file,
  }) async {
    final user = await userData();
    formData['user_id'] = user['id'].toString();
    print('all from data from create post ----->>>>${formData.toString()}');
    final request = http.MultipartRequest('POST', Uri.parse(createPostApi));
    // Add form data
    request.fields.addAll(formData);
    if (file != null) {
      final mimeType = lookupMimeType(file.path);
      print("Adding file:---- $file-----and  type ------>>>>$mimeType");
      request.files.add(await http.MultipartFile.fromPath('video', file.path));
    } else {
      print("No file attached!");
    }
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      print("success response ====>>>>$responseData");
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to upload post');
    }
  }
}
