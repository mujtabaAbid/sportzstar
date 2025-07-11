import 'package:flutter/material.dart';
import 'package:sportzstar/config/palette.dart';

class PostCard extends StatefulWidget {
  final Map<String, dynamic> post;

  const PostCard({required this.post, super.key});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isExpanded = false;
  int alphabetCount = 0;

  Future<void> textCount() async {
    String text = widget.post['text'];
    alphabetCount = RegExp(r'[a-zA-Z]').allMatches(text).length;
  }

  @override
  void initState() {
    super.initState();
    textCount();
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          ListTile(
            trailing: const Icon(Icons.more_horiz_rounded, size: 24),
            leading: CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage(
                post['profileImage'] ??
                    'https://plus.unsplash.com/premium_photo-1664203067979-47448934fd97?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8aHVtYW58ZW58MHx8MHx8fDA%3D',
              ),
            ),
            title: Text(post['username'], style: const TextStyle(fontSize: 16)),
            subtitle: Row(
              children: [
                Text(post['time']),
                const SizedBox(width: 2),
                const Icon(Icons.public, size: 12),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Post Image
          if (post['image'] != null && post['image'].toString().isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  post['image'],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 250,
                ),
              ),
            ),

          const SizedBox(height: 8),

          // Post Text (with "...more")
          if (post['text'] != null && post['text'].toString().isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: '${post['username']} :  ',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: post['text']),
                      ],
                    ),
                    maxLines: isExpanded ? null : 2,
                    overflow:
                        isExpanded
                            ? TextOverflow.visible
                            : TextOverflow.ellipsis,
                  ),
                  alphabetCount >= 70
                      ? GestureDetector(
                        onTap: () {
                          setState(() {
                            isExpanded = !isExpanded;
                          });
                        },
                        child: Text(
                          isExpanded ? 'less' : 'more',
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                      : SizedBox(),
                ],
              ),
            ),

          const SizedBox(height: 8),

          // Likes & Comments count
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.thumb_up_alt,
                      color:
                          post['likes'] == 0
                              ? Palette.darkgray
                              : Palette.basicgreen,
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text('${post['likes']} Likes'),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.comment,
                      size: 20,
                      color:
                          post['comments'] == 0
                              ? Palette.darkgray
                              : Colors.black,
                    ),
                    const SizedBox(width: 4),
                    Text('${post['comments']} Comments'),
                  ],
                ),
                SizedBox(),
                SizedBox(),
                Row(
                  children: [
                    Icon(
                      Icons.file_upload_outlined,
                      // color:
                      //     post['likes'] == 0
                      //         ? Palette.darkgray
                      //         : Palette.basicgreen,
                      size: 20,
                    ),
                    // const SizedBox(width: 4),
                    // Text('${post['likes']}'),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.bookmarks_outlined,
                      size: 20,
                      // color:
                      //     post['comments'] == 0
                      //         ? Palette.darkgray
                      //         : Colors.black,
                    ),
                    // const SizedBox(width: 4),
                    // Text('${post['comments']}'),
                  ],
                ),
              ],
            ),
          ),

          // const Divider(),

          // Like and Comment buttons
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       TextButton.icon(
          //         onPressed: () {},
          //         icon: const Icon(Icons.favorite_border),
          //         label: const Text('Like'),
          //       ),
          //       TextButton.icon(
          //         onPressed: () {},
          //         icon: const Icon(Icons.comment_outlined),
          //         label: const Text('Comment'),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
