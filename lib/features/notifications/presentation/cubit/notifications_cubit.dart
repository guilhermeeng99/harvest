import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harvest/features/notifications/domain/entities/notification_entity.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(const NotificationsState());

  void loadNotifications() {
    emit(state.copyWith(status: NotificationsStatus.loading));

    final now = DateTime.now();
    final mockNotifications = [
      NotificationEntity(
        id: '1',
        title: 'Welcome to Harvest!',
        body:
            'Start exploring fresh produce from local farms '
            'delivered to your door.',
        createdAt: now.subtract(const Duration(minutes: 30)),
        isRead: false,
      ),
      NotificationEntity(
        id: '2',
        title: 'Weekend Special',
        body:
            'Get 20% off on all organic fruits this weekend. '
            'Use code FRESH20.',
        createdAt: now.subtract(const Duration(hours: 2)),
        isRead: false,
      ),
      NotificationEntity(
        id: '3',
        title: 'New Farms Added',
        body:
            'We just partnered with 5 new local farms. '
            'Check out their fresh produce!',
        createdAt: now.subtract(const Duration(hours: 8)),
        isRead: true,
      ),
      NotificationEntity(
        id: '4',
        title: 'Free Delivery',
        body:
            r'Orders above $30 get free delivery this week. '
            "Don't miss out!",
        createdAt: now.subtract(const Duration(days: 1)),
        isRead: true,
      ),
      NotificationEntity(
        id: '5',
        title: 'Seasonal Produce',
        body:
            'Spring vegetables are now available! '
            'Fresh asparagus, peas, and more.',
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
