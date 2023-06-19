import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/user_api.dart';
import '../data/user_model.dart';

final exploreControllerProvider = StateNotifierProvider((ref) {
  return ExploreNotifier(userAPI: ref.watch(UserApiProvider));
});

final searchUserProvider = FutureProvider.family((ref, String name) async {
  final exploreController = ref.watch(exploreControllerProvider.notifier);
  return exploreController.SearchUser(name);
});

class ExploreNotifier extends StateNotifier<bool> {
  final UserAPI _userApi;
  ExploreNotifier({required UserAPI userAPI})
      : _userApi = userAPI,
        super(false);

  Future<List<UserModel>> SearchUser(String name) async {
    final users = await _userApi.SearchUser(name);
    return users.map((e) => UserModel.fromMap(e.data)).toList();
  }
}
