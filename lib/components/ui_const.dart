import 'package:findmychild/post/post_list.dart';
import 'package:flutter/material.dart';

import '../screens/expolore.dart';
import '../screens/getNotification.dart';

class UIConstant {
  static List<Widget> bottomTabBarPages = [
    const TweetList(),
    const Discover(),
    const NotificationView(),
  ];
}
