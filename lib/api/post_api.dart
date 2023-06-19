import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../authentication/const.dart';
import '../core/failure.dart';
import '../core/providers.dart';
import '../core/type_def.dart';
import '../data/postModel.dart';

final tweetApiProvider = Provider((ref) {
  return TweetApi(
      realtime: ref.watch(appwriteRealtimeProvider),
      db: ref.watch(appwriteDatabaseProvider));
});

abstract class ITweetAPI {
  FutureEither<Document> ShareTweet(Tweet tweet);
  Future<List<Document>> getTweets();
  Stream<RealtimeMessage> getLatestTweet();
  FutureEither<Document> likeTweet(Tweet tweet);
  FutureEither<Document> resharecount(Tweet tweet);
  Future<List<Document>> getReplies(Tweet tweet);
  Future<Document> getTweetbyId(String id);
  Future<List<Document>> getUserTweets(String uid);
  Future<List<Document>> getTweetsByHashtag(String uid);
}

class TweetApi implements ITweetAPI {
  final Databases _db;
  final Realtime _realtime;
  TweetApi({required Databases db, required Realtime realtime})
      : _db = db,
        _realtime = realtime;
  @override
  FutureEither<Document> ShareTweet(Tweet tweet) async {
    try {
      final document = await _db.createDocument(
          databaseId: AppwriteConsts.database,
          collectionId: AppwriteConsts.tweetscollection,
          documentId: ID.unique(),
          data: tweet.toMap());
      return right(document);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(e.message ?? 'An Unexpected Error Occurred', st),
      );
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  Future<List<Document>> getTweets() async {
    final documents = await _db.listDocuments(
        databaseId: AppwriteConsts.database,
        collectionId: AppwriteConsts.tweetscollection,
        queries: [Query.orderDesc('tweetedAt')]);
    return documents.documents;
  }

  @override
  Stream<RealtimeMessage> getLatestTweet() {
    return _realtime.subscribe([
      'databases.${AppwriteConsts.database}.collections.${AppwriteConsts.tweetscollection}.documents'
    ]).stream;
  }

  @override
  FutureEither<Document> likeTweet(Tweet tweet) async {
    try {
      final document = await _db.updateDocument(
          databaseId: AppwriteConsts.database,
          collectionId: AppwriteConsts.tweetscollection,
          documentId: tweet.id,
          data: {'likes': tweet.likes});
      return right(document);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(e.message ?? 'An Unexpected Error Occurred', st),
      );
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  FutureEither<Document> resharecount(Tweet tweet) async {
    try {
      final document = await _db.updateDocument(
          databaseId: AppwriteConsts.database,
          collectionId: AppwriteConsts.tweetscollection,
          documentId: tweet.id,
          data: {'reshareCount': tweet.reshareCount});
      return right(document);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(e.message ?? 'An Unexpected Error Occurred', st),
      );
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  Future<List<Document>> getReplies(Tweet tweet) async {
    final document = await _db.listDocuments(
        databaseId: AppwriteConsts.database,
        collectionId: AppwriteConsts.tweetscollection,
        queries: [Query.equal('repliedTo', tweet.id)]);
    return document.documents;
  }

  @override
  Future<Document> getTweetbyId(String id) async {
    return _db.getDocument(
        databaseId: AppwriteConsts.database,
        collectionId: AppwriteConsts.tweetscollection,
        documentId: id);
  }

  @override
  Future<List<Document>> getUserTweets(String uid) async {
    final documents = await _db.listDocuments(
        databaseId: AppwriteConsts.database,
        collectionId: AppwriteConsts.tweetscollection,
        queries: [Query.equal('uid', uid)]);
    return documents.documents;
  }

  @override
  Future<List<Document>> getTweetsByHashtag(String hashtag) async {
    final documents = await _db.listDocuments(
        databaseId: AppwriteConsts.database,
        collectionId: AppwriteConsts.tweetscollection,
        queries: [Query.search('hashtags', hashtag)]);
    return documents.documents;
  }
}
