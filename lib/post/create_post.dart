import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../components/loading_page.dart';
import '../controller/auth_controller.dart';
import '../controller/post_controller.dart';
import '../core/utils.dart';

class CreatePost extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const CreatePost());

  const CreatePost({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreatePostState();
}

class _CreatePostState extends ConsumerState<CreatePost> {
  final tweetTextController = TextEditingController();
  List<File> images = [];

  @override
  void dispose() {
    super.dispose();
    tweetTextController.dispose();
  }

  void onPickImages() async {
    images = await pickImages();
    setState(() {});
  }

  void shareTweet() {
    ref.watch(tweetControllerProvider.notifier).shareTweet(
        images: images,
        text: tweetTextController.text,
        context: context,
        repliedTo: '');
    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(tweetControllerProvider);
    final currentUser = ref.watch(CurrentUserDetailProvider).value;
    return Scaffold(
      backgroundColor: const Color(0xFF2B2730),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF2B2730),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.close_rounded,
            size: 30,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: shareTweet,
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.all(10),
              height: 30,
              width: 70,
              decoration: BoxDecoration(
                  color: const Color(0xff9575DE),
                  borderRadius: BorderRadius.circular(16)),
              child: const Text("Share"),
            ),
          )
        ],
      ),
      body: isLoading || currentUser == null
          ? const LoadingPage()
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 45,
                          backgroundImage: NetworkImage(currentUser.profilePic),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: TextField(
                            controller: tweetTextController,
                            style: const TextStyle(
                                fontSize: 20, color: Colors.white),
                            decoration: const InputDecoration(
                                hintText: 'Share Your Story',
                                hintStyle: TextStyle(color: Colors.white),
                                border: InputBorder.none),
                            maxLines: null,
                          ),
                        ),
                      ],
                    ),
                    if (images.isNotEmpty)
                      CarouselSlider(
                        items: images.map(
                          (file) {
                            return Container(
                                width: MediaQuery.of(context).size.width,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: Image.file(file));
                          },
                        ).toList(),
                        options: CarouselOptions(
                            height: 400, enableInfiniteScroll: false),
                      ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey.shade400),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0).copyWith(left: 15, right: 15),
              child: GestureDetector(
                  onTap: onPickImages, child: const Icon(Icons.photo)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0).copyWith(left: 15, right: 15),
              child: const Icon(Icons.gif_box_outlined),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0).copyWith(left: 15, right: 15),
              child: const Icon(Icons.emoji_emotions_outlined),
            ),
          ],
        ),
      ),
    );
  }
}
