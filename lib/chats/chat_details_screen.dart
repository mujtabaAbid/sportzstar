

import 'package:flutter/material.dart';
import 'package:sportzstar/widgets/input_widget.dart';

class ChatDetailScreen extends StatefulWidget {
  final String name;
  final String? image;
  const ChatDetailScreen({super.key, required this.name, this.image});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isMe = true; // 👈 Alternating sender/receiver toggle

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _messages.add({'text': text, 'isMe': _isMe});
        _isMe = !_isMe; // 👈 Alternate sender and receiver
        _messageController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade50,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: widget.image != null
                  ? AssetImage(widget.image!)
                  : const AssetImage('assets/images/profile.jpeg'),
            ),
            const SizedBox(width: 10),
            Text(widget.name),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Align(
                  alignment: message['isMe']
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.75),
                    decoration: BoxDecoration(
                      color: message['isMe']
                          ? Colors.blue
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      message['text'],
                      style: TextStyle(
                        color: message['isMe']
                            ? Colors.white
                            : Colors.black87,
                        fontSize: 15,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: InputWidget(
                    // heading: 'Type a message...',
                    label: 'Type a message...',
                    backgroundColor: Colors.grey.shade200,
                    onSaved: (){},
                    controller: _messageController,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: _sendMessage,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
