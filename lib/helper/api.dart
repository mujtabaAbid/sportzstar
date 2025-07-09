import 'package:flutter/foundation.dart';

const basicUrl =
    kDebugMode
        ? 'http://77.37.125.189/' // Debug server URL
        : 'http://77.37.125.189/'; // Production server URL

const apiUrl = '${basicUrl}api/';
//users
const registerUser = '${apiUrl}auth/signup/';
const loginUser = '${apiUrl}auth/login/';
const usersList = '${apiUrl}users/'; //get
const updateUser = '${apiUrl}update-user/'; //patch
const verifyEmail = '${apiUrl}verify-email/';
const getCode = '${apiUrl}get_code/';
const updatePassword = '${apiUrl}update_password/';
const deleteUser =
    '${apiUrl}auth/get_notifications/3/'; //<-- (delete) 3= userid
const notifications = '${apiUrl}get_notifications/4/'; //get
const readNotifications = '${apiUrl}notification_/read/20/'; //get

// posts
const createPost = '${apiUrl}posts/create/';
const updatePost = '${apiUrl}posts/update/1/'; //patch
const deletePost = '${apiUrl}posts/delete/1/'; //del
const allUserPost = '${apiUrl}posts/user/2/'; //get
const allPosts = '${apiUrl}posts/'; //get
const likePost = '${apiUrl}posts/like/';
const unlikePost = '${apiUrl}posts/unlike/';
const commentOnPost = '${apiUrl}posts/comment/';
const deleteCommentOnPost = '${apiUrl}posts/comment/delete';

//stories
const createStory = '${apiUrl}stories/create/';
const updateStory = '${apiUrl}stories/update/1/'; //patch
const deleteStory = '${apiUrl}stories/delete/<post_id>/'; //get
const getStoryWithUserId = '${apiUrl}stories/2/'; //get
const getAllStories = '${apiUrl}stories/'; //get

//friends
const addFriend = '${apiUrl}add-friend/';
const getFriend = '${apiUrl}get-friends/1/'; //get
const unfriend = '${apiUrl}unfriend/';
const acceptFriend = '${apiUrl}accept-friend/';
const rejectFriend = '${apiUrl}reject-friend/';

//events
const createEvent = '${apiUrl}create-event/';
const listEvent = '${apiUrl}events/'; //get
const getEventById = '${apiUrl}events/1/'; //get
const deleteEventById = '${apiUrl}events/delete/1/'; //get
const addGuestInEvent = '${apiUrl}add-event-guests/';

//others
const joinEvent = '${apiUrl}join-event/';
const getSports = '${apiUrl}sports/'; //get
