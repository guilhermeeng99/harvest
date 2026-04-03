part of 'notifications_cubit.dart';

enum NotificationsStatus { initial, loading, loaded }

class NotificationsState extends Equatable {
  const NotificationsState({
    this.status = NotificationsStatus.initial,
    this.notifications = const [],
  });

  final NotificationsStatus status;
  final List<NotificationEntity> notifications;

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  NotificationsState copyWith({
    NotificationsStatus? status,
    List<NotificationEntity>? notifications,
  }) {
    return NotificationsState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
    );
  }

  @override
  List<Object?> get props => [status, notifications];
}
