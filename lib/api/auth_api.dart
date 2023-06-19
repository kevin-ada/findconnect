import 'package:appwrite/models.dart' as model;
import 'package:appwrite/appwrite.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../core/failure.dart';
import '../core/providers.dart';
import '../core/type_def.dart';

final AuthApiProvider = Provider((ref) {
  final account = AppwriteAccountProvider;

  return AuthApi(account: ref.watch(account));
});

abstract class IAuthAPI {
  FutureEither<model.User> signUp({
    required String email,
    required String password,
  });
  FutureEither<model.Session> Login({
    required String email,
    required String password,
  });
  Future<model.User?> CurrentUserAccount();
  FutureEitherVoid logout();
}

class AuthApi implements IAuthAPI {
  final Account _account;

  AuthApi({required Account account}) : _account = account;

  @override
  Future<model.User?> CurrentUserAccount() async {
    try {
      return await _account.get();
    } on AppwriteException catch (e) {
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  FutureEither<model.User> signUp(
      {required String email, required String password}) async {
    try {
      final account = await _account.create(
          userId: ID.unique(), email: email, password: password);
      return right(account);
    } on AppwriteException catch (e, stackTrace) {
      return left(
          Failure(e.message ?? 'An Unexpected Error Occurred', stackTrace));
    } catch (e, stackTrace) {
      return left(Failure(e.toString(), stackTrace));
    }
  }

  @override
  FutureEither<model.Session> Login(
      {required String email, required String password}) async {
    try {
      final session =
          await _account.createEmailSession(email: email, password: password);
      return right(session);
    } on AppwriteException catch (e, stackTrace) {
      return left(
          Failure(e.message ?? 'An Unexpected error Occurred', stackTrace));
    } catch (e, stackTrace) {
      return left(Failure(e.toString(), stackTrace));
    }
  }

  @override
  FutureEitherVoid logout() async {
    try {
      final session = await _account.deleteSession(sessionId: 'current');
      return right(null);
    } on AppwriteException catch (e, stackTrace) {
      return left(
          Failure(e.message ?? 'An Unexpected error Occurred', stackTrace));
    } catch (e, stackTrace) {
      return left(Failure(e.toString(), stackTrace));
    }
  }
}
