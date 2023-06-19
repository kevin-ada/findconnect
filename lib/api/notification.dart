import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:findmychild/authentication/const.dart';
import 'package:findmychild/core/core.dart';
import 'package:findmychild/core/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../data/notification_Model.dart';

final notificationAPIProvider = Provider((ref) {
  return NotificationApi(
      realtime: ref.watch(appwriteRealtimeProvider),
      db: ref.watch(appwriteDatabaseProvider));
});

abstract class InotificationAPI {
  FutureEitherVoid createNotification(Notification notification);
  Future<List<Document>> getNotifications(String uid);
  Stream<RealtimeMessage> getLatestNotifications();
}

class NotificationApi implements InotificationAPI {
  final Realtime _realtime;
  final Databases _db;
  NotificationApi({required Databases db, required Realtime realtime})
      : _realtime = realtime,
        _db = db;
  @override
  FutureEitherVoid createNotification(Notification notification) async {
    try {
      await _db.createDocument(
          databaseId: AppwriteConsts.database,
          collectionId: AppwriteConsts.notficationsCollection,
          documentId: ID.unique(),
          data: notification.toMap());
      return right(null);
    } on AppwriteException catch (e, st) {
      return left(Failure(e.message ?? 'Unexpected Error Occurred', st));
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  Stream<RealtimeMessage> getLatestNotifications() {
    return _realtime.subscribe([
      'databases.${AppwriteConsts.database}.collections.${AppwriteConsts.notficationsCollection}.documents'
    ]).stream;
  }

  @override
  Future<List<Document>> getNotifications(String uid) async {
    final documents = await _db.listDocuments(
        databaseId: AppwriteConsts.database,
        collectionId: AppwriteConsts.notficationsCollection,
        queries: [Query.equal('uid', uid)]);
    return documents.documents;
  }
}
