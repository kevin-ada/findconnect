import 'package:findmychild/components/error.dart';
import 'package:findmychild/components/loading_page.dart';
import 'package:findmychild/controller/auth_controller.dart';
import 'package:findmychild/controller/user_profile_controller.dart';
import 'package:findmychild/data/user_model.dart';
import 'package:findmychild/screens/edit_profile_view.dart';
import 'package:findmychild/screens/postcard.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class Profile extends ConsumerWidget {
  final UserModel user;
  const Profile({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(CurrentUserDetailProvider).value;
    final user = ref.watch(CurrentUserDetailProvider).value;
    return user == null
        ? const Loader()
        : Container(
            color: const Color(0xff2B2730),
            child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxisScrolled) {
                  return [
                    SliverAppBar(
                      backgroundColor: const Color(0xff2B2730),
                      floating: true,
                      expandedHeight: 150,
                      snap: true,
                      flexibleSpace: Stack(
                        children: [
                          Positioned.fill(
                              child: user.bannerPic.isEmpty
                                  ? Container(
                                      color: Colors.black12,
                                    )
                                  : Image.network(
                                      user.bannerPic,
                                      fit: BoxFit.fitWidth,
                                    )),
                          Positioned(
                            bottom: 0,
                            left: 15,
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(user.profilePic),
                              radius: 45,
                            ),
                          ),
                          Container(
                            alignment: Alignment.bottomRight,
                            margin: const EdgeInsets.all(20),
                            child: GestureDetector(
                              onTap: () {
                                if (currentUser?.uid == user.uid) {
                                  Navigator.push(
                                      context, EditProfileView.route());
                                }
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 45,
                                width: 125,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: const Color(0xffE966A0),
                                ),
                                child: const Text(
                                  "Edit Profile",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.all(10),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            Text(
                              user.name,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '@${user.name}',
                              style: const TextStyle(
                                  fontSize: 13, color: Colors.white),
                            ),
                            Text(
                              user.bio,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Divider(
                              thickness: 1.0,
                              color: Colors.black,
                            )
                          ],
                        ),
                      ),
                    )
                  ];
                },
                body: ref.watch(getUserTweetsProvider(user.uid)).when(
                    data: (tweets) {
                      return ListView.builder(
                          itemCount: tweets.length,
                          itemBuilder: (BuildContext context, int index) {
                            final tweet = tweets[index];
                            return TweetCard(tweet: tweet);
                          });
                    },
                    error: (err, st) => Errorpage(error: err.toString()),
                    loading: () => const Loader())),
          );
  }
}
