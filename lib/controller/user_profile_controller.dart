import 'package:findmychild/api/storage_api.dart';
import 'package:findmychild/api/post_api.dart';
import 'package:findmychild/api/user_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/utils.dart';
import '../data/postModel.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import '../data/user_model.dart';

final userProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>((ref) {
  return UserProfileController(
    storageApi: ref.watch(StorageApiProvider),
    tweetApi: ref.watch(tweetApiProvider),
    userAPI: ref.watch(UserApiProvider),
  );
});

final getUserTweetsProvider = FutureProvider.family((ref, String uid) async {
  final userprofilecontroller =
      ref.watch(userProfileControllerProvider.notifier);

  return userprofilecontroller.getUserTweets(uid);
});

final getLatestUserProfileData = StreamProvider((ref) {
  final userApi = ref.watch(UserApiProvider);
  return userApi.getlatestUserProfileData();
});

class UserProfileController extends StateNotifier<bool> {
  final UserAPI _userAPI;
  final StorageApi _storageApi;
  final TweetApi _tweetApi;
  UserProfileController(
      {required TweetApi tweetApi,
      required StorageApi storageApi,
      required UserAPI userAPI})
      : _tweetApi = tweetApi,
        _storageApi = storageApi,
        _userAPI = userAPI,
        super(false);

  Future<List<Tweet>> getUserTweets(String uid) async {
    final tweets = await _tweetApi.getUserTweets(uid);
    return tweets.map((e) => Tweet.fromMap(e.data)).toList();
  }

  void updateUserProfile({
    required UserModel usermodel,
    required BuildContext context,
    required File? bannerFile,
    required File? profileFile,
  }) async {
    state = true;
    if (bannerFile != null) {
      final bannerUrl = await _storageApi.uploadImage([bannerFile]);
      usermodel = usermodel.copyWith(bannerPic: bannerUrl[0]);
    }
    if (profileFile != null) {
      final profileUrl = await _storageApi.uploadImage([profileFile]);
      usermodel = usermodel.copyWith(profilePic: profileUrl[0]);
    }
    final res = await _userAPI.updateUserModel(usermodel);
    state = false;
    res.fold(
        (l) => showSnackBar(context, l.Message), (r) => Navigator.pop(context));
  }
}
