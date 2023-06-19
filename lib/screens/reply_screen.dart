import 'package:findconnect/screens/postcard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../authentication/const.dart';
import '../components/error.dart';
import '../components/loading_page.dart';
import '../controller/post_controller.dart';
import '../data/postModel.dart';

class ReplyScreen extends ConsumerWidget {
  static route(Tweet tweet) =>
      MaterialPageRoute(builder: (context) => ReplyScreen(tweet: tweet));

  final Tweet tweet;

  const ReplyScreen({super.key, required this.tweet});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xff2B2730),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Post'),
        backgroundColor: const Color(0xff2B2730),
      ),
      body: Column(
        children: [
          TweetCard(tweet: tweet),
          ref.watch(getRepliesToTweetProvider(tweet)).when(
              data: (tweets) {
                return ref.watch(getLatestTweetProvider).when(
                    data: (data) {
                      bool isTweetPresent = false;
                      final latest_tweet = Tweet.fromMap(data.payload);
                      for (final tweetModel in tweets) {
                        if (tweetModel.id == latest_tweet.id) {
                          isTweetPresent = true;
                          break;
                        }
                      }
                      if (!isTweetPresent &&
                          latest_tweet.repliedTo == latest_tweet.id) {
                        if (data.events.contains(
                            'databases.*.${AppwriteConsts.database}.collections.${AppwriteConsts.tweetscollection}.documents.*.create')) {
                          tweets.insert(0, Tweet.fromMap(data.payload));
                        }
                      }
                      return ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: tweets.length,
                          itemBuilder: (BuildContext context, int index) {
                            final tweet = tweets[index];
                            return TweetCard(tweet: tweet);
                          });
                    },
                    error: (error, stackTrace) => Errorpage(
                          error: error.toString(),
                        ),
                    loading: () {
                      return ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: tweets.length,
                          itemBuilder: (BuildContext context, int index) {
                            final tweet = tweets[index];
                            return TweetCard(tweet: tweet);
                          });
                    });
              },
              error: (error, stackTrace) => Errorpage(
                    error: error.toString(),
                  ),
              loading: () => const Loader())
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          style: TextStyle(color: Colors.white),
          onSubmitted: (value) {
            ref.read(tweetControllerProvider.notifier).shareTweet(
                images: [], text: value, context: context, repliedTo: tweet.id);
          },
          decoration: const InputDecoration(
              hintStyle: TextStyle(color: Colors.white),
              hintText: 'Reply to The Post'),
        ),
      ),
    );
  }
}
