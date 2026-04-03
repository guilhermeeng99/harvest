import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  const CategoryEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.sortOrder,
  });

  final String id;
  final String name;
  final String imageUrl;
  final int sortOrder;

  @override
  List<Object?> get props => [id, name, imageUrl, sortOrder];
}
