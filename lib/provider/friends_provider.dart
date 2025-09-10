import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../helper/api.dart';
import '../helper/local_storage.dart';

class FriendsProvider with ChangeNotifier {
  Future<dynamic> userData() async {
    final data = await getDataFromLocalStorage(name: 'userData');
    final userData = json.decode(data);
    return userData;
  }

  Future<dynamic> addFriendFunction({required int friendId}) async {
    final user = await userData();
    try {
      final response = await http.post(
        Uri.parse(addFriendApi),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({"user_id": user['id'], "friend_user": friendId}),
        //  {
        //   'user_id': user['id'].toString(),
        //   'friend_user': friendId.toString(),
        // },
      );

      if (response.statusCode == 200) {
        print(
          'addFriendFunction success response -------->>>>>   ${response.body}',
        );
        return response;
      } else {
        print(
          'addFriendFunction success response -------->>>>>   ${response.body}',
        );
      }
    } catch (e) {
      print('addFriendFunction error response -------->>>>>   $e');
    }
  }

  Future<dynamic> unFriendFunction({required int friendId}) async {
    final user = await userData();
    final authToken = await getDataFromLocalStorage(name: 'access');
    print(
      'object--------------------user-id>> ${user["id"]} and friend == ${friendId.toString()}',
    );
    try {
      // final response = await http.post(
      //   Uri.parse(unfriendApi),
      //   headers: {
      //     'Accept': 'application/json',
      //     'Authorization': 'Bearer $authToken',
      //   },
      //   body: {
      //     'user_id': user['id'].toString(),
      //     'friend_user': friendId.toString(),
      //   },
      // );
      final response = await http.post(
        Uri.parse(unfriendApi),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode({'user_id': user['id'], 'friend_user': friendId}),
      );

      if (response.statusCode == 200) {
        // final responseData = json.decode(response.body);

        print(
          'unFriendFunction success response -------->>>>>   ${response.body}',
        );
        return response;
      } else {
        print(
          'unFriendFunction error response -------->>>>>   ${response.body}',
        );
        return response;
      }
    } catch (e) {
      print('unFriendFunction error response -------->>>>>   $e');
    }
  }

  Future<dynamic> acceptFriendRequest({required int friendId}) async {
    final user = await userData();
    print('user id --> ${user['id']} and friend id ==>${friendId.toString()}');
    try {
      final response = await http.post(
        Uri.parse(acceptFriendApi),
        headers: {'Accept': 'application/json'},
        body: {
          'user_id': user['id'].toString(),
          'friend_user': friendId.toString(),
        },
      );
      print('initial response ====>>>${response.statusCode}');

      if (response.statusCode == 200) {
        // final responseData = json.decode(response.body);

        print(
          'acceptFriendRequest success response -------->>>>>   ${response.body}',
        );
        return response;
      } else {
        print(
          'acceptFriendRequest success response -------->>>>>   ${response.body}',
        );
      }
    } catch (e) {
      print('acceptFriendRequest error response -------->>>>>   $e');
    }
  }

  Future<dynamic> rejectFriendRequest({required int friendId}) async {
    final user = await userData();
    try {
      final response = await http.post(
        Uri.parse(rejectFriendApi),
        headers: {'Accept': 'application/json'},
        body: {
          'user_id': user['id'].toString(),
          'friend_user': friendId.toString(),
        },
      );

      if (response.statusCode == 200) {
        // final responseData = json.decode(response.body);

        print(
          'rejectFriendRequest success response -------->>>>>   ${response.body}',
        );
        return response;
      } else {
        print(
          'rejectFriendRequest success response -------->>>>>   ${response.body}',
        );
      }
    } catch (e) {
      print('rejectFriendRequest error response -------->>>>>   $e');
    }
  }

  Future<dynamic> getFriendsIds() async {
    final authToken = await getDataFromLocalStorage(name: 'access');
    final user = await userData();

    try {
      final response = await http.get(
        Uri.parse(getFriendApi(userId: user['id'])),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        print('getFriendsIds success response -------->>>>>   $responseData');
        return responseData;
      } else {
        print(
          'getFriendsIds success response -------->>>>>   ${response.body}',
        );
      }
    } catch (e) {
      print('getFriendsIds error response -------->>>>>   $e');
    }
  }
}
