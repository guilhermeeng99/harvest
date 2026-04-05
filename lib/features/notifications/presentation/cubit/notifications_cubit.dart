import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harvest/features/notifications/data/datasources/notifications_local_datasource.dart';
import 'package:harvest/features/notifications/domain/entities/notification_entity.dart';
import 'package:harvest/gen/i18n/strings.g.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit({required NotificationsLocalDataSource localDataSource})
    : _localDataSource = localDataSource,
      super(const NotificationsState());

  final NotificationsLocalDataSource _localDataSource;

  void loadNotifications() {
    emit(state.copyWith(status: NotificationsStatus.loading));

    final readIds = _localDataSource.loadReadIds();
    final now = DateTime.now();
    final mockNotifications = [
      NotificationEntity(
        id: '1',
        title: t.notifications.welcomeTitle,
        body: t.notifications.welcomeBody,
        createdAt: now.subtract(const Duration(minutes: 30)),
        isRead: readIds.contains('1'),
      ),
      NotificationEntity(
        id: '2',
        title: t.notifications.weekendSpecialTitle,
        body: t.notifications.weekendSpecialBody,
        createdAt: now.subtract(const Duration(hours: 2)),
        isRead: readIds.contains('2'),
      ),
      NotificationEntity(
        id: '3',
        title: t.notifications.newFarmsTitle,
        body: t.notifications.newFarmsBody,
        createdAt: now.subtract(const Duration(hours: 8)),
        isRead: readIds.contains('3'),
      ),
      NotificationEntity(
        id: '4',
        title: t.notifications.freeDeliveryTitle,
        body: t.notifications.freeDeliveryBody,
        createdAt: now.subtract(const Duration(days: 1)),
        isRead: readIds.contains('4'),
      ),
      NotificationEntity(
        id: '5',
        title: t.notifications.seasonalProduceTitle,
        body: t.notifications.seasonalProduceBody,
        createdAt: now.subtract(const Duration(days: 2)),
        isRead: readIds.contains('5'),
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
    _persistReadIds(updated);
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
    _persistReadIds(updated);
  }

  void _persistReadIds(List<NotificationEntity> notifications) {
    final readIds = notifications
        .where((n) => n.isRead)
        .map((n) => n.id)
        .toSet();
    unawaited(_localDataSource.saveReadIds(readIds));
  }
}
