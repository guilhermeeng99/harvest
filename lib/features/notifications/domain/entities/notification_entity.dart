import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  const NotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.isRead,
    this.imageUrl,
  });

  final String id;
  final String title;
  final String body;
  final String? imageUrl;
  final DateTime createdAt;
  final bool isRead;

  @override
  List<Object?> get props => [id, title, body, imageUrl, createdAt, isRead];
}
