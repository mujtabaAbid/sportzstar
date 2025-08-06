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

  Future<dynamic> createEvent({required Map<String, dynamic> formData}) async {
    final user = await userData();
    print('create event function call and user id ======>>>${user['id']}');

    formData.addAll({
      'user_id': user['id'].toString(),
      'event_type': 'my event',
    });

    final logData = Map<String, dynamic>.from(formData);
    logData.remove('profile_picture');
    print('create event function call and user id ======>>> $logData');

    try {
      final response = await http.post(
        Uri.parse(createEventApi),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(formData),
      );

      if (response.statusCode == 201) {
        print('success response of create event------->${response.body}');
        return response;
      } else {
        print('error in create event function -------->>>>${response.body}');
        return response;
      }
    } catch (e) {
      print('error in create event function------->>>$e');
      return null;
    }
  }

  Future<dynamic> getAllEventsFunction() async {
    try {
      final response = await http.get(
        Uri.parse(listEventApi),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('all getEventsFunction lists ---->>>> $responseData');
        return responseData;
      } else {
        print('all getEventsFunction lists ---error->>>> ${response.body}');
      }
    } catch (e) {
      print('all getEventsFunction lists  error --e-->>>> $e');
    }
  }

  Future<dynamic> deleteEventsFunction({required int eventId}) async {
    try {
      final response = await http.get(
        Uri.parse(deleteEventByIdApi(id: eventId)),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('deleteEventsFunction lists ---->>>> $responseData');
        return responseData;
      } else {
        print('deleteEventsFunction lists ---error->>>> ${response.body}');
      }
    } catch (e) {
      print('deleteEventsFunction lists  error --e-->>>> $e');
    }
  }
}
