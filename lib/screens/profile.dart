import 'package:findconnect/screens/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../authentication/const.dart';
import '../components/error.dart';
import '../controller/user_profile_controller.dart';
import '../data/user_model.dart';

class UserProfile extends ConsumerWidget {
  static route(UserModel userModel) => MaterialPageRoute(
      builder: (context) => UserProfile(userModel: userModel));
  final UserModel userModel;
  const UserProfile({Key? key, required this.userModel}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserModel copyofUser = userModel;
    return Scaffold(
        body: ref.watch(getLatestUserProfileData).when(
            data: (data) {
              if (data.events.contains(
                  'databases.*.collections.${AppwriteConsts.collection}.documents.${copyofUser.uid}.update')) {
                copyofUser = UserModel.fromMap(data.payload);
              }
              return Profile(user: copyofUser);
            },
            error: (error, st) => Errorpage(error: error.toString()),
            loading: () {
              return Profile(user: copyofUser);
            }));
  }
}
