import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportzstar/widgets/Layout/main_layout_widget.dart';

import '../../provider/home_provider.dart';

class AddFriendsList extends StatefulWidget {
  const AddFriendsList({super.key});

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

      print('API Response: $usersData');

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
    _tabController = TabController(length: 4, vsync: this);
    super.initState();
    allUsers();
  }

  Widget _buildUserTile(Map<String, dynamic> otherUsers) {
    return Container(
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
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade700,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            child: const Text(
              "Add Friend",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
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
    return MainLayoutWidget(
      isLoading: _isLoading,
      appBar: AppBar(
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
      body: TabBarView(
        controller: _tabController,
        children: [
          // _buildTabView(otherUsers),
          // _buildTabView(sendRequestsUsers),
          // _buildTabView(recievedRequestUsers),
          // _buildTabView(friends),
          _buildTabView(filteredOtherUsers),
          _buildTabView(filteredSendRequests),
          _buildTabView(filteredReceivedRequests),
          _buildTabView(filteredFriends),
        ],
      ),
    );
  }
}
