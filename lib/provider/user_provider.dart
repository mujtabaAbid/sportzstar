import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sportzstar/helper/http_exception.dart';
import 'package:mime/mime.dart';
import '../helper/api.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProvider with ChangeNotifier {
  String refresh = '';
  String access = '';
  Map<String, dynamic> userData = {};

  Future<dynamic> signupFunction({
    required Map<String, String> formData,
  }) async {
    print('signupfunction ---->> $formData');
    try {
      final response = await http.post(
        Uri.parse(registerUserApi),
        headers: {'Accept': 'application/json'},
        body: formData,
      );
      final responseData = json.decode(response.body);

      if (responseData['status'] == true) {
        print(
          '------------------signupFunction Successfully------------------> $responseData',
        );
        return responseData;
      } else {
        print(
          '------------------signupFunction error------------------> $responseData',
        );
        return responseData;
      }
    } on HttpExpectionString catch (error) {
      print(
        'error in signupFunction function HttpExpectionString-------------->  $error',
      );
      return error.toString();
    } catch (e) {
      print('error in signupFunction function-------------->  $e');
    }
  }

  // Future<dynamic> loginFunction({required Map<String, String> formData}) async {
  //   print('loginfunction ---->> $formData');
  //   try {
  //     final response = await http.post(
  //       Uri.parse(loginUserApi),
  //       headers: {'Accept': 'application/json'},
  //       body: formData,
  //     );

  //     if (response.statusCode == 200) {
  //       final responseData = json.decode(response.body);
  //       final SharedPreferences provider =
  //           await SharedPreferences.getInstance();
  //       await provider.clear();
  //       provider.setString('userData', json.encode(responseData['user']));
  //       await provider.setString('refresh', responseData['refresh']);
  //       await provider.setString('access', responseData['access']);

  //       refresh = responseData['refresh'];
  //       access = responseData['access'];

  //       print(
  //         '------------------login Successfully------------------> $responseData',
  //       );
  //       return response;
  //     } else {
  //       print(
  //         '------------------login error------------------> ${response.body}',
  //       );
  //       return response;
  //     }
  //   } on HttpExpectionString catch (error) {
  //     print(
  //       'error in login function HttpExpectionString-------------->  $error',
  //     );
  //     return error.toString();
  //   } catch (e) {
  //     print('error in login function-------------->  $e');
  //   }
  // }

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
        await provider.clear();
        provider.setString('userData', json.encode(responseData['user']));
        await provider.setString('refresh', responseData['refresh']);
        await provider.setString('access', responseData['access']);
        refresh = responseData['refresh'];
        access = responseData['access'];
        print(
          '------------------login Successfully------------------> $responseData',
        );
        // ==== FIREBASE AUTH ====
        final firebaseAuth = FirebaseAuth.instance;
        final firestore = FirebaseFirestore.instance;
        try {
          // Pehle login try karo
          UserCredential userCred = await firebaseAuth
              .signInWithEmailAndPassword(
                email: responseData['user']['email'],
                password: formData['password']!,
              );

          print("✅ Firebase login success:uid------> ${userCred.user!.uid}");
          print("✅ Firebase login success:user -------> ${userCred.user!}");
          print(
            "✅ Firebase login success:comp-----------> ${userCred.additionalUserInfo}",
          );
          print(
            "✅ Firebase login success:comp-----------> ${userCred.user!.providerData}",
          );
          await provider.setString('firebaseUid', userCred.user!.uid);
        } on FirebaseAuthException catch (e) {
          UserCredential newUser = await firebaseAuth
              .createUserWithEmailAndPassword(
                email: responseData['user']['email'],
                password: formData['password']!,
              );
          print("🆕 Firebase signup success:uid------>>${newUser.user!.uid}");
          print("🆕 Firebase signup success:user----------->>${newUser.user!}");
          print(
            "🆕 Firebase signup success:new--------->> ${newUser.additionalUserInfo}",
          );
          print("🆕 Firebase signup success:new--------->> $newUser");
          // Firestore me user profile save karo
          await firestore.collection("users").doc(newUser.user!.uid).set({
            "id": newUser.user!.uid,
            "userId": responseData['user']['id'],
            "email": responseData['user']['email'],
            "fullName": responseData['user']['full_name'],
            "userName": responseData['user']['username'],
            "profileImage": responseData['user']['profile_picture'],
            "dataOther": 'owjefjsoejhfods',
            "createdAt": DateTime.now().toIso8601String(),
            "isOnline": false, // Default offline
            "lastSeen": DateTime.now(),
          });

          // DocumentSnapshot doc =
          //     await FirebaseFirestore.instance
          //         .collection("users")
          //         .doc(newUser.user!.uid)
          //         .get();

          // if (doc.exists) {
          //   // Map me convert karke custom data access karo
          //   var data = doc.data() as Map<String, dynamic>;

          //   print("User Email: ${data['email']}");
          //   print("Username: ${data['username']}");
          //   print(
          //     "Other Data: ${data['dataOther']}",
          //   ); // 👈 yeh wahi hoga jo aapne save kiya
          // }

          await provider.setString('firebaseUid', newUser.user!.uid);
          print("Firebase auth error:---------->> ${e.code} - ${e.message}");
        } catch (e) {
          print("General error: $e");
        }
        return response;
      } else {
        print(
          '------------------login error------------------> ${response.body}',
        );

        return response;
      }
    } catch (e) {
      print('error in login function-------------->  $e');
      print("❌ FirebaseAuth error: $e - $e");
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

  Future<dynamic> updatePassword({
    required Map<String, String> formData,
  }) async {
    print('verifyOTP ---->> $formData');
    try {
      final response = await http.post(
        Uri.parse(updatePasswordApi),
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

  Future<dynamic> updateUserProfile({
    required Map<String, String> formData,
    File? file,
  }) async {
    try {
      if (file != null) {
        final bytes = await file.readAsBytes();
        String base64Image = base64Encode(bytes);

        final mimeType = lookupMimeType(file.path) ?? 'image/jpeg';
        // Create valid data URI
        final String dataUri = 'data:$mimeType;base64,$base64Image';

        // formData['profile_picture'] = dataUri; // send as string

        formData.addAll({'profile_picture': dataUri});
      } else {
        print("No profile picture to upload.");
      }
      final response = await http.patch(
        Uri.parse(updateUserApi),
        headers: {'Accept': 'application/json'},
        body: formData,
      );
      if (response.statusCode == 200) {
        print("Profile updated successfully:------- ${response.body}");
        return response;
      } else {
        print(
          "Profile update failed------- [${response.statusCode}]: ${response.body}",
        );
        return response;
      }
    } catch (e) {
      print("Error during updateUserProfile:----e--- $e");
      return e.toString();
    }
  }
}
