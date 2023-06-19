import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/notification.dart';
import '../data/notification_Model.dart';
import '../enum/notification_enum.dart';

final notificationControllerProvider =
    StateNotifierProvider<NotificationController, bool>((ref) {
  return NotificationController(
      notificationApi: ref.watch(notificationAPIProvider));
});

final getLatestNotificationProvider = StreamProvider((ref) {
  final notificationApi = ref.watch(notificationAPIProvider);
  return notificationApi.getLatestNotifications();
});

final getNotificationsProvider = FutureProvider.family((ref, String uid) async {
  final notificationCotroller =
      ref.watch(notificationControllerProvider.notifier);
  return notificationCotroller.getNotifications(uid);
});

class NotificationController extends StateNotifier<bool> {
  final NotificationApi _notificationApi;
  NotificationController({required NotificationApi notificationApi})
      : _notificationApi = notificationApi,
        super(false);

  void createNotification({
    required String text,
    required String postId,
    required NotificationType notificationType,
    required String uid,
  }) async {
    final notification = Notification(
        text: text,
        postId: postId,
        id: '',
        uid: uid,
        notificationType: notificationType);
    final res = await _notificationApi.createNotification(notification);
    res.fold((l) => null, (r) => null);
  }

  Future<List<Notification>> getNotifications(String uid) async {
    final notifications = await _notificationApi.getNotifications(uid);
    return notifications.map((e) => Notification.fromMap(e.data)).toList();
  }
}
