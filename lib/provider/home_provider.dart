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

      final responseData = json.decode(response.body);
      if (responseData['status'] == true) {

      }
    } catch (e) {
      
    }
  }
}
