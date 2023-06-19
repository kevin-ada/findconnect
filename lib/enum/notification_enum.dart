enum NotificationType {
  like('like'),
  reply('reply');

  final String type;

  const NotificationType(this.type);
}

extension convertTweet on String {
  NotificationType toNotificationtypeEnum() {
    switch (this) {
      case 'like':
        return NotificationType.like;
      case 'reply':
        return NotificationType.reply;
      default:
        return NotificationType.like;
    }
  }
}
