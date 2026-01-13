import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportzstar/provider/friends_provider.dart';
import 'package:sportzstar/screens/chats/chat_details_screen.dart';
import 'package:sportzstar/widgets/Layout/main_layout_widget.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  bool _isLoading = false;
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;
  List<int> allowedFriendIds = [];

  // ChatId generator
  String getChatId(String uid1, String uid2) {
    if (uid1.hashCode <= uid2.hashCode) {
      return "${uid1}_$uid2";
    } else {
      return "${uid2}_$uid1";
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });
    setUserStatus(true); // online kar do
    fetchFriendIds();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    setUserStatus(false); // offline kar do
    super.dispose();
  }

  Future<void> setUserStatus(bool isOnline) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection("users").doc(uid).update({
      "isOnline": isOnline,
      "lastSeen": DateTime.now(),
    });
  }

  Future<void> fetchFriendIds() async {
    try {
      final data =
          await Provider.of<FriendsProvider>(
            context,
            listen: false,
          ).getFriendsIds();

      List<dynamic> ids = data['friends_list'];

      setState(() {
        allowedFriendIds = ids.map((e) => int.parse(e.toString())).toList();
      });

      print("✅ Allowed friends list: $allowedFriendIds");
    } catch (e) {
      print("get friend data ids error--------->>> $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayoutWidget(
      isLoading: _isLoading,
      appBar: AppBar(
        title: const Text(
          'Chats',
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data!.docs;
          final filteredUsers =
              users.where((user) {
                final backendId =
                    user['userId']; // Firebase doc me stored backend userId
                return backendId != null &&
                    allowedFriendIds.contains(backendId);
              }).toList();

          return ListView.builder(
            itemCount: filteredUsers.length,
            itemBuilder: (context, index) {
              // final user = users[index];
              final user = filteredUsers[index];
              final userId = user.id;

              // apna khud ka account skip karo
              if (userId == currentUserId) return const SizedBox.shrink();

              final chatId = getChatId(currentUserId, userId);

              return StreamBuilder<DocumentSnapshot>(
                stream:
                    FirebaseFirestore.instance
                        .collection('chats')
                        .doc(chatId)
                        .snapshots(),
                builder: (context, chatSnapshot) {
                  String lastMessage = "";
                  int unreadCount = 0;

                  if (chatSnapshot.hasData && chatSnapshot.data!.exists) {
                    final chatData =
                        chatSnapshot.data!.data() as Map<String, dynamic>;
                    lastMessage = chatData['lastMessage'] ?? "";
                    unreadCount = chatData['unreadCount_$currentUserId'] ?? 0;
                  }

                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    leading: Stack(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundImage:
                              user['profileImage'] != null &&
                                      user['profileImage'].toString().isNotEmpty
                                  ? NetworkImage(user['profileImage'])
                                  : const AssetImage(
                                        'assets/images/profile.jpeg',
                                      )
                                      as ImageProvider,
                        ),
                        // online status
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            height: 12,
                            width: 12,
                            decoration: BoxDecoration(
                              color:
                                  (user['isOnline'] ?? false)
                                      ? Colors.green
                                      : Colors.grey,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                        ),
                      ],
                    ),
                    title: Text(
                      user['fullName'] ?? "No Name",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      lastMessage.isNotEmpty ? lastMessage : "No messages yet",
                      style: const TextStyle(color: Colors.white70),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing:
                        unreadCount > 0
                            ? Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                unreadCount.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            )
                            : null,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => ChatDetailScreen(
                                // name: user['fullName'],
                                receiverId: userId,
                                // image: user['profileImage'],
                              ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
