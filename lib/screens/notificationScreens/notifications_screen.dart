import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sportzstar/config/palette.dart';
import 'package:sportzstar/helper/basic_enum.dart';
import 'package:sportzstar/helper/page_navigate.dart';
import 'package:sportzstar/provider/post_provider.dart';
import 'package:sportzstar/routing/routing_constrants.dart';
import 'package:sportzstar/screens/postScreens/post_detail_screen.dart';
import 'package:sportzstar/screens/userScreens/add_friends.dart';
import 'package:sportzstar/widgets/Layout/main_layout_widget.dart';
import 'package:sportzstar/widgets/alerts/alert_notification_widget.dart';

import '../../provider/home_provider.dart';
import '../eventScreens/tabbar_screen.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _isLoading = false;
  List<Map<String, dynamic>> chatData = [];
  @override
  void initState() {
    super.initState();
    getNotifications();
  }

  Future<void> getNotifications() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response =
          await Provider.of<HomeProvider>(
            context,
            listen: false,
          ).getAllNotifications();

      chatData.addAll(response['notifications'].cast<Map<String, dynamic>>());
      chatData.sort((a, b) {
        return (a['is_read'] == false ? 0 : 1).compareTo(
          b['is_read'] == false ? 0 : 1,
        );
      });

      print('✅ All getNotifications:-------------------> $response');
    } catch (e) {
      print('❌ Error getNotifications:--------e---------> $e');
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> readNotification({required int notificationId}) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await Provider.of<HomeProvider>(
        context,
        listen: false,
      ).readNotifications(notificationId: notificationId);

      if (response.statusCode == 200) {
        alertNotification(
          context: context,
          message: 'Mark as read',
          messageType: AlertMessageType.success,
        );
        print('response----->>>>>>${response.body}');
      } else {
        print('response--error--->>>>>>${response.body}');
      }
    } catch (e) {
      print('Error readNotification:--------e---------> $e');
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> mediaIdFunction(dynamic mediaId, String postType) async {
    print('Media ID=========>>>>>>: $mediaId and $postType');

    try {
      final response =
          await Provider.of<PostProvider>(
            context,
            listen: false,
          ).getAllUserPosts();
      print('This is $response');
      // Find the post where post_id == mediaId
      final postDetails = response.firstWhere(
        (post) => post['post_id'] == mediaId,
        orElse: () => null,
      );

      if (postDetails != null) {
        print('Filtered Post Details: $postDetails');
        // You can now use postDetails here

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostDetailScreen(post: postDetails),
          ),
        );
      } else {
        print('No post found with post_id == $mediaId');
      }
    } catch (e) {
      print('This is $e');
    }
  }

  String _formatDateOrTime(String dateTimeStr) {
    final dateTime = DateTime.parse(dateTimeStr);
    final now = DateTime.now();

    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      // Show time if it's today
      return DateFormat.jm().format(dateTime); // e.g., 5:08 PM
    } else {
      // Show date otherwise
      return DateFormat.yMMMMd().format(dateTime); // e.g., July 21, 2025
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        pushNamedAndRemoveUntilNavigate(
          pageName: bottomNavigationBarRoute,
          context: context,
        );
        return false;
      },
      child: MainLayoutWidget(
        isLoading: _isLoading,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          title: Text(
            'Notifications',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              pushNamedAndRemoveUntilNavigate(
                pageName: bottomNavigationBarRoute,
                context: context,
              );
            },
          ),
        ),
        body: Container(
          child: ListView.builder(
            itemCount: chatData.length,
            itemBuilder: (context, index) {
              final chat = chatData[index];
              return Column(
                children: [
                  Container(
                    color:
                        chat['is_read']
                            ? const Color.fromARGB(255, 201, 200, 200)
                            : Colors.transparent,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(
                          'http://77.37.125.189/${chat['profile']}',
                        ),
                        child:
                            ((chat['profile'] == null) ||
                                    (chat['profile'] == ''))
                                ? Icon(
                                  chat['notification_type'] == 'like'
                                      ? Icons.thumb_up
                                      : chat['notification_type'] == 'comment'
                                      ? Icons.comment
                                      : chat['notification_type'] ==
                                          'send_equest'
                                      ? Icons.drive_file_move_rounded
                                      : chat['notification_type'] == 'event'
                                      ? Icons.event
                                      : Icons.person_add,
                                )
                                : null,
                      ),
                      title: Text(
                        chat['full_name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        chat['message'],
                        style: const TextStyle(color: Colors.grey),
                      ),
                      trailing: Text(
                        _formatDateOrTime(chat['created_at']),
                        style: const TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        if (chat['notification_type'] == 'accept_request') {
                          readNotification(notificationId: chat['id']);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      AddFriendsList(initialTabIndex: 3),
                            ),
                          );
                        } else if (chat['notification_type'] == 'send_equest') {
                          readNotification(notificationId: chat['id']);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      AddFriendsList(initialTabIndex: 1),
                            ),
                          );
                        } else if (chat['notification_type'] == 'like' ||
                            chat['notification_type'] == 'comment') {
                          readNotification(notificationId: chat['id']);
                          mediaIdFunction(
                            chat['media_id'],
                            chat['notification_type'],
                          );
                        } else if (chat['notification_type'] == 'event') {
                          readNotification(notificationId: chat['id']);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EventScreen(),
                            ),
                          );
                        } else {
                          // Optional: handle other types or do nothing
                          print('Notification type not handled');
                        }
                      },
                    ),
                  ),
                  Divider(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
