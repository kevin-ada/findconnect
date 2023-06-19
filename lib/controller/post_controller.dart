import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/post_api.dart';
import '../api/storage_api.dart';
import '../core/utils.dart';
import '../data/postModel.dart';
import '../data/user_model.dart';
import '../enum/enum_publish.dart';
import '../enum/notification_enum.dart';
import 'auth_controller.dart';
import 'notificationContoller.dart';

final tweetControllerProvider =
    StateNotifierProvider<TweetController, bool>((ref) {
  return TweetController(
      notificationController:
          ref.watch(notificationControllerProvider.notifier),
      storageApi: ref.watch(StorageApiProvider),
      ref: ref,
      tweetApi: ref.watch(tweetApiProvider));
});

final getTweetsProvider = FutureProvider((ref) async {
  final tweetcontroller = ref.watch(tweetControllerProvider.notifier);
  return tweetcontroller.getTweets();
});

final getRepliesToTweetProvider =
    FutureProvider.family((ref, Tweet tweet) async {
  final tweetcontroller = ref.watch(tweetControllerProvider.notifier);
  return tweetcontroller.getRepliestoTweet(tweet);
});

final getTweetsByHashtagProvider =
    FutureProvider.family((ref, String hashtag) async {
  final tweetcontroller = ref.watch(tweetControllerProvider.notifier);
  return tweetcontroller.getTweetsByHashtag(hashtag);
});

final getTweetById = FutureProvider.family((ref, String id) async {
  final tweetcontroller = ref.watch(tweetControllerProvider.notifier);
  return tweetcontroller.getTweetbyID(id);
});

final getLatestTweetProvider = StreamProvider((ref) {
  final tweetApi = ref.watch(tweetApiProvider);
  return tweetApi.getLatestTweet();
});

class TweetController extends StateNotifier<bool> {
  final NotificationController _notificationController;
  final StorageApi _storageApi;
  final TweetApi _tweetApi;
  final Ref _ref;

  TweetController(
      {required Ref ref,
      required NotificationController notificationController,
      required TweetApi tweetApi,
      required StorageApi storageApi})
      : _ref = ref,
        _tweetApi = tweetApi,
        _storageApi = storageApi,
        _notificationController = notificationController,
        super(false);

  Future<List<Tweet>> getTweets() async {
    final tweetlist = await _tweetApi.getTweets();
    return tweetlist.map((tweet) => Tweet.fromMap(tweet.data)).toList();
  }

  Future<List<Tweet>> getRepliestoTweet(Tweet tweet) async {
    final document = await _tweetApi.getReplies(tweet);
    return document.map((tweet) => Tweet.fromMap(tweet.data)).toList();
  }

  Future<List<Tweet>> getTweetsByHashtag(String hashtag) async {
    final document = await _tweetApi.getTweetsByHashtag(hashtag);
    return document.map((tweet) => Tweet.fromMap(tweet.data)).toList();
  }

  Future<Tweet> getTweetbyID(String id) async {
    final tweet = await _tweetApi.getTweetbyId(id);
    return Tweet.fromMap(tweet.data);
  }

  void likeTweet(Tweet tweet, UserModel user) async {
    List<String> likes = tweet.likes;

    if (tweet.likes.contains(user.uid)) {
      likes.remove(user.uid);
    } else {
      likes.add(user.uid);
    }
    tweet = tweet.copyWith(likes: likes);
    final res = await _tweetApi.likeTweet(tweet);
    res.fold((l) => null, (r) {
      _notificationController.createNotification(
          text: '${user.name} Appreciates Your Post',
          postId: tweet.id,
          notificationType: NotificationType.like,
          uid: tweet.uid);
    });
  }

  void shareTweet(
      {required List<File> images,
      required String text,
      required BuildContext context,
      required String repliedTo}) {
    if (text.isEmpty) {
      showSnackBar(context, 'Please Enter Text');
      return;
    }

    if (images.isNotEmpty) {
      _shareImageTweet(
          images: images, text: text, context: context, repliedTo: repliedTo);
    } else {
      _shareTextTweet(text: text, context: context, repliedTo: repliedTo);
    }
  }

  void _shareImageTweet(
      {required List<File> images,
      required String text,
      required BuildContext context,
      required String repliedTo}) async {
    state = true;
    final hashtags = _gethashtagfromText(text);
    String link = _getLinkfromTweet(text);
    final user = _ref.read(CurrentUserDetailProvider).value!;
    final imagelink = await _storageApi.uploadImage(images);
    Tweet tweet = Tweet(
        text: text,
        hashtags: hashtags,
        link: link,
        imageLinks: imagelink,
        uid: user.uid,
        tweetType: TweetType.image,
        tweetedAt: DateTime.now(),
        likes: const [],
        commentIds: const [],
        id: '',
        reshareCount: 0,
        repliedTo: repliedTo);
    final res = await _tweetApi.ShareTweet(tweet);
    state = false;
    res.fold((l) => showSnackBar(context, l.Message), (r) => null);
  }

  void _shareTextTweet(
      {required String text,
      required BuildContext context,
      required String repliedTo}) async {
    state = true;
    final hashtags = _gethashtagfromText(text);
    String link = _getLinkfromTweet(text);
    final user = _ref.read(CurrentUserDetailProvider).value!;
    Tweet tweet = Tweet(
        text: text,
        hashtags: hashtags,
        link: link,
        imageLinks: const [],
        uid: user.uid,
        tweetType: TweetType.text,
        tweetedAt: DateTime.now(),
        likes: const [],
        commentIds: const [],
        id: '',
        reshareCount: 0,
        repliedTo: repliedTo);
    final res = await _tweetApi.ShareTweet(tweet);
    state = false;
    res.fold((l) => showSnackBar(context, l.Message), (r) => null);
  }

  String _getLinkfromTweet(String text) {
    List<String> wordsInSentence = text.split(' ');
    String link = '';
    for (String word in wordsInSentence) {
      if (word.startsWith('https://') || word.startsWith('www.')) {
        link = word;
      }
    }
    return link;
  }

  List<String> _gethashtagfromText(String text) {
    List<String> wordsInSentence = text.split(' ');
    List<String> hashtag = [];
    for (String word in wordsInSentence) {
      if (word.startsWith('#')) {
        hashtag.add(word);
      }
    }
    return hashtag;
  }
}
