import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../authentication/const.dart';
import '../components/error.dart';
import '../components/loading_page.dart';
import '../controller/post_controller.dart';
import '../data/postModel.dart';
import '../screens/postcard.dart';

class TweetList extends ConsumerWidget {
  const TweetList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getTweetsProvider).when(
        data: (tweets) {
          return ref.watch(getLatestTweetProvider).when(
              data: (data) {
                if (data.events.contains(
                    'databases.*.${AppwriteConsts.database}.collections.${AppwriteConsts.tweetscollection}.documents.*.create')) {
                  tweets.insert(0, Tweet.fromMap(data.payload));
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
        loading: () => const Loader());
  }
}
