import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controller/post_controller.dart';
import '../screens/postcard.dart';
import 'error.dart';
import 'loading_page.dart';

class HashtagView extends ConsumerWidget {
  static route(String hashtag) =>
      MaterialPageRoute(builder: (context) => HashtagView(hashtag: hashtag));
  final String hashtag;
  const HashtagView({
    required this.hashtag,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(hashtag),
      ),
      body: ref.watch(getTweetsByHashtagProvider(hashtag)).when(
            data: (tweets) {
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
            loading: () => const Loader(),
          ),
    );
  }
}
