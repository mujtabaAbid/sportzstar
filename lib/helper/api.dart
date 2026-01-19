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
// const userDataApi = '${apiUrl}users/';
const deleteUserApi =
    '${apiUrl}auth/get_notifications/3/'; //<-- (delete) 3= userid  //////////error in this api
// const notificationsApi = '${apiUrl}get_notifications/1/'; //get
String notificationApi({required int id}) {
  return '${apiUrl}get_notifications/$id/';
}

// const readNotificationsApi ='${apiUrl}notification_/read/20/';
String readNotificationsApi({required int id}) {
  return '${apiUrl}notification_/read/$id/';
}

// posts
const createPostApi =
    '${apiUrl}posts/create/'; // working on it, i will make a call but no response
const updatePostApi =
    '${apiUrl}posts/update/1/'; //patch  // wait for call response
// const deletePostApi = '${apiUrl}posts/delete/1/'; //del
String deletePostApi({required int id}) {
  return '${apiUrl}posts/delete/$id/';
}

// const allUserPostApi = '${apiUrl}posts/user/2/'; //get`
String allUserPostApi({required int id}) {
  return '${apiUrl}posts/user/$id/';
}

const allPostsApi = '${apiUrl}posts/'; //get
const likePostApi = '${apiUrl}posts/like/';
const unlikePostApi = '${apiUrl}posts/unlike/';
const saveCommentApi = '${apiUrl}posts/comment/';
const deleteCommentOnPostApi = '${apiUrl}posts/comment/delete';

//stories
const createStoryApi = '${apiUrl}stories/create/';
// const updateStoryApi = '${apiUrl}stories/update/1/'; //patch
// const deleteStoryApi = '${apiUrl}stories/delete/<post_id>/'; //get
String deleteStoryApi({required int id}) {
  return '${apiUrl}stories/delete/$id/';
}

// const getStoryWithUserIdApi = '${apiUrl}stories/2/'; //get
String getStoryWithUserIdApi({required int id}) {
  return '${apiUrl}stories/$id/';
}

const getAllStoriesApi = '${apiUrl}stories/'; //get

//friends
const addFriendApi = '${apiUrl}add-friend/';
// const getFriendApi =
//     '${apiUrl}get-friends/1/';
String getFriendApi({required int userId}) {
  return '${apiUrl}get-friends/$userId/';
}

const unfriendApi = '${apiUrl}unfriend/';
const acceptFriendApi = '${apiUrl}accept-friend/';
const rejectFriendApi = '${apiUrl}reject-friend/';

//events
const createEventApi = '${apiUrl}create-event/';
const listEventApi = '${apiUrl}events/'; //get
// const getEventByIdApi = '${apiUrl}events/1/'; //get
String getEventByIdApi({required int eventId}) {
  return '${apiUrl}events/$eventId/';
}
// const deleteEventByIdApi = '${apiUrl}events/delete/1/'; //get
String deleteEventByIdApi({required int id}) {
  return '${apiUrl}events/delete/$id/';
}

const addGuestInEventApi = '${apiUrl}add-event-guests/';

//others
const joinEventApi = '${apiUrl}join-event/';
const getSportsApi = '${apiUrl}sports/'; //get
const String kTermsAccepted = 'terms_accepted';
