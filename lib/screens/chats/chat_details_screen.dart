import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sportzstar/widgets/Layout/main_layout_widget.dart';
import 'package:sportzstar/widgets/input_widget.dart';
import 'package:intl/intl.dart';

class ChatDetailScreen extends StatefulWidget {
  final String receiverId; // 👈 sirf ye pass karna hai

  const ChatDetailScreen({super.key, required this.receiverId});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final String senderId = FirebaseAuth.instance.currentUser!.uid;

  String get chatId {
    if (senderId.hashCode <= widget.receiverId.hashCode) {
      return "${senderId}_${widget.receiverId}";
    } else {
      return "${widget.receiverId}_$senderId";
    }
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final docRef =
        FirebaseFirestore.instance
            .collection('chats')
            .doc(chatId)
            .collection('messages')
            .doc();

    await docRef.set({
      'senderId': senderId,
      'receiverId': widget.receiverId,
      'text': text,
      'type': 'text',
      'createdAt': FieldValue.serverTimestamp(),
      'status': 'sent',
      'isRead': false,
    });

    final chatDoc = FirebaseFirestore.instance.collection('chats').doc(chatId);

    await chatDoc.set({
      'participants': [senderId, widget.receiverId],
      'lastMessage': text,
      'updatedAt': FieldValue.serverTimestamp(),
      'unreadCount_${widget.receiverId}': FieldValue.increment(1),
    }, SetOptions(merge: true));

    _messageController.clear();
  }

  Future<void> _markMessagesAsRead() async {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance.collection('chats').doc(chatId).update({
      "unreadCount_$currentUserId": 0,
    });

    final messages =
        await FirebaseFirestore.instance
            .collection('chats')
            .doc(chatId)
            .collection('messages')
            .where("receiverId", isEqualTo: currentUserId)
            .where("isRead", isEqualTo: false)
            .get();

    for (var msg in messages.docs) {
      await msg.reference.update({"isRead": true});
    }
  }

  String _formatLastSeen(DateTime lastSeenTime) {
    final now = DateTime.now();
    final diff = now.difference(lastSeenTime);

    if (diff.inMinutes < 60) {
      return "${diff.inMinutes} min ago";
    } else if (diff.inHours < 24 && now.day == lastSeenTime.day) {
      return "Today, ${DateFormat('hh:mm a').format(lastSeenTime)}";
    } else if (diff.inHours < 48 &&
        now.subtract(const Duration(days: 1)).day == lastSeenTime.day) {
      return "Yesterday, ${DateFormat('hh:mm a').format(lastSeenTime)}";
    } else {
      return DateFormat('MMM d, hh:mm a').format(lastSeenTime);
    }
  }

  @override
  void initState() {
    super.initState();
    _markMessagesAsRead();
  }

  @override
  void dispose() {
    _markMessagesAsRead();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MainLayoutWidget(
      isLoading: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        title: StreamBuilder<DocumentSnapshot>(
          stream:
              FirebaseFirestore.instance
                  .collection("users")
                  .doc(widget.receiverId)
                  .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return Row(
                children: const [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage('assets/images/profile.jpeg'),
                  ),
                  SizedBox(width: 10),
                  Text("Loading...", style: TextStyle(color: Colors.white)),
                ],
              );
            }

            final userData = snapshot.data!.data() as Map<String, dynamic>;
            final isOnline = userData['isOnline'] ?? false;
            final lastSeen = userData['lastSeen'];
            final userName = "${userData['fullName'] ?? ''}".trim();
            final image = userData['profileImage'] ?? "";

            return Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage:
                          (image.isNotEmpty)
                              ? NetworkImage(image)
                              : const AssetImage('assets/images/profile.jpeg')
                                  as ImageProvider,
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        height: 12,
                        width: 12,
                        decoration: BoxDecoration(
                          color: isOnline ? Colors.green : Colors.grey,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName.isNotEmpty ? userName : "Unknown",
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Text(
                      isOnline
                          ? "Online"
                          : lastSeen != null
                          ? "Last seen: ${_formatLastSeen((lastSeen as Timestamp).toDate().toLocal())}"
                          : "Offline",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),

      // 👇 Messages + Input
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance
                      .collection('chats')
                      .doc(chatId)
                      .collection('messages')
                      .orderBy('createdAt', descending: true)
                      .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(12),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message =
                        messages[index].data() as Map<String, dynamic>;
                    final isMe = message['senderId'] == senderId;

                    return Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.all(12),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.75,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isMe
                                  ? Colors.blue
                                  : const Color.fromARGB(61, 255, 255, 255),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          message['text'] ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // 👇 Input field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: InputWidget(
                    label: 'Type a message...',
                    backgroundColor: const Color.fromARGB(66, 238, 238, 238),
                    onSaved: () {},
                    controller: _messageController,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 16),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
