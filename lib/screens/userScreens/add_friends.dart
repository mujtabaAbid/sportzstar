import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sportzstar/helper/basic_enum.dart';
import 'package:sportzstar/helper/page_navigate.dart';
import 'package:sportzstar/provider/friends_provider.dart';
import 'package:sportzstar/routing/routing_constrants.dart';
import 'package:sportzstar/widgets/Layout/main_layout_widget.dart';
import 'package:sportzstar/widgets/alerts/alert_notification_widget.dart';

import '../../provider/home_provider.dart';
import '../bottom_navigation_bar.dart';
import 'second_user_profile_screen.dart';

class AddFriendsList extends StatefulWidget {
  final int initialTabIndex;
  final String? route;
  const AddFriendsList({super.key, required this.initialTabIndex, this.route});

  @override
  State<AddFriendsList> createState() => _AddFriendsListState();
}

class _AddFriendsListState extends State<AddFriendsList>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  List<Map<String, dynamic>> friends = [];
  List<Map<String, dynamic>> sendRequestsUsers = [];
  List<Map<String, dynamic>> recievedRequestUsers = [];
  List<Map<String, dynamic>> otherUsers = [];

  List<Map<String, dynamic>> filteredFriends = [];
  List<Map<String, dynamic>> filteredSendRequests = [];
  List<Map<String, dynamic>> filteredReceivedRequests = [];
  List<Map<String, dynamic>> filteredOtherUsers = [];
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  Future<void> allUsers() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final usersData =
          await Provider.of<HomeProvider>(context, listen: false).usersList();

      print('get all users data:----------------------->> $usersData');
      if (usersData['detail'] ==
          'Authentication credentials were not provided or are invalid.') {
        logoutFunction();
      }

      // Clear previous data
      friends.clear();
      sendRequestsUsers.clear();
      recievedRequestUsers.clear();
      otherUsers.clear();
      friends.addAll(List<Map<String, dynamic>>.from(usersData['friends']));
      sendRequestsUsers.addAll(
        List<Map<String, dynamic>>.from(usersData['send_requests_users']),
      );
      recievedRequestUsers.addAll(
        List<Map<String, dynamic>>.from(usersData['recieved_request_users']),
      );
      otherUsers.addAll(
        List<Map<String, dynamic>>.from(usersData['other_users']),
      );
      // Set filtered lists initially equal to full lists
      filteredFriends = List.from(friends);
      filteredSendRequests = List.from(sendRequestsUsers);
      filteredReceivedRequests = List.from(recievedRequestUsers);
      filteredOtherUsers = List.from(otherUsers);
      print('Final FRIENDS list: ${friends.length} users');
      print('Final OTHERS list: ${otherUsers.toList()} users');
    } catch (e) {
      print('from screen use list------->>>>>> Error: $e');
    }
    setState(() {
      _isLoading = false;
    });
  }

  void logoutFunction() async {
    try {
      final preference = await SharedPreferences.getInstance();
      await preference.clear();
      pushNamedAndRemoveUntilNavigate(
        pageName: loginScreenRoute,
        context: context,
      );
      alertNotification(
        context: context,
        message: 'User Logout, Please login Again.',
        messageType: AlertMessageType.success,
      );
    } catch (e) {
      print('error in logut function ---->>>$e');
      alertNotification(
        context: context,
        message: 'User Not logout, Try again Later',
        messageType: AlertMessageType.error,
      );
    }
  }

  void _filterSearchResults(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();

      filteredFriends =
          friends
              .where(
                (user) => user['full_name'].toString().toLowerCase().contains(
                  _searchQuery,
                ),
              )
              .toList();

      filteredSendRequests =
          sendRequestsUsers
              .where(
                (user) => user['full_name'].toString().toLowerCase().contains(
                  _searchQuery,
                ),
              )
              .toList();

      filteredReceivedRequests =
          recievedRequestUsers
              .where(
                (user) => user['full_name'].toString().toLowerCase().contains(
                  _searchQuery,
                ),
              )
              .toList();

      filteredOtherUsers =
          otherUsers
              .where(
                (user) => user['full_name'].toString().toLowerCase().contains(
                  _searchQuery,
                ),
              )
              .toList();
    });
  }

  @override
  void initState() {
    _tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
    print('page route---->>> ${widget.route}');
    super.initState();
    allUsers();
  }

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
        await allUsers();
      } else {
        alertNotification(
          context: context,
          message:
              responseData['detail'] != null
                  ? responseData['detail'].toString()
                  : responseData['message'].toString(),
          messageType: AlertMessageType.error,
        );
        print('error in add friend function---->>>${response.body}');
      }
    } catch (e) {
      print('error in add friend function---->>>$e');
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
         setState(() {
        filteredFriends.removeWhere((user) => user['id'] == friendId);
      });
        alertNotification(
          context: context,
          message:
              responseData['detail'] != null
                  ? responseData['detail'].toString()
                  : responseData['message'].toString(),
          messageType: AlertMessageType.success,
        );
        await allUsers();
      } else {
        alertNotification(
          context: context,
          message:
              responseData['detail'] != null
                  ? responseData['detail'].toString()
                  : responseData['message'].toString(),
          messageType: AlertMessageType.error,
        );
        print('error in unfriend function--add-->>>${response.body}');
      }
    } catch (e) {
      print('error in unfriend function--add e-->>>$e');
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
        await allUsers();
      } else {
        alertNotification(
          context: context,
          message:
              responseData['detail'] != null
                  ? responseData['detail'].toString()
                  : responseData['message'].toString(),
          messageType: AlertMessageType.error,
        );
        print('error in acceptFriend function---->>>${response.body}');
      }
    } catch (e) {
      print('error in acceptFriend function---->>>$e');
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
        await allUsers();
      } else {
        alertNotification(
          context: context,
          message:
              responseData['detail'] != null
                  ? responseData['detail'].toString()
                  : responseData['message'].toString(),
          messageType: AlertMessageType.error,
        );
        print('error in rejectFriend function---->>>${response.body}');
      }
    } catch (e) {
      print('error in rejectFriend function---->>>$e');
    }
    setState(() {
      _isLoading = false;
    });
  }

  Widget _buildUserTile(Map<String, dynamic> otherUsers) {
    return GestureDetector(
      onTap: () {
        final index = _tabController.index;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => SecondUserProfileScreen(
                  userData: otherUsers,
                  userType:
                      index == 0
                          ? 'User'
                          : index == 1
                          ? 'Sent'
                          : index == 2
                          ? 'Received'
                          : 'Friends',
                ),
          ),
        ).then((value) {
          if (value == true) {
            allUsers(); // yaha apna data reload karna
          }
        });
        print('');
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage:
                  (otherUsers['profile_picture'] != null &&
                          otherUsers['profile_picture'].toString().isNotEmpty)
                      ? NetworkImage(otherUsers['profile_picture'].toString())
                      : null,
              backgroundColor: Colors.black12,
              child:
                  (otherUsers['profile_picture'] == null ||
                          otherUsers['profile_picture'].toString().isEmpty)
                      ? const Icon(Icons.person, color: Colors.grey)
                      : null,
            ),

            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    otherUsers['full_name'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // if (otherUsers['player_category']!.isNotEmpty)
                  Text(
                    otherUsers['player_category'].toString(),
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Builder(
              builder: (_) {
                final index = _tabController.index;
                if (index == 0) {
                  // User tab
                  return ElevatedButton(
                    onPressed: () {
                      print("Send friend request to ${otherUsers['id']}");
                      addFriend(friendId: otherUsers['id']);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    child: const Text(
                      "Add Friend",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                } else if (index == 1) {
                  // Sent tab
                  return const SizedBox(); // No button
                } else if (index == 2) {
                  // Received tab
                  return Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          print(
                            "Accept friend request from ${otherUsers['id']}",
                          );
                          acceptFriend(friendId: otherUsers['id']);
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
                            "Reject friend request from ${otherUsers['id']}",
                          );
                          rejectFriend(friendId: otherUsers['id']);
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
                  );
                } else if (index == 3) {
                  // Friends tab
                  return ElevatedButton(
                    onPressed: () {
                      print("Unfriend user ${otherUsers['id']}");
                      unfriend(friendId: otherUsers['id']);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    child: const Text(
                      "Unfriend",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                } else {
                  return const SizedBox(); // Fallback
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabView(List<Map<String, dynamic>> userList) {
    if (userList.isEmpty) {
      return const Center(
        child: Text(
          "No data found",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: userList.length,
        itemBuilder: (_, index) => _buildUserTile(userList[index]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => BottomNavigationBarScreen(pageIndex: 0),
          ),
          (Route<dynamic> route) =>
              false, // purane saare routes clear ho jayenge
        );
        return false;
      },

      child: MainLayoutWidget(
        isLoading: _isLoading,
        appBar: AppBar(
          leading:
              widget.route == 'notification'
                  ? IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      pushNamedNavigate(
                        pageName: notificationScreenRoute,
                        context: context,
                      );
                    },
                  )
                  : null,
          title: const Text("Friends", style: TextStyle(color: Colors.white)),
          foregroundColor: Colors.white,
          backgroundColor: Colors.transparent,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(110),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  child: TextFormField(
                    controller: _searchController,
                    onChanged: _filterSearchResults,
                    cursorColor: Colors.white,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                    ),
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      hintText: 'Search',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: BorderSide(color: Colors.grey, width: 2.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(color: Colors.grey, width: 2.0),
                      ),
                    ),
                  ),
                ),
                TabBar(
                  controller: _tabController,

                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.blue,
                  tabs: const [
                    Tab(text: 'User'),
                    Tab(text: 'Sent'),
                    Tab(text: 'Received'),
                    Tab(text: 'Friends'),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: WillPopScope(
          onWillPop: () async {
            if (widget.route == 'notification') {
              pushNamedNavigate(
                pageName: notificationScreenRoute,
                context: context,
              );
              return false; // Prevent default back navigation
            } else {
              return true; // Allow back navigation
            }
          },
          child: TabBarView(
            controller: _tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildTabView(filteredOtherUsers),
              _buildTabView(filteredSendRequests),
              _buildTabView(filteredReceivedRequests),
              _buildTabView(filteredFriends),
            ],
          ),
        ),
      ),
    );
  }
}
