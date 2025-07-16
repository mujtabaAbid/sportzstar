import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sportzstar/config/palette.dart';
import 'package:sportzstar/provider/home_provider.dart';

class PostCard extends StatefulWidget {
  final Map<String, dynamic> post;

  const PostCard({required this.post, super.key});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isExpanded = false;
  bool isLiked = false;
  int alphabetCount = 0;
  List<Map<String, dynamic>> likesList = [];
  int likes = 0;

  void countLikes() {
    setState(() {
      likes = widget.post['total_likes'] ?? 0;

      final rawLikes = widget.post['likes_list'];
      if (rawLikes is List) {
        likesList = List<Map<String, dynamic>>.from(rawLikes);
      } else {
        likesList = [];
      }
    });
  }

  Future<void> textCount() async {
    String text = widget.post['post_description'];
    alphabetCount = RegExp(r'[a-zA-Z]').allMatches(text).length;
  }

  String formatDate(String isoDateString) {
    // Parse the UTC time
    DateTime utcDate = DateTime.parse(isoDateString);

    // Convert to your local timezone
    DateTime localDate = utcDate.toLocal();

    // Format as "16 Apr 2025, 06:25 am"
    String formattedDate = DateFormat('dd MMM yyyy, hh:mm a').format(localDate);

    return formattedDate;
  }

  void toggle(String postId) async {
    setState(() {
      isLiked = !isLiked;
    });
    try {
      likesList.clear();
      final response =
          isLiked
              ? await Provider.of<HomeProvider>(
                context,
                listen: false,
              ).likePost(postId)
              : await Provider.of<HomeProvider>(
                context,
                listen: false,
              ).unlikePost(postId);
      final lists = List<Map<String, dynamic>>.from(response['likes_list']);

      setState(() {
        likes = response['total_likes'];
        likesList.addAll(lists); // = response;
      });

      print('total likes  toggle calll---likesList--->>>>>$likesList');
      print('like function toggle calll---likesList--->>>>>$likesList');
    } catch (e) {
      print('like function toggle calll- error----->>>>>$e');
    }
  }

  @override
  void initState() {
    super.initState();
    textCount();
    countLikes();
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
                post['user_profile'] ??
                    'https://e7.pngegg.com/pngimages/178/595/png-clipart-user-profile-computer-icons-login-user-avatars-monochrome-black-thumbnail.png',
                // 'https://plus.unsplash.com/premium_photo-1664203067979-47448934fd97?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8aHVtYW58ZW58MHx8MHx8fDA%3D',
              ),
            ),
            title: Text(
              post['user_name'],
              style: const TextStyle(fontSize: 16),
            ),
            subtitle: Row(
              children: [
                Text(formatDate(post['created_at'])),
                const SizedBox(width: 2),
                const Icon(Icons.public, size: 12),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Post Image
          if (post['image_url'] != null &&
              post['image_url'].toString().isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  post['image_url'],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 250,
                ),
              ),
            ),

          const SizedBox(height: 8),

          // Post Text (with "...more")
          if (post['post_description'] != null &&
              post['post_description'].toString().isNotEmpty)
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
                          text: '${post['user_name']} :  ',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: post['post_description']),
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
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        toggle(post['post_id'].toString());
                      },
                      onLongPress: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              child: Container(
                                width: double.maxFinite,
                                constraints: BoxConstraints(maxHeight: 400),
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      'Liked By',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    // ListView with shrinkWrap inside Flexible
                                    Flexible(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount:
                                            // likesList.isNotEmpty
                                            //     ?
                                            likesList.length,
                                        //     :
                                        // post['likes_list'].length,
                                        itemBuilder: (context, index) {
                                          final like =
                                              // likesList.isNotEmpty
                                              //     ?
                                              likesList[index];
                                          //     :
                                          // post['likes_list'][index];
                                          return ListTile(
                                            leading: CircleAvatar(
                                              backgroundImage:
                                                  like['user_profile'] !=
                                                              null &&
                                                          like['user_profile']
                                                              .toString()
                                                              .isNotEmpty
                                                      ? NetworkImage(
                                                        like['user_profile'],
                                                      )
                                                      : AssetImage(
                                                            'assets/profile/user.png',
                                                          )
                                                          as ImageProvider,
                                            ),
                                            title: Text(like['user_name']),
                                            subtitle: Text(
                                              formatDate(like['created_at']),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    // if (isLiked) ...[
                                    //   const SizedBox(height: 8),
                                    //   Text(
                                    //     'And You',
                                    //     style: TextStyle(
                                    //       color: Colors.black,
                                    //       fontSize: 16,
                                    //     ),
                                    //   ),
                                    // ],
                                    const SizedBox(height: 10),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(
                                          context,
                                        ).pop(); // Close dialog
                                      },
                                      child: const Text('Close'),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.thumb_up_alt,
                            size: 20,
                            color:
                                isLiked
                                    ? Palette.darkgreen
                                    : post['total_likes'] == 0
                                    ? Palette.darkgray
                                    : Palette.basicgreen,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            // 'sdf',
                            likes.toString(),
                            // '${isLiked ? post['total_likes'] + 1 : post['total_likes']} Likes',
                          ),
                        ],
                      ),
                    ),

                    TextButton(
                      onPressed: () {},
                      child: Row(
                        children: [
                          // const SizedBox(width: 6),
                          Icon(
                            Icons.comment,
                            size: 20,
                            color:
                                post['total_comments'] == 0
                                    ? Palette.darkgray
                                    : Colors.black,
                          ),
                          const SizedBox(width: 4),
                          Text('${post['total_comments']} Comments'),
                        ],
                      ),
                    ),
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
