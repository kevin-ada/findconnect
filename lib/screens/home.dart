import 'package:findmychild/components/side_drawer.dart';
import 'package:findmychild/components/ui_const.dart';
import 'package:findmychild/post/create_post.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _page = 0;

  void onPageChange(int index) {
    setState(() {
      _page = index;
    });
  }

  onCreateTweet() {
    Navigator.push(context, CreatePost.route());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff2B2730),
      appBar: _page == 0
          ? AppBar(
              elevation: 0,
              backgroundColor: const Color(0xff2B2730),
              centerTitle: true,
              title: Text(
                "Find",
                style: TextStyle(color: Colors.grey.shade800, fontSize: 24),
              ),
            )
          : null,
      body: IndexedStack(index: _page, children: UIConstant.bottomTabBarPages),
      floatingActionButton: FloatingActionButton(
        onPressed: onCreateTweet,
        backgroundColor: const Color(0xffE966A0),
        child: const Icon(Icons.pending),
      ),
      drawer: const SideDrawer(),
      bottomNavigationBar: Container(
        color: const Color(0xff2B2730),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GNav(
            selectedIndex: _page,
            onTabChange: onPageChange,
            gap: 6,
            color: Colors.white,
            activeColor: const Color(0xff6554AF),
            tabBackgroundColor: const Color(0xff9575DE),
            padding: const EdgeInsets.all(16),
            tabs: const [
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.search,
                text: 'Discover',
              ),
              GButton(
                icon: Icons.notification_important,
                text: 'Alert',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
