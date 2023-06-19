import 'package:any_link_preview/any_link_preview.dart';
import 'package:findconnect/screens/profile.dart';
import 'package:findconnect/screens/reply_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:like_button/like_button.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../components/carousel.dart';
import '../components/error.dart';
import '../components/hashtags.dart';
import '../components/loading_page.dart';
import '../controller/auth_controller.dart';
import '../controller/post_controller.dart';
import '../data/postModel.dart';
import '../enum/enum_publish.dart';
import 'Posticons.dart';

class TweetCard extends ConsumerWidget {
  final Tweet tweet;

  const TweetCard({super.key, required this.tweet});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(CurrentUserDetailProvider).value;
    return currentUser == null
        ? const Loader()
        : ref.watch(UserDetailProvider(tweet.uid)).when(
            data: (user) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(context, ReplyScreen.route(tweet));
                },
                child: Container(
                  color: const Color(0xff2B2730),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context, UserProfile.route(user));
                            },
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              child: CircleAvatar(
                                radius: 25,
                                backgroundImage: NetworkImage(user.profilePic),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(right: 5),
                                      child: Text(
                                        user.name,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 19,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Text(
                                      '@${user.name} . ${timeago.format(tweet.tweetedAt, locale: 'en_short')}',
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.white),
                                    ),
                                  ],
                                ),
                                if (tweet.repliedTo.isNotEmpty)
                                  ref.watch(getTweetById(tweet.repliedTo)).when(
                                      data: (repliedToData) {
                                        final replytoUser = ref
                                            .watch(UserDetailProvider(
                                                repliedToData.uid))
                                            .value;
                                        return RichText(
                                          text: TextSpan(
                                              text: 'Replying To',
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white),
                                              children: [
                                                TextSpan(
                                                  text: '@${replytoUser?.name}',
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white),
                                                )
                                              ]),
                                        );
                                      },
                                      error: (error, stackTrace) => Errorpage(
                                            error: error.toString(),
                                          ),
                                      loading: () => const Loader()),
                                HashtagText(text: tweet.text),
                                if (tweet.tweetType == TweetType.image)
                                  CarouselImage(imageLinks: tweet.imageLinks),
                                if (tweet.link.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  AnyLinkPreview(
                                      displayDirection:
                                          UIDirection.uiDirectionHorizontal,
                                      link: 'https://${tweet.link}'),
                                ],
                                Container(
                                  margin:
                                      const EdgeInsets.only(top: 10, right: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TweetIconButton(
                                          path: Icons.comment,
                                          text: {tweet.commentIds.length}
                                              .toString(),
                                          onTap: () {}),
                                      LikeButton(
                                          onTap: (isliked) async {
                                            ref
                                                .read(tweetControllerProvider
                                                    .notifier)
                                                .likeTweet(tweet, currentUser);
                                            return !isliked;
                                          },
                                          isLiked: tweet.likes
                                              .contains(currentUser.uid),
                                          size: 25,
                                          likeBuilder: (isliked) {
                                            return isliked
                                                ? const FaIcon(
                                                    FontAwesomeIcons
                                                        .handsClapping,
                                                    color: Color(0xffE966A0),
                                                  )
                                                : const FaIcon(
                                                    FontAwesomeIcons
                                                        .handsClapping,
                                                    color: Colors.white,
                                                  );
                                          },
                                          likeCount: tweet.likes.length,
                                          countBuilder:
                                              (likeCount, isliked, text) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 2.0),
                                              child: Text(
                                                text,
                                                style: TextStyle(
                                                    color: isliked
                                                        ? Colors.white
                                                        : Colors.white,
                                                    fontSize: 16),
                                              ),
                                            );
                                          }),
                                      IconButton(
                                        onPressed: () {},
                                        icon: const Icon(Icons.share),
                                        color: Colors.white,
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 1),
                              ],
                            ),
                          )
                        ],
                      ),
                      Divider(
                        color: Colors.grey.shade500,
                      )
                    ],
                  ),
                ),
              );
            },
            error: (error, stackTrace) => Errorpage(
                  error: error.toString(),
                ),
            loading: () => const Loader());
  }
}
