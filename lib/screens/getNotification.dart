import 'package:findconnect/data/notification_Model.dart' as model;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../authentication/const.dart';
import '../components/error.dart';
import '../components/loading_page.dart';
import '../controller/auth_controller.dart';
import '../controller/notificationContoller.dart';
import '../post/notificationview.dart';

class NotificationView extends ConsumerWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(CurrentUserDetailProvider).value;

    return Scaffold(
      backgroundColor: const Color(0xFF2B2730),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: const Color(0xFF2B2730),
        title: const Text('Notifications'),
      ),
      body: currentUser == null
          ? const Loader()
          : ref.watch(getNotificationsProvider(currentUser.uid)).when(
                data: (notifications) {
                  return ref.watch(getLatestNotificationProvider).when(
                        data: (data) {
                          if (data.events.contains(
                            'databases.*.collections.${AppwriteConsts.notficationsCollection}.documents.*.create',
                          )) {
                            final latestNotif =
                                model.Notification.fromMap(data.payload);
                            if (latestNotif.uid == currentUser.uid) {
                              notifications.insert(0, latestNotif);
                            }
                          }

                          return ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: notifications.length,
                            itemBuilder: (BuildContext context, int index) {
                              final notification = notifications[index];
                              return NotificationTile(
                                  notification: notification);
                            },
                          );
                        },
                        error: (error, stackTrace) => Errorpage(
                          error: error.toString(),
                        ),
                        loading: () {
                          return ListView.builder(
                            itemCount: notifications.length,
                            itemBuilder: (BuildContext context, int index) {
                              final notification = notifications[index];
                              return NotificationTile(
                                  notification: notification);
                            },
                          );
                        },
                      );
                },
                error: (error, stackTrace) => Errorpage(
                  error: error.toString(),
                ),
                loading: () => const Loader(),
              ),
    );
  }
}
