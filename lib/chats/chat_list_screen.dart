
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:sportzstar/chats/chat_details_screen.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

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
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(title: const Text('Chats'), backgroundColor:  Colors.grey.shade50,),
      body: ListView.builder(
        itemCount: chatData.length,
        itemBuilder: (context, index) {
          final chat = chatData[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            leading: CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage(chat['image']),
            ),
            title: Text(
              chat['name'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(chat['message']),
            trailing: Text(chat['time']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatDetailScreen(name: chat['name'], image: chat['image']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
