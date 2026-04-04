import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harvest/features/notifications/domain/entities/notification_entity.dart';
import 'package:harvest/gen/i18n/strings.g.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(const NotificationsState());

  void loadNotifications() {
    emit(state.copyWith(status: NotificationsStatus.loading));

    final now = DateTime.now();
    final mockNotifications = [
      NotificationEntity(
        id: '1',
        title: t.notifications.welcomeTitle,
        body: t.notifications.welcomeBody,
        createdAt: now.subtract(const Duration(minutes: 30)),
        isRead: false,
      ),
      NotificationEntity(
        id: '2',
        title: t.notifications.weekendSpecialTitle,
        body: t.notifications.weekendSpecialBody,
        createdAt: now.subtract(const Duration(hours: 2)),
        isRead: false,
      ),
      NotificationEntity(
        id: '3',
        title: t.notifications.newFarmsTitle,
        body: t.notifications.newFarmsBody,
        createdAt: now.subtract(const Duration(hours: 8)),
        isRead: true,
      ),
      NotificationEntity(
        id: '4',
        title: t.notifications.freeDeliveryTitle,
        body: t.notifications.freeDeliveryBody,
        createdAt: now.subtract(const Duration(days: 1)),
        isRead: true,
      ),
      NotificationEntity(
        id: '5',
        title: t.notifications.seasonalProduceTitle,
        body: t.notifications.seasonalProduceBody,
        createdAt: now.subtract(const Duration(days: 2)),
        isRead: true,
      ),
    ];

    emit(
      state.copyWith(
        status: NotificationsStatus.loaded,
        notifications: mockNotifications,
      ),
    );
  }

  void markAsRead(String id) {
    final updated = state.notifications.map((n) {
      if (n.id == id) {
        return NotificationEntity(
          id: n.id,
          title: n.title,
          body: n.body,
          imageUrl: n.imageUrl,
          createdAt: n.createdAt,
          isRead: true,
        );
      }
      return n;
    }).toList();

    emit(state.copyWith(notifications: updated));
  }

  void markAllAsRead() {
    final updated = state.notifications
        .map(
          (n) => NotificationEntity(
            id: n.id,
            title: n.title,
            body: n.body,
            imageUrl: n.imageUrl,
            createdAt: n.createdAt,
            isRead: true,
          ),
        )
        .toList();

    emit(state.copyWith(notifications: updated));
  }
}
