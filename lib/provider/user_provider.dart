import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sportzstar/helper/http_exception.dart';

import '../helper/api.dart';

class UserProvider with ChangeNotifier {
  Future<dynamic> loginFunction({required Map<String, String> formData}) async {
    String authToken = '';
    Map<String, dynamic> userData = {};
    String deviceToken = '';

    formData.addAll({'deviceToken': deviceToken});
    try {
      final response = await http.post(
        Uri.parse(loginUser),
        headers: {'Accept': 'application/json'},
        body: formData,
      );
      final responseData = json.decode(response.body);

      if (responseData['status'] == true) {
        final SharedPreferences provider =
            await SharedPreferences.getInstance();
        provider.setString(
          'userData',
          json.encode(responseData['data']['user']),
        );
        await provider.setString(
          'authToken',
          responseData['data']['auth_token'],
        );

        authToken = responseData['data']['auth_token'];
        userData = responseData['data']['user'];
        print(
          '------------------login Successfully------------------> $responseData',
        );
        return responseData;
      } else {
        return responseData;
      }
    } on HttpExpectionString catch (error) {
      print(
        'error in login function HttpExpectionString-------------->  $error',
      );
      return error.toString();
    } catch (e) {
      print('error in login function-------------->  $e');
    }
  }
}
