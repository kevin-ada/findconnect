import 'dart:io';
import 'package:findmychild/controller/auth_controller.dart';
import 'package:findmychild/controller/user_profile_controller.dart';
import 'package:findmychild/core/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../components/loading_page.dart';

class EditProfileView extends ConsumerStatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const EditProfileView());

  const EditProfileView({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditProfileViewState();
}

class _EditProfileViewState extends ConsumerState<EditProfileView> {
  TextEditingController? nameController;
  TextEditingController? bioController;
  File? bannerFile;
  File? profileFile;

  void selectBannerImage() async {
    final banner = await pickImage();
    if (banner != null) {
      setState(() {
        bannerFile = banner;
      });
    }
  }

  void selectProfileImage() async {
    final profileImage = await pickImage();
    if (profileImage != null) {
      setState(() {
        profileFile = profileImage;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    nameController = TextEditingController(
        text: ref.read(CurrentUserDetailProvider).value?.name ?? '');
    bioController = TextEditingController(
        text: ref.read(CurrentUserDetailProvider).value?.bio ?? '');
    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isloading = ref.watch(userProfileControllerProvider);
    final user = ref.watch(CurrentUserDetailProvider).value;
    return Scaffold(
      backgroundColor: const Color(0xFF2B2730),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B2730),
        title: const Text("Edit Profile"),
        actions: [
          TextButton(
              onPressed: () {
                ref
                    .read(userProfileControllerProvider.notifier)
                    .updateUserProfile(
                        usermodel: user!.copyWith(
                            bio: bioController?.text ?? '',
                            name: nameController?.text ?? ''),
                        context: context,
                        bannerFile: bannerFile,
                        profileFile: profileFile);
              },
              child: const Text(
                "Save",
                style: TextStyle(color: Colors.white, fontSize: 14),
              ))
        ],
      ),
      body: isloading || user == null
          ? const Loader()
          : Column(children: [
              SizedBox(
                height: 200,
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: selectBannerImage,
                      child: Container(
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16)),
                        child: Positioned.fill(
                            child: bannerFile != null
                                ? Image.file(bannerFile!)
                                : user.bannerPic.isEmpty
                                    ? Container(
                                        color: Colors.black12,
                                      )
                                    : Image.network(
                                        user.bannerPic,
                                        fit: BoxFit.fitWidth,
                                      )),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 15,
                      child: GestureDetector(
                        onTap: selectProfileImage,
                        child: profileFile != null
                            ? CircleAvatar(
                                backgroundImage: FileImage(profileFile!),
                                radius: 37,
                              )
                            : CircleAvatar(
                                backgroundImage: NetworkImage(user.profilePic),
                                radius: 37,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18),
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: nameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'Enter a name',
                    hintStyle: const TextStyle(fontSize: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    filled: true,
                    contentPadding: const EdgeInsets.all(16),
                    fillColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "This Details will be displayed on your account",
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.all(15),
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: bioController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'Enter your Bio',
                    hintStyle: const TextStyle(fontSize: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    filled: true,
                    contentPadding: const EdgeInsets.all(16),
                    fillColor: Colors.white,
                  ),
                  maxLines: 4,
                ),
              ),
            ]),
    );
  }
}
