import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:sportzstar/chats/chat_details_screen.dart';
import 'package:sportzstar/widgets/Layout/main_layout_widget.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final bool _isLoading = false;
  final List<Map<String, dynamic>> chatData = const [
    {
      'name': 'zaheer',
      'message': 'haii',
      'time': '05:24 pm',
      'image': 'assets/profile/profile.jpeg',
    },
    {
      'name': 'Nadeem Ahmad',
      'message': '26 Mar, 2025',
      'time': '01:45 pm',
      'image': 'assets/profile/img4.jpg',
    },
    {
      'name': 'Aliya',
      'message': '26 Mar, 2025',
      'time': '01:45 pm',
      'image': 'assets/profile/img3.jpeg',
    },
    {
      'name': 'Ahmad',
      'message': '26 Mar, 2025',
      'time': '01:45 pm',
      'image': 'assets/profile/img5.jpg',
    },
  ];

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
      ),
      body: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: chatData.length,
            itemBuilder: (context, index) {
              final chat = chatData[index];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                leading: CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage(chat['image']),
                ),
                title: Text(
                  chat['name'],
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                ),
                subtitle: Text(chat['message'], style: const TextStyle( color: Colors.white),),
                trailing: Text(chat['time'],  style: const TextStyle( color: Colors.white),),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => ChatDetailScreen(
                            name: chat['name'],
                            image: chat['image'],
                          ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
