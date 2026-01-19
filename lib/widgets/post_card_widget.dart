import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:sportzstar/config/palette.dart';
import 'package:sportzstar/helper/close_keyboard.dart';
import 'package:sportzstar/helper/local_storage.dart';
import 'package:sportzstar/helper/page_navigate.dart';
import 'package:sportzstar/helper/report_dialog.dart';
import 'package:sportzstar/provider/home_provider.dart';
import 'package:sportzstar/provider/post_provider.dart';
import 'package:sportzstar/routing/routing_constrants.dart';
import 'package:sportzstar/screens/postScreens/post_detail_screen.dart';
import 'package:sportzstar/widgets/custom_button.dart';
// import 'package:sportzstar/widgets/input_widget.dart';
import 'package:sportzstar/widgets/video_player_widget.dart';
// import 'package:permission_handler/permission_handler.dart';

import '../helper/basic_enum.dart';
import '../screens/bottom_navigation_bar.dart';
import 'alerts/alert_notification_widget.dart';

enum PostDisplayType { text, image, video }

class PostCard extends StatefulWidget {
  final Map<String, dynamic> post;
  final String selectedCategory;
  final PostDisplayType displayType; // ✅ Add this

  const PostCard({
    required this.post,
    super.key,
    required this.displayType,
    required this.selectedCategory,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  bool isExpanded = false;
  bool isLiked = false;
  int alphabetCount = 0;
  Map<String, dynamic> userData = {};
  bool addComment = false;
  final TextEditingController _commentController = TextEditingController();
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {};
  // final GlobalKey _repaintKey = GlobalKey();
  // BuildContext? _loaderContext;
  static bool isChecked = false;

  // void blockusertoggle() {
  //   setState(() {
  //     isChecked = !isChecked;
  //   });
  // }

  Future<void> allpostsdata() async {
    try {
      final pref = await getDataFromLocalStorage(name: 'userData');
      userData = json.decode(pref);
      print('userData =====>>>${userData['id']}');

      setState(() {
        isLiked = (widget.post['likes_list'] as List).any(
          (like) => like['userId'] == userData['id'],
        );
      });

      print('isLiked =====>>>$isLiked');
    } catch (e) {
      print('allposts error-------------->>>>>>>$e');
    }
  }

  Future<void> textCount() async {
    String text = widget.post['post_description'];
    alphabetCount = RegExp(r'[a-zA-Z]').allMatches(text).length;
  }

  String formatDate(String isoDateString) {
    DateTime utcDate = DateTime.parse(isoDateString);

    DateTime localDate = utcDate.toLocal();
    String formattedDate = DateFormat('dd MMM yyyy, hh:mm a').format(localDate);

    return formattedDate;
  }

  void toggle(String postId) async {
    setState(() {
      isLiked = !isLiked;
    });
    try {
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
      setState(() {
        widget.post['total_likes'] = response['total_likes'];
        widget.post['likes_list'] = response['likes_list'];
      });

      print(
        'like function toggle calll---likesList--->>>>>${widget.post['likes_list']}',
      );
    } catch (e) {
      print('like function toggle calll- error----->>>>>$e');
    }
  }

  void deleteComment({
    required int commentId,
    required StateSetter setModalState,
    required Map<String, dynamic> post,
  }) async {
    print(
      'commentr id ------>>>> $commentId and type == ${commentId.runtimeType}',
    );
    try {
      final response = await Provider.of<HomeProvider>(
        context,
        listen: false,
      ).deleteComment(commentId);
      if (response.statusCode == 200) {
        // Then update the comment list in the post
        print('comment deleted------->>>>>${response.body}');
        setModalState(() {
          post['comments_list'].removeWhere((comment) {
            print(
              'all comment id =====>>${comment['comment_id'].toString()} and ${comment['id'].toString()}',
            );
            return (comment['comment_id'] ?? comment['id']) == commentId;
          });
        });
      } else {
        print(
          'responser of delete comment function --------->>>>>>${response.body}',
        );
      }
    } catch (e) {
      print('responser of delete comment function ---e------>>>>>>$e');
    }
  }

  void deletePost(int postId) async {
    try {
      final response = Provider.of<PostProvider>(
        context,
        listen: false,
      ).deletePostFunction(postId: postId);
      print('deletePost function  success--------->>>>>>$response');
      Navigator.of(context).push(
        MaterialPageRoute(
          builder:
              (context) => BottomNavigationBarScreen(
                pageIndex: 0,
                selectCat: widget.selectedCategory,
              ),
        ),
      );
    } catch (e) {
      print('deletePost error function e--------->>>>>>$e');
    }
  }

  @override
  void initState() {
    super.initState();
    allpostsdata();
    textCount();
  }

  String handleSave(String type, String value) {
    return _formData[type] = value;
  }

  Future<void> handleSubmit(StateSetter setModalState) async {
    setState(() {
      _isLoading = true;
    });
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      closeKeyboard(context: context);

      try {
        final response = await Provider.of<HomeProvider>(
          context,
          listen: false,
        ).uploadComments(formData: _formData);

        setModalState(() {
          widget.post['comments_list'] = response;
        });
      } catch (e) {
        alertNotification(
          context: context,
          message: 'Something went wrong.\nTry again later.',
          messageType: AlertMessageType.error,
        );
        print('Error saving comment: $e');
      }
      _commentController.clear();
    } else {
      alertNotification(
        context: context,
        message: 'Please enter a valid comment.',
        messageType: AlertMessageType.error,
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final post = widget.post;
    // final String postType = post['post_type'] ?? '';
    final String? videoUrl = post['video_url'];
    final String? description = post['post_description'];
    bool isVideoPost = false;
    bool isImagePost = false;

    if (videoUrl != null) {
      if (videoUrl.endsWith('.mp4') ||
          videoUrl.endsWith('.mov') ||
          videoUrl.endsWith('.avi') ||
          videoUrl.endsWith('.mkv')) {
        isVideoPost = true;
      } else {
        isImagePost = true;
      }
    }
    if (post['image_url'] != null) {
      isImagePost = true;
      isVideoPost = false;
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => PostDetailScreen(post: post)),
        );
      },
      child: Card(
        // decoration: BoxDecoration(
        //   color: Colors.white,
        //   borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
        // ),
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            // Header
            ListTile(
              trailing:
                  userData['id'] == post['user_id']
                      ? PopupMenuButton<String>(
                        icon: Icon(Icons.more_horiz_rounded, size: 24),
                        onSelected: (String value) {
                          if (value == 'delete') {
                            deletePost(post['post_id']);
                            print(
                              '---delete post function call button--------',
                            );
                          } else if (value == 'update') {
                            print(
                              '---update post function call button--------',
                            );
                          } else {
                            print('---Nothing call--------');
                          }
                        },
                        itemBuilder:
                            (BuildContext context) => [
                              PopupMenuItem<String>(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete, color: Colors.red),
                                    SizedBox(width: 8),
                                    Text('Delete'),
                                  ],
                                ),
                              ),
                            ],
                      )
                      : PopupMenuButton<String>(
                        icon: const Icon(Icons.more_horiz_rounded),
                        onSelected: (value) {
                          if (value == 'report') {
                            ReportDialogHelper.showReportDialog(context);
                          } else if (value == 'delete') {
                            // bool isChecked = false;
                            showDialog(
                              context: context,
                              useRootNavigator: true,
                              barrierDismissible: false,
                              builder: (_) {
                                return StatefulBuilder(
                                  builder: (context, setStateDialog) {
                                    return AlertDialog(
                                      title: const Text(
                                        'Delete Post',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      content: Text(
                                        'Are you sure you want to delete this post?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(
                                              context,
                                              rootNavigator: true,
                                            ).pop();
                                            removeDataFromLocalStorage(
                                              // name: 'blockUser',
                                              name: 'deletePost',
                                            );
                                            removeDataFromLocalStorage(
                                              name: 'blockUser',
                                              // name: 'deletePost',
                                            );
                                          },
                                          child: Text('Cancel'),
                                        ),
                                        TextButton(
                                          child: const Text('OK'),
                                          onPressed: () async {
                                            List<dynamic> deletePost = [];

                                            final oldData =
                                                await getDataFromLocalStorage(
                                                  name: 'deletePost',
                                                );
                                            if (oldData != null &&
                                                oldData.toString().isNotEmpty) {
                                              deletePost = jsonDecode(
                                                oldData.toString(),
                                              );
                                            }
                                            if (!deletePost.contains(
                                              post['post_id'],
                                            )) {
                                              deletePost.add(post['post_id']);
                                            }

                                            final deletePostdata = jsonEncode(
                                              deletePost,
                                            );
                                            await addDataToLocalStorage(
                                              name: 'deletePost',
                                              value: deletePostdata,
                                            );
                                            pushNamedAndRemoveUntilNavigate(
                                              pageName:
                                                  bottomNavigationBarRoute,
                                              context: context,
                                            );
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            );
                          } else {
                            showDialog(
                              context: context,
                              useRootNavigator: true,
                              builder: (_) {
                                return StatefulBuilder(
                                  builder: (context, setStateDialog) {
                                    return AlertDialog(
                                      title: const Text(
                                        'Block User',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      content: SizedBox(
                                        height: 70,
                                        child: Column(
                                          children: [
                                            const Text(
                                              'Once User is blocked, you will no longer see their posts. Are you sure you want to block this user?',
                                            ),
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          child: const Text('Cancel'),
                                          onPressed: () async {
                                            final pref =
                                                await getDataFromLocalStorage(
                                                  name: 'blockUser',
                                                );
                                            final pref2 =
                                                await getDataFromLocalStorage(
                                                  name: 'deletePost',
                                                );
                                            final data = jsonDecode(
                                              pref.toString(),
                                            );
                                            final data2 = jsonDecode(
                                              pref2.toString(),
                                            );
                                            print(
                                              'block user list = ${data.toString()} === delete post list = ${data2.toString()}',
                                            );
                                            // removeDataFromLocalStorage(
                                            //   // name: 'blockUser',
                                            //   name: 'deletePost',
                                            // );
                                            Navigator.of(
                                              context,
                                              rootNavigator: true,
                                            ).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: const Text('OK'),
                                          onPressed: () async {
                                            List<dynamic> blockUser = [];

                                            final oldData =
                                                await getDataFromLocalStorage(
                                                  name: 'blockUser',
                                                );
                                            if (oldData != null &&
                                                oldData.toString().isNotEmpty) {
                                              blockUser = jsonDecode(
                                                oldData.toString(),
                                              );
                                            }
                                            if (!blockUser.contains(
                                              post['user_id'],
                                            )) {
                                              blockUser.add(post['user_id']);
                                            }

                                            final blockuserdata = jsonEncode(
                                              blockUser,
                                            );
                                            await addDataToLocalStorage(
                                              name: 'blockUser',
                                              value: blockuserdata,
                                            );
                                            pushNamedAndRemoveUntilNavigate(
                                              pageName:
                                                  bottomNavigationBarRoute,
                                              context: context,
                                            );
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            );
                          }
                        },
                        itemBuilder:
                            (_) => const [
                              PopupMenuItem(
                                value: 'report',
                                child: Row(
                                  children: [
                                    Icon(Icons.flag, color: Colors.orange),
                                    SizedBox(width: 8),
                                    Text('Report'),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(Icons.block, color: Colors.red),
                                    SizedBox(width: 8),
                                    Text('Delete Post'),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'block',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.person_off_outlined,
                                      color: Colors.red,
                                    ),
                                    SizedBox(width: 8),
                                    Text('Block User'),
                                  ],
                                ),
                              ),
                            ],
                      ),

              leading: CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(
                  post['user_profile'] ??
                      'https://e7.pngegg.com/pngimages/178/595/png-clipart-user-profile-computer-icons-login-user-avatars-monochrome-black-thumbnail.png',
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
            if (isImagePost && videoUrl != null || post['image_url'] != null)
              // if (post['image_url'] != null &&
              //     post['image_url'].toString().isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    videoUrl ?? post['image_url'],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 250,
                    // 👇 Show loader until image is fully loaded (no progressive display)
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child; // Only show the image when fully loaded
                      } else {
                        return Container(
                          width: double.infinity,
                          height: 250,
                          color:
                              Colors
                                  .grey
                                  .shade200, // optional placeholder color
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                    },
                    // 👇 Optional error fallback
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: double.infinity,
                        height: 250,
                        color: Colors.grey.shade300,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.broken_image,
                          color: Colors.grey,
                          size: 60,
                        ),
                      );
                    },
                  ),
                ),
              )
            else if (isVideoPost && videoUrl != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: VideoPlayerWidget(
                      videoUrl: videoUrl,
                    ), // You must create this widget
                  ),
                ),
              )
            else
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical:
                      post['post_description'].toString().length < 35 ? 80 : 20,
                ),
                color: Palette.basicgray,
                child: Text(
                  post['post_description'],
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            if (post['post_type'] != 'text') const SizedBox(height: 8),
            // Post Text (with "...more")

            // const SizedBox(height: 8),
            // like comments upload and copy section
            Padding(
              // height: 20,
              // color: Colors.amber,
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Like Section
                  TextButton(
                    style: ButtonStyle(
                      padding: WidgetStateProperty.all<EdgeInsets>(
                        EdgeInsets.zero,
                      ),
                      minimumSize: WidgetStateProperty.all<Size>(Size(0, 0)),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
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
                                  Flexible(
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: post['likes_list'].length,
                                      itemBuilder: (context, index) {
                                        final like = post['likes_list'][index];
                                        return ListTile(
                                          leading: CircleAvatar(
                                            backgroundImage:
                                                like['user_profile'] != null &&
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
                        // SizedBox(width: 6),
                        Icon(
                          Icons.thumb_up_alt,
                          size: 20,
                          // color:
                          //     (post['likes_list'] as List).any(
                          //           (like) =>
                          //               like['userId'] == userData['id'],
                          //         )
                          //         ? Palette.darkgreen
                          //         : Palette.darkgray,
                        ),
                        const SizedBox(width: 4),
                        Text(' ${post['total_likes'].toString()}'),
                      ],
                    ),
                  ),
                  // post comment section
                  // comment Section
                  TextButton(
                    style: ButtonStyle(
                      padding: WidgetStateProperty.all<EdgeInsets>(
                        EdgeInsets.zero,
                      ),
                      minimumSize: WidgetStateProperty.all<Size>(Size(0, 0)),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled:
                            true, // optional, if content is large
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                        ),
                        isDismissible: true,
                        builder: (BuildContext context) {
                          return StatefulBuilder(
                            builder: (
                              BuildContext context,
                              StateSetter setModalState,
                            ) {
                              return FractionallySizedBox(
                                heightFactor: 0.8,
                                // widthFactor: MediaQuery.of(context).size.width,
                                child: Container(
                                  padding: EdgeInsets.only(
                                    top: 30,
                                    // left: 16,
                                    // right: 16,
                                  ),
                                  child: Column(
                                    children: [
                                      const Text(
                                        'Comments By',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                          horizontal: 18,
                                        ),
                                        child: Form(
                                          key: _formKey,
                                          child: TextFormField(
                                            keyboardType:
                                                TextInputType.multiline,
                                            maxLines: null,
                                            controller: _commentController,
                                            minLines: 1,
                                            onSaved: (value) {
                                              handleSave('comment', value!);
                                            },
                                            style: const TextStyle(
                                              color: Colors.black,
                                            ),
                                            decoration: InputDecoration(
                                              suffixIcon: IconButton(
                                                icon: Icon(
                                                  Icons.send,
                                                  color: Colors.black,
                                                ),
                                                onPressed: () {
                                                  // Navigator.of(context).pop();
                                                  handleSave(
                                                    'post_id',
                                                    post['post_id'].toString(),
                                                  );
                                                  handleSubmit(setModalState);

                                                  print('Post button tapped');
                                                },
                                              ),
                                              hintText: 'Comments',
                                              filled: true,
                                              fillColor: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 12),

                                      Flexible(
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount:
                                              post['comments_list'].length,
                                          itemBuilder: (context, index) {
                                            final comment =
                                                post['comments_list'][index];
                                            return ListTile(
                                              leading: CircleAvatar(
                                                radius: 26,
                                                backgroundImage:
                                                    comment['user_profile'] !=
                                                                null &&
                                                            comment['user_profile']
                                                                .toString()
                                                                .isNotEmpty
                                                        ? NetworkImage(
                                                          comment['user_profile'],
                                                        )
                                                        : AssetImage(
                                                              'assets/profile/user.png',
                                                            )
                                                            as ImageProvider,
                                              ),
                                              trailing:
                                                  (comment['userId'] ??
                                                              comment['user_id']) ==
                                                          userData['id']
                                                      ? IconButton(
                                                        onPressed: () {
                                                          print(
                                                            '---=${comment['comment_id']} and ${comment['id']}-----------',
                                                          );
                                                          deleteComment(
                                                            commentId:
                                                                comment['comment_id'] ??
                                                                comment['id'],
                                                            setModalState:
                                                                setModalState,
                                                            post: widget.post,
                                                          );
                                                        },
                                                        icon: Icon(
                                                          Icons.delete,
                                                          color: Colors.red,
                                                        ),
                                                      )
                                                      : SizedBox(),
                                              title: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    comment['user_name'],
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  Text('${comment['comment']}'),
                                                ],
                                              ),
                                              subtitle: Text(
                                                formatDate(
                                                  comment['created_at'],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),

                                      const SizedBox(height: 10),
                                      // TextButton(
                                      //   onPressed: () {
                                      //     Navigator.of(
                                      //       context,
                                      //     ).pop(); // Close dialog
                                      //   },
                                      //   child: const Text('Close'),
                                      // ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },

                    child: Row(
                      children: [
                        // SizedBox(width: 6),
                        Icon(
                          Icons.comment,
                          size: 20,
                          // color: Palette.darkgray,
                        ),
                        const SizedBox(width: 4),
                        Text('${post['comments_list'].length}'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // description with user name portion
            if (description != null && description.isNotEmpty
            //  &&
            // post['post_type'] != 'text'
            )
              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 20,
                  bottom: 2,
                  // vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                            text: '${post['user_name']} : ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: description),
                        ],
                      ),
                      maxLines: isExpanded ? null : 2,
                      overflow:
                          isExpanded
                              ? TextOverflow.visible
                              : TextOverflow.ellipsis,
                    ),
                    if (description.length >= 70)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isExpanded = !isExpanded;
                          });
                        },
                        child: Text(
                          isExpanded ? 'less' : 'more',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
