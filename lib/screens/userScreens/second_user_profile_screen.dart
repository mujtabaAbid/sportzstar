import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportzstar/config/palette.dart';
import 'package:sportzstar/helper/basic_enum.dart';
import 'package:sportzstar/helper/captaliza.dart';
import 'package:sportzstar/provider/friends_provider.dart';
import 'package:sportzstar/widgets/Layout/main_layout_widget.dart';
import 'package:sportzstar/widgets/alerts/alert_notification_widget.dart';

import '../chats/chat_details_screen.dart';

class SecondUserProfileScreen extends StatefulWidget {
  final Map<String, dynamic> userData;
  final String userType;
  const SecondUserProfileScreen({
    super.key,
    required this.userData,
    required this.userType,
  });

  @override
  State<SecondUserProfileScreen> createState() =>
      _SecondUserProfileScreenState();
}

class _SecondUserProfileScreenState extends State<SecondUserProfileScreen> {
  bool _isLoading = false;
  Future<void> addFriend({required int friendId}) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await Provider.of<FriendsProvider>(
        context,
        listen: false,
      ).addFriendFunction(friendId: friendId);
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        alertNotification(
          context: context,
          message: responseData['message'].toString(),
          messageType: AlertMessageType.success,
        );
      } else {
        alertNotification(
          context: context,
          message:
              responseData['detail'] != null
                  ? responseData['detail'].toString()
                  : responseData['message'].toString(),
          messageType: AlertMessageType.error,
        );
        print('error in add friend function--sec-->>>${response.body}');
      }
    } catch (e) {
      print('error in add friend function--sec e-->>>$e');
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> unfriend({required int friendId}) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await Provider.of<FriendsProvider>(
        context,
        listen: false,
      ).unFriendFunction(friendId: friendId);
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        alertNotification(
          context: context,
          message: responseData['message'].toString(),
          messageType: AlertMessageType.success,
        );
      } else {
        alertNotification(
          context: context,
          message:
              responseData['detail'] != null
                  ? responseData['detail'].toString()
                  : responseData['message'].toString(),
          messageType: AlertMessageType.error,
        );
        print('error in unfriend function--sec-->>>${response.body}');
      }
    } catch (e) {
      print('error in unfriend function--sec e-->>>$e');
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> acceptFriend({required int friendId}) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await Provider.of<FriendsProvider>(
        context,
        listen: false,
      ).acceptFriendRequest(friendId: friendId);
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        alertNotification(
          context: context,
          message: responseData['message'].toString(),
          messageType: AlertMessageType.success,
        );
      } else {
        alertNotification(
          context: context,
          message:
              responseData['detail'] != null
                  ? responseData['detail'].toString()
                  : responseData['message'].toString(),
          messageType: AlertMessageType.error,
        );
        print('error in acceptFriend function-- sec -->>>${response.body}');
      }
    } catch (e) {
      print('error in acceptFriend function--sec e-->>>$e');
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> rejectFriend({required int friendId}) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await Provider.of<FriendsProvider>(
        context,
        listen: false,
      ).rejectFriendRequest(friendId: friendId);
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        alertNotification(
          context: context,
          message: responseData['message'].toString(),
          messageType: AlertMessageType.success,
        );
      } else {
        alertNotification(
          context: context,
          message:
              responseData['detail'] != null
                  ? responseData['detail'].toString()
                  : responseData['message'].toString(),
          messageType: AlertMessageType.error,
        );
        print('error in rejectFriend function--sec-->>>${response.body}');
      }
    } catch (e) {
      print('error in rejectFriend function--sec e-->>>$e');
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<String?> getFirebaseUidByEmail(String email) async {
    final query =
        await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: email)
            .limit(1)
            .get();

    if (query.docs.isNotEmpty) {
      return query.docs.first.id; // 👈 ye Firebase UID hai
    }
    return null;
  }
  //  String getChatId(String uid1, String uid2) {
  //   if (uid1.hashCode <= uid2.hashCode) {
  //     return "${uid1}_$uid2";
  //   } else {
  //     return "${uid2}_$uid1";
  //   }
  // }

  // Map<String, dynamic> userData = {};
  @override
  Widget build(BuildContext context) {
    return MainLayoutWidget(
      isLoading: _isLoading,
      noDefaultBackground: true,
      // backgroundColor: Colors.white,
      body: CustomScrollView(
        // physics: NeverScrollableScrollPhysics(),
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            pinned: false,
            expandedHeight: 200,
            backgroundColor: const Color.fromARGB(255, 250, 248, 248),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 80),
                    // height: 180,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/profile/cover.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(80),
              child: Transform.translate(
                offset: const Offset(0, 50), // pushes down half image
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 47,
                              backgroundImage:
                                  widget.userData['profile_picture'] != null &&
                                          widget.userData['profile_picture'] !=
                                              ''
                                      ? NetworkImage(
                                        widget.userData['profile_picture'],
                                      )
                                      : AssetImage('assets/profile/dummy.png'),
                            ),
                          ),

                          const SizedBox(width: 20),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // IconButton(
                                //   icon: const Icon(
                                //     Icons.email_outlined,
                                //     color: Colors.white,
                                //   ),
                                //   onPressed: () {},
                                // ),
                                FutureBuilder<String?>(
                                  future: getFirebaseUidByEmail(
                                    widget.userData['email'],
                                  ),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const SizedBox.shrink(); // loading me kuch mat dikhao
                                    }

                                    if (!snapshot.hasData ||
                                        snapshot.data == null) {
                                      return const SizedBox.shrink(); // user Firebase me nahi hai
                                    }

                                    // agar user Firebase me hai, to button dikhao
                                    return Container(
                                      width: 40,
                                      height: 40,
                                      // margin: EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: Palette.facebookColor,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.email_outlined,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _isLoading = true;
                                          });
                                          print(
                                            "Firebase UID of ${widget.userData['email']} => ${snapshot.data}",
                                          );

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (_) => ChatDetailScreen(
                                                    // name: user['fullName'],
                                                    receiverId:
                                                        snapshot.data
                                                            .toString(),
                                                    // image: user['profileImage'],
                                                  ),
                                            ),
                                          );

                                          setState(() {
                                            _isLoading = false;
                                          });
                                        },
                                      ),
                                    );
                                  },
                                ),

                                const SizedBox(width: 10),
                                if (widget.userType == 'User')
                                  ElevatedButton(
                                    onPressed: () {
                                      print(
                                        "Send friend request to ${widget.userData['id']}",
                                      );
                                      addFriend(
                                        friendId: widget.userData['id'],
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Palette.facebookColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    child: const Text(
                                      'Add Friend',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                if (widget.userType == 'Sent')
                                  ElevatedButton(
                                    onPressed: null,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Palette.facebookColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    child: const Text(
                                      'Request Sent',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                if (widget.userType == 'Received')
                                  Row(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          print(
                                            "Accept friend request from ${widget.userData['id']}",
                                          );
                                          acceptFriend(
                                            friendId: widget.userData['id'],
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          padding: const EdgeInsets.all(0),
                                        ),
                                        child: const Text(
                                          "Accept",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      SizedBox(width: 6),
                                      ElevatedButton(
                                        onPressed: () {
                                          print(
                                            "Reject friend request from ${widget.userData['id']}",
                                          );
                                          rejectFriend(
                                            friendId: widget.userData['id'],
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          padding: const EdgeInsets.all(0),
                                        ),
                                        child: const Text(
                                          "Reject",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  )
                                else if (widget.userType == 'Friends')
                                  ElevatedButton(
                                    onPressed: () {
                                      print(
                                        "Unfriend user ${widget.userData['id']}",
                                      );
                                      unfriend(friendId: widget.userData['id']);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    child: const Text(
                                      'Unfriend',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
              ), // adjust top spacing

              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 60), // Adjust height as needed
                      // Rest of your profile content
                      Container(
                        // padding: EdgeInsets.only(left: 18),
                        // color: Colors.amber,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.userData['full_name'] != null &&
                                      widget.userData['full_name'] != ''
                                  ? capitalize(widget.userData['full_name'])
                                  : '',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            // const SizedBox(height: 2),
                            Text(
                              widget.userData['username'] != null &&
                                      widget.userData['username'] != ''
                                  ? widget.userData['username']
                                  : '',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),

                            Text(
                              widget.userData['player_category'] != null
                                  ? '🏆 ${widget.userData['player_category']}'
                                  : '',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              '📩 ${widget.userData['email']}',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      // Buttons Row
                      const SizedBox(height: 20),

                      const SizedBox(height: 8),
                      Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 200),
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Player Info',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: const Color.fromARGB(
                                      54,
                                      96,
                                      125,
                                      139,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Name: ${widget.userData['full_name'] ?? 'N/A'}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        'Username: @${widget.userData['username'] ?? 'N/A'}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        'Email: ${widget.userData['email'] ?? 'N/A'}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                      if (widget.userData['age'] != null)
                                        Text(
                                          'Age: ${widget.userData['age']}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                      if ((widget.userData['gender'] ?? '')
                                          .toString()
                                          .isNotEmpty)
                                        Text(
                                          'Gender: ${widget.userData['gender']}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                      if ((widget.userData['bio'] ?? '')
                                          .toString()
                                          .isNotEmpty)
                                        if ((widget.userData['player_category'] ??
                                                '')
                                            .toString()
                                            .isNotEmpty)
                                          Text(
                                            'Player: ${widget.userData['player_category']}',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          ),
                                      if ((widget.userData['start_year'] ?? '')
                                          .toString()
                                          .isNotEmpty)
                                        Text(
                                          'Start Year: ${widget.userData['start_year']}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Bio',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: const Color.fromARGB(
                                      54,
                                      96,
                                      125,
                                      139,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        (widget.userData['bio'] != null &&
                                                widget.userData['bio']
                                                    .toString()
                                                    .trim()
                                                    .isNotEmpty)
                                            ? widget.userData['bio'].toString()
                                            : 'No Bio Found',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(height: 10),
                                Text(
                                  'Social Media',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: const Color.fromARGB(
                                      54,
                                      96,
                                      125,
                                      139,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (widget.userData['social_links'] !=
                                              null &&
                                          (widget.userData['social_links']
                                                  as List)
                                              .isNotEmpty)
                                        ...List<Widget>.from(
                                          (widget.userData['social_links']
                                                  as List)
                                              .map(
                                                (linkData) => Text(
                                                  '${linkData['platform']}: ${linkData['link']}',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                        )
                                      else
                                        const Text(
                                          'No Link Found',
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 14,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),

                                SizedBox(height: 10),

                                // if ((userData['medals'] ?? '')
                                //     .toString()
                                //     .isNotEmpty)
                                Text(
                                  'Medals',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: const Color.fromARGB(
                                      54,
                                      96,
                                      125,
                                      139,
                                    ),
                                  ),
                                  child: Text(
                                    (widget.userData['medals'] != null &&
                                            widget.userData['medals']
                                                .toString()
                                                .trim()
                                                .isNotEmpty)
                                        ? widget.userData['medals'].toString()
                                        : 'No Medals Found',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),

                                // Career History (List)
                                const Text(
                                  'Career History:',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: const Color.fromARGB(
                                      54,
                                      96,
                                      125,
                                      139,
                                    ),
                                  ),
                                  child:
                                      (widget.userData['career_history'] !=
                                                  null &&
                                              (widget.userData['career_history']
                                                      as List)
                                                  .isNotEmpty)
                                          ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ...List<Widget>.from(
                                                (widget.userData['career_history']
                                                        as List)
                                                    .map(
                                                      (career) => Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          if ((career['title'] ??
                                                                  '')
                                                              .toString()
                                                              .isNotEmpty)
                                                            Text(
                                                              '🔹 Title: ${career['title']}',
                                                              style: TextStyle(
                                                                color:
                                                                    Colors
                                                                        .white,
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                          if ((career['clubName'] ??
                                                                  '')
                                                              .toString()
                                                              .isNotEmpty)
                                                            Text(
                                                              '🏛 Club: ${career['clubName']}',
                                                              style: TextStyle(
                                                                color:
                                                                    Colors
                                                                        .white,
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                          if ((career['description'] ??
                                                                  '')
                                                              .toString()
                                                              .isNotEmpty)
                                                            Text(
                                                              '📄 Description: ${career['description']}',
                                                              style: TextStyle(
                                                                color:
                                                                    Colors
                                                                        .white,
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                          if ((career['start_date'] ??
                                                                  '')
                                                              .toString()
                                                              .isNotEmpty)
                                                            Text(
                                                              '📅 Start: ${career['start_date']}',
                                                              style: TextStyle(
                                                                color:
                                                                    Colors
                                                                        .white,
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                          if ((career['end_date'] ??
                                                                  '')
                                                              .toString()
                                                              .isNotEmpty)
                                                            Text(
                                                              '📅 End: ${career['end_date']}',
                                                              style: TextStyle(
                                                                color:
                                                                    Colors
                                                                        .white,
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                          const SizedBox(
                                                            height: 6,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                              ),
                                            ],
                                          )
                                          : const Text(
                                            'No Career History Found',
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 14,
                                            ),
                                          ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
