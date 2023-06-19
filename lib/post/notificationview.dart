
import 'package:findconnect/data/notification_Model.dart' as model;
import 'package:findconnect/enum/notification_enum.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NotificationTile extends StatelessWidget {
  final model.Notification notification;
  const NotificationTile({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: notification.notificationType == NotificationType.like
          ? const FaIcon(FontAwesomeIcons.handsClapping, color: Colors.white)
          : null,
      title: Text(
        notification.text,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
