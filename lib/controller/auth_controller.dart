import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:appwrite/models.dart' as model;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/auth_api.dart';
import '../api/user_api.dart';
import '../core/utils.dart';
import '../data/user_model.dart';
import '../screens/home.dart';
import '../screens/sign_in.dart';
import '../screens/signup.dart';

final authControllerProvider =
    StateNotifierProvider<Authcotroller, bool>((ref) {
  return Authcotroller(
      userAPI: ref.watch(UserApiProvider), authApi: ref.watch(AuthApiProvider));
});

final CurrentUserAccountProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.currentuser();
});

final CurrentUserDetailProvider = FutureProvider((ref) {
  final authUser = ref.watch(CurrentUserAccountProvider).value!.$id;
  final userDetails = ref.watch(UserDetailProvider(authUser));
  return userDetails.value;
});

final UserDetailProvider = FutureProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

final class Authcotroller extends StateNotifier<bool> {
  final AuthApi _authApi;
  final UserAPI _userApi;

  Authcotroller({required AuthApi authApi, required UserAPI userAPI})
      : _authApi = authApi,
        _userApi = userAPI,
        super(false);

  Future<model.User?> currentuser() => _authApi.CurrentUserAccount();

  void signUp({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authApi.signUp(email: email, password: password);
    state = false;
    res.fold((l) => showSnackBar(context, l.Message), (r) async {
      UserModel userModel = UserModel(
          person_found: false,
          profilePic: '',
          bannerPic: '',
          email: email,
          name: getNamefromEmail(email),
          uid: r.$id,
          bio: '');
      final result = await _userApi.SaveUserData(userModel);
      result.fold((l) => showSnackBar(context, l.Message), (r) {
        showSnackBar(context, 'Account Has Been Successfully Created');
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Login_view()));
      });
    });
  }

  void SignIn({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authApi.Login(email: email, password: password);
    state = false;
    res.fold((l) => showSnackBar(context, l.Message), (r) {
      showSnackBar(context, 'Successfully Logged In');
      Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
    });
  }

  Future<UserModel> getUserData(String uid) async {
    final document = await _userApi.getUserData(uid);

    final userUpdated = UserModel.fromMap(document.data);
    return userUpdated;
  }

  void logout(BuildContext context) async {
    final res = await _authApi.logout();
    res.fold((l) => null, (r) {
      Navigator.pushAndRemoveUntil(context, Sign_up.route(), (route) => false);
    });
  }
}
