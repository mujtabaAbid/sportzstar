import 'package:flutter/foundation.dart';

const basicUrl =
    kDebugMode
        ? 'http://77.37.125.189/' // Debug server URL
        : 'http://77.37.125.189/'; // Production server URL

const apiUrl = '${basicUrl}api/';
//users
const registerUserApi = '${apiUrl}auth/signup/';
const loginUserApi = '${apiUrl}auth/login/';
const usersListApi = '${apiUrl}users/'; //get
const updateUserApi = '${apiUrl}update-user/'; //patch
const verifyEmailApi = '${apiUrl}verify-email/';
const getCodeApi = '${apiUrl}get_code/';
const updatePasswordApi = '${apiUrl}update_password/';
const deleteUserApi =
    '${apiUrl}auth/get_notifications/3/'; //<-- (delete) 3= userid
const notificationsApi = '${apiUrl}get_notifications/4/'; //get
const readNotificationsApi = '${apiUrl}notification_/read/20/'; //get

// posts
const createPostApi = '${apiUrl}posts/create/';
const updatePostApi = '${apiUrl}posts/update/1/'; //patch
const deletePostApi = '${apiUrl}posts/delete/1/'; //del
const allUserPostApi = '${apiUrl}posts/user/2/'; //get
const allPostsApi = '${apiUrl}posts/'; //get
const likePostApi = '${apiUrl}posts/like/';
const unlikePostApi = '${apiUrl}posts/unlike/';
const commentOnPostApi = '${apiUrl}posts/comment/';
const deleteCommentOnPostApi = '${apiUrl}posts/comment/delete';

//stories
const createStoryApi = '${apiUrl}stories/create/';
const updateStoryApi = '${apiUrl}stories/update/1/'; //patch
const deleteStoryApi = '${apiUrl}stories/delete/<post_id>/'; //get
const getStoryWithUserIdApi = '${apiUrl}stories/2/'; //get
const getAllStoriesApi = '${apiUrl}stories/'; //get

//friends
const addFriendApi = '${apiUrl}add-friend/';
const getFriendApi = '${apiUrl}get-friends/1/'; //get
const unfriendApi = '${apiUrl}unfriend/';
const acceptFriendApi = '${apiUrl}accept-friend/';
const rejectFriendApi = '${apiUrl}reject-friend/';

//events
const createEventApi = '${apiUrl}create-event/';
const listEventApi = '${apiUrl}events/'; //get
const getEventByIdApi = '${apiUrl}events/1/'; //get
const deleteEventByIdApi = '${apiUrl}events/delete/1/'; //get
const addGuestInEventApi = '${apiUrl}add-event-guests/';

//others
const joinEventApi = '${apiUrl}join-event/';
const getSportsApi = '${apiUrl}sports/'; //get
