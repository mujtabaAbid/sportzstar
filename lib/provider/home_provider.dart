import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sportzstar/helper/api.dart';

import '../helper/local_storage.dart';

class HomeProvider with ChangeNotifier {
  Future<dynamic> usersList() async {
    try {
      final authToken = await getDataFromLocalStorage(name: 'access');
      final response = await http.get(
        Uri.parse(usersListApi),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('all users lists --1-->>>> $responseData');
        return responseData;
      } else {
        print('all users lists --2-error->>>> ${response.body}');
      }
    } catch (e) {
      print('all users lists  error --e-->>>> $e');
    }
  }

  Future<dynamic> getAllPosts() async {
    try {
      final authToken = await getDataFromLocalStorage(name: 'access');
      final response = await http.get(
        Uri.parse(allPostsApi),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('getAllPosts --1-->>>> $responseData');

        // Assuming responseData is a List of posts
        List<dynamic> posts = responseData;

        // If the posts are inside a key like 'data' or 'posts', adjust accordingly:
        // List<dynamic> posts = responseData['posts'];

        // Sort by created_at descending (latest first)
        posts.sort(
          (a, b) => DateTime.parse(
            b['created_at'],
          ).compareTo(DateTime.parse(a['created_at'])),
        );

        print('Sorted posts -->> $posts');
        return posts;
      } else {
        print('getAllPosts --2-error->>>> ${response.body}');
      }
    } catch (e) {
      print('getAllPosts error --e-->>>> $e');
    }
  }

  Future<dynamic> getAllSports() async {
    try {
      final response = await http.get(
        Uri.parse(getSportsApi),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('getAllPosts --1-->>>> $responseData');
        return responseData;
      } else {
        print('getAllPosts --2-error->>>> ${response.body}');
      }
    } catch (e) {
      print('getAllPosts  error --e-->>>> $e');
    }
  }

  Future<dynamic> userData() async {
    final data = await getDataFromLocalStorage(name: 'userData');
    final userData = json.decode(data);
    print('object--->>>$userData');
    print('object--->>>${userData['id']}');
    return userData;
  }

  Future<dynamic> likePost(String postId) async {
    final user = await userData();
    print('likePost----->>>>>and post id ====>>>$postId');
    try {
      final response = await http.post(
        Uri.parse(likePostApi),
        headers: {'Accept': 'application/json'},
        body: json.encode({
          'post_id': postId,
          'user_id': user['id'].toString(),
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('likePost ----->>>> ${response.body}');
        return responseData;
      } else {
        print('likePost -----error->>>> ${response.body}');
      }
    } catch (e) {
      print('likePost  error --e-->>>> $e');
    }
  }

  Future<dynamic> unlikePost(String postId) async {
    final user = await userData();
    print('unlikePost----->>>>>${user['id']}');
    try {
      final response = await http.post(
        Uri.parse(unlikePostApi),
        headers: {'Accept': 'application/json'},
        body: json.encode({
          'post_id': postId,
          'user_id': user['id'].toString(),
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('unlikePost ----->>>> $responseData');
        return responseData;
      } else {
        print('unlikePost -----error->>>> ${response.body}');
      }
    } catch (e) {
      print('unlikePost  error --e-->>>> $e');
    }
  }
}
