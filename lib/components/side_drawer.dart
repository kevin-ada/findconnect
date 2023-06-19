import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/auth_controller.dart';
import '../screens/profile.dart';
import 'loading_page.dart';

class SideDrawer extends ConsumerWidget {
  const SideDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(CurrentUserDetailProvider).value;
    if (currentUser == null) {
      return const Loader();
    }
    return SafeArea(
        child: Drawer(
      backgroundColor: const Color(0xFF2B2730),
      child: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          ListTile(
            leading: const Icon(
              color: Colors.white,
              Icons.person,
              size: 20,
            ),
            title: const Text(
              "My Profile",
              style: TextStyle(color: Colors.white, fontSize: 22),
            ),
            onTap: () {
              Navigator.push(context, UserProfile.route(currentUser));
            },
          ),
          const SizedBox(height: 50),
          const SizedBox(
            height: 50,
          ),
          ListTile(
            leading: const Icon(
              color: Colors.white,
              Icons.people_alt_outlined,
              size: 20,
            ),
            title: const Text(
              "Communities-Beta",
              style: TextStyle(color: Colors.white, fontSize: 22),
            ),
            onTap: () {},
          ),
          const SizedBox(
            height: 50,
          ),
          ListTile(
            leading: const Icon(
              color: Colors.white,
              Icons.login_outlined,
              size: 20,
            ),
            title: const Text(
              "Logout",
              style: TextStyle(color: Colors.white, fontSize: 22),
            ),
            onTap: () {
              ref.read(authControllerProvider.notifier).logout(context);
            },
          )
        ],
      ),
    ));
  }
}
