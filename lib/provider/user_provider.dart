import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sportzstar/helper/http_exception.dart';

import '../helper/api.dart';

class UserProvider with ChangeNotifier {
  String refresh = '';
  String access = '';
  Map<String, dynamic> userData = {};

  Future<dynamic> loginFunction({required Map<String, String> formData}) async {
    print('loginfunction ---->> $formData');
    try {
      final response = await http.post(
        Uri.parse(loginUserApi),
        headers: {'Accept': 'application/json'},
        body: formData,
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final SharedPreferences provider =
            await SharedPreferences.getInstance();
        provider.setString('userData', json.encode(responseData['user']));
        await provider.setString('refresh', responseData['refresh']);
        await provider.setString('access', responseData['access']);

        refresh = responseData['refresh'];
        access = responseData['access'];

        print(
          '------------------login Successfully------------------> $responseData',
        );
        return response;
      } else {
        print(
          '------------------login error------------------> ${response.body}',
        );
        return response;
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

  Future<dynamic> getCode({required Map<String, String> formData}) async {
    print('getCode ---->> $formData');
    try {
      final response = await http.post(
        Uri.parse(getCodeApi),
        headers: {'Accept': 'application/json'},
        body: formData,
      );
      final responseData = json.decode(response.body);
      if (responseData['status'] == true) {
        print(
          '------------------getCode Successfully------------------> $responseData',
        );
        return responseData;
      } else {
        print(
          '------------------getCode error------------------> $responseData',
        );
        return responseData;
      }
    } on HttpExpectionString catch (error) {
      print(
        'error in login function HttpExpectionString-----getCode--------->  $error',
      );
      return error.toString();
    } catch (e) {
      print('error in getCode function-------------->  $e');
    }
  }

  Future<dynamic> verifyOTP({required Map<String, String> formData}) async {
    print('verifyOTP ---->> $formData');
    try {
      final response = await http.post(
        Uri.parse(verifyEmailApi),
        headers: {'Accept': 'application/json'},
        body: formData,
      );
      final responseData = json.decode(response.body);
      if (responseData['status'] == true) {
        print(
          '------------------getCode Successfully------------------> $responseData',
        );
        return responseData;
      } else {
        print(
          '------------------getCode error------------------> $responseData',
        );
        return responseData;
      }
    } on HttpExpectionString catch (error) {
      print(
        'error in login function HttpExpectionString-----getCode--------->  $error',
      );
      return error.toString();
    } catch (e) {
      print('error in getCode function-------------->  $e');
    }
  }
}
