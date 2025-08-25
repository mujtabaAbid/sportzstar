import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sportzstar/helper/api.dart';

import '../helper/local_storage.dart';

class HomeProvider with ChangeNotifier {
  Future<dynamic> getAllNotifications() async {
    final user = await userData();
    try {
      final response = await http.get(
        Uri.parse(notificationApi(id: user['id'])),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('getAllNotifications -------->>>> $responseData');

        final notifications = responseData['notifications'] as List<dynamic>;

        final unreadNotificationCount =
            notifications
                .where((notification) => notification['is_read'] == false)
                .length;
        print(
          'getAllNotifications ----only length---->>>> ${responseData['notifications'].length}',
        );
        print(
          'Unread notifications:--------------------->> $unreadNotificationCount',
        );
        final notificationsData = {
          'unread': unreadNotificationCount,
          'notifications': responseData['notifications'],
        };
        return notificationsData;
      } else {
        print('getAllNotifications --2-error->>>> ${response.body}');
      }
    } catch (e) {
      print('getAllNotifications  error --e-->>>> $e');
    }
  }

  Future<dynamic> readNotifications({required int notificationId}) async {
    try {
      final response = await http.get(
        Uri.parse(readNotificationsApi(id: notificationId)),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('deleteEventsFunction lists ---->>>> $responseData');
        return response;
      } else {
        print('deleteEventsFunction lists ---error->>>> ${response.body}');
      }
    } catch (e) {
      print('deleteEventsFunction lists  error --e-->>>> $e');
    }
  }

  Future<dynamic> usersList() async {
    try {
      final authToken = await getDataFromLocalStorage(name: 'access');

      print('sfsdfsfsfsf------access00-->>>>>>$authToken');
      final response = await http.get(
        Uri.parse(usersListApi),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        print('all users lists --1-->>>> $responseData');
        return responseData;
      } else {
        print('all users lists --2-error->>>> ${response.body}');
        return responseData;
      }
    } catch (e) {
      print('all users lists  error --e-->>>> $e');
    }
  }

  //   void logoutFunction() async {
  //   try {
  //     final preference = await SharedPreferences.getInstance();
  //     await preference.clear();
  //     pushNamedAndRemoveUntilNavigate(
  //       pageName: loginScreenRoute,
  //       context: context,
  //     );
  //     alertNotification(
  //       context: context,
  //       message: 'User Logout Successfully',
  //       messageType: AlertMessageType.success,
  //     );
  //   } catch (e) {
  //     print('error in logut function ---->>>$e');
  //     alertNotification(
  //       context: context,
  //       message: 'User Not logout, Try again Later',
  //       messageType: AlertMessageType.error,
  //     );
  //   }
  // }

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
      print('initial print =11111=====token=====dd=>>>>$authToken');

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        print('getAllPosts --1-->>>> $responseData');

        List<dynamic> posts = responseData;

        // Sort posts by created_at (latest first)
        posts.sort(
          (a, b) => DateTime.parse(
            b['created_at'],
          ).compareTo(DateTime.parse(a['created_at'])),
        );

        // Sort each post's comments_list and likes_list
        for (var post in posts) {
          // Sort comments by created_at descending
          if (post['comments_list'] != null && post['comments_list'] is List) {
            post['comments_list'].sort(
              (a, b) => DateTime.parse(
                b['created_at'],
              ).compareTo(DateTime.parse(a['created_at'])),
            );
          }

          // Sort likes by created_at descending
          if (post['likes_list'] != null && post['likes_list'] is List) {
            post['likes_list'].sort(
              (a, b) => DateTime.parse(
                b['created_at'],
              ).compareTo(DateTime.parse(a['created_at'])),
            );
          }
        }

        print('Sorted posts with sorted comments and likes -->> $posts');
        return posts;
      } else {
        print('getAllPosts --2-error->>>> ${response.body}');

        return responseData;
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
        print('getAllSports ---->>>> $responseData');
        return responseData;
      } else {
        print('getAllSports ---error->>>> ${response.body}');
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

  Future<dynamic> uploadComments({
    required Map<String, String> formData,
  }) async {
    final user = await userData();
    formData.addAll({'user_id': user['id'].toString()});
    print('uploadComments----->>>>>$formData');
    try {
      final response = await http.post(
        Uri.parse(saveCommentApi),
        headers: {'Accept': 'application/json'},
        body: json.encode(formData),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('uploadComments ----->>>> $responseData');

        List<dynamic> comments = responseData;

        comments.sort(
          (a, b) => DateTime.parse(
            b['created_at'],
          ).compareTo(DateTime.parse(a['created_at'])),
        );

        return comments;
      } else {
        print('uploadComments -----error->>>> ${response.body}');
      }
    } catch (e) {
      print('uploadComments  error --e-->>>> $e');
    }
  }

  Future<dynamic> deleteComment(int commentId) async {
    final user = await userData();

    print(
      'user data and comment id --->>> |$commentId and ${user['id'].toString()}',
    );
    try {
      final response = await http.post(
        Uri.parse(deleteCommentOnPostApi),
        headers: {'Accept': 'application/json'},
        body: jsonEncode({'comment_id': commentId, 'user_id': user['id']}),
      );

      if (response.statusCode == 200) {
        // final resp = await getAllPosts();
        return response;
      } else {
        print(
          '-------comment not deleted, Something went wrong---------->>>>>>${response.body}',
        );
      }
    } catch (e) {
      print('--------comment not deleted, Something went wrong------------>$e');
    }
  }
}
