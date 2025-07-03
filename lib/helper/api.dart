import 'package:flutter/foundation.dart';

const basicUrl = kDebugMode
    ? 'https://dev.spot-me.org/' // Debug server URL
    : 'https://spot-me.org/'; // Production server URL

const apiUrl = '${basicUrl}api/';

const getIntrests = '${apiUrl}interests';
const registerUser = '${apiUrl}register';
const getUserOtp = '${apiUrl}otp';
const login = '${apiUrl}login';
const otpVerify = '${apiUrl}otp/verify';
const resetPasswordApi = '${apiUrl}enter-new-password';
const saveIntrest = '${apiUrl}user-interest';
const updateUserProfileApi = '${apiUrl}update-profile';
const sendMessageApi = '${apiUrl}send-message';
const deviceTokenApi = '${apiUrl}device-token';
const specificUserChatApi = '${apiUrl}user-chat';
const allChatUsersApi = '${apiUrl}chats';
const allAppUsersApi = '${apiUrl}users';
const readMessageApi = '${apiUrl}read-status';
const onlineStatusApi = '${apiUrl}online-status';
const allNotificationsApi = '${apiUrl}show-notifications';
const discoverApprovalApi = '${apiUrl}approval';
const getExercisesApi = '${apiUrl}exercises';
const createScheduleApi = '${apiUrl}schedules/create';
const discoverUsersApi = '${apiUrl}discover-user-list';
const discoverActionApi = '${apiUrl}discover';
const notificationtAlertApi = '${apiUrl}notification-status';
const scheduleApprovalApi = '${apiUrl}schedules/accept-reject';
const scheduleDotsCounterApi = '${apiUrl}schedules/counter';
const getScheduleDatewiseApi = '${apiUrl}schedules/get-schedule-date-wise';
const notificationReadApi = '${apiUrl}read-notification';
const logoutApi = '${apiUrl}logout';
const privacyPolicyApi = '${apiUrl}privacy-policy';
const appleLoginApi = '${apiUrl}login/apple';
const googleLoginApi = '${apiUrl}login/google';
const testingApi = '${apiUrl}testing';
const termAndConditionApi = '${apiUrl}terms-and-conditions';
const blockUserApi = '${apiUrl}block-user';
const unblockUserApi = '${apiUrl}unblock-user';
const blockUserListApi = '${apiUrl}block-user-list';
const getUserDataByIdApi = '${apiUrl}get-user-data-by-id';
const mcqsQuestionsApi = '${apiUrl}questions';
const mcqsAnswerStoreApi = '${apiUrl}awnsers';
const deleteAccountApi = '${apiUrl}users/deleted';
const storeMultipleImagesApi = '${apiUrl}upload-images';
const profilePercentageApi = '${apiUrl}profile-percentage';
const humanVerifiedApi = '${apiUrl}humen/verified/at';
const showUserMultipleImagesApi = '${apiUrl}show-multiple-images';
const getDiscoverUserImagesApi = '${apiUrl}show-multiple-images/by/user';
const storeFlageSystemApi = '${apiUrl}flage';
const checkEmailApi = '${apiUrl}email/checked';
const verifyAnswersApi = '${apiUrl}available/answer';
const matchUserApi = '${apiUrl}match-users';
const unmatchUserApi = '${apiUrl}un-match-user';
const uploadProfileImageApi = '${apiUrl}change-profile-photo';
const userDetailApi = '${apiUrl}user-details';
const userUpdateAnswer = '${apiUrl}awnsers/update';
const questionByIdApi = '${apiUrl}get-question-by-id';
const updateUserImagesApi = '${apiUrl}update-user-images';
const updateLocationApi = '${apiUrl}update-location';
const feedbackApi = '${apiUrl}feedback';
const getLocationApi = '${apiUrl}check/location';
const saveSpotifyTokenApi = '${apiUrl}spotify/user-access-token';

// const getIntrests = '${apiUrl}apiNameHere';
