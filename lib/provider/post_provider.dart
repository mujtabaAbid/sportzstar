import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../helper/api.dart';
import '../helper/local_storage.dart';

class PostProvider with ChangeNotifier {
  Future<dynamic> userData() async {
    final data = await getDataFromLocalStorage(name: 'userData');
    final userData = json.decode(data);
    print('object--->>>$userData');
    print('object--->>>${userData['id']}');
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
}
