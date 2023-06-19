import 'package:appwrite/models.dart' as models;
import 'package:appwrite/appwrite.dart';
import 'package:findmychild/authentication/const.dart';
import 'package:findmychild/core/core.dart';
import 'package:findmychild/core/providers.dart';
import 'package:findmychild/data/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final UserApiProvider = Provider((ref) {
  return UserAPI(
    db: ref.watch(appwriteDatabaseProvider),
    realtime: ref.watch(appwriteRealtimeProvider),
  );
});

abstract class IUSERAPI {
  FutureEitherVoid SaveUserData(UserModel userModel);
  Future<models.Document> getUserData(String uid);
  Future<List<models.Document>> SearchUser(String name);
  FutureEitherVoid updateUserModel(UserModel userModel);
  Stream<RealtimeMessage> getlatestUserProfileData();
}

class UserAPI implements IUSERAPI {
  final Databases _db;
  final Realtime _realtime;
  UserAPI({required Databases db, required Realtime realtime})
      : _db = db,
        _realtime = realtime;

  @override
  FutureEitherVoid SaveUserData(UserModel userModel) async {
    try {
      await _db.createDocument(
          databaseId: AppwriteConsts.database,
          collectionId: AppwriteConsts.collection,
          documentId: userModel.uid,
          data: userModel.toMap());
      return right(null);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(e.message ?? 'An Unexpected Error Occurred', st),
      );
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  Future<models.Document> getUserData(String uid) {
    return _db.getDocument(
        databaseId: AppwriteConsts.database,
        collectionId: AppwriteConsts.collection,
        documentId: uid);
  }

  @override
  Future<List<models.Document>> SearchUser(String name) async {
    final document = await _db.listDocuments(
        databaseId: AppwriteConsts.database,
        collectionId: AppwriteConsts.collection,
        queries: [
          Query.search('name', name),
        ]);
    return document.documents;
  }

  @override
  FutureEitherVoid updateUserModel(UserModel userModel) async {
    try {
      await _db.updateDocument(
          databaseId: AppwriteConsts.database,
          collectionId: AppwriteConsts.collection,
          documentId: userModel.uid,
          data: userModel.toMap());
      return right(null);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(e.message ?? 'An Unexpected Error Occurred', st),
      );
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  Stream<RealtimeMessage> getlatestUserProfileData() {
    return _realtime.subscribe([
      'databases.${AppwriteConsts.database}.collections.${AppwriteConsts.collection}.documents'
    ]).stream;
  }
}
