// import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import '../helper/api.dart';

class MainProvider with ChangeNotifier {
  final bool _isloading = false;

  bool get isLoading {
    return _isloading;
  }

  // Future<dynamic> getIntrest() async {
  //   print('start');

  //   try {
  //     final response = await http.get(
  //       Uri.parse(getIntrests),
  //       headers: {
  //         'Accept': 'application/json',
  //       },
  //     );
  //     print('response----->>>> ${response.body}');
  //     final responseData = json.decode(response.body);

  //     print('get intrests api response -----> $responseData');
  //   } catch (e) {
  //     print('error in getting intrests----> $e');
  //   }
  //   print('object');
  // }
}
