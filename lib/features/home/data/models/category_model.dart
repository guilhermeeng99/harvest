import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:harvest/features/home/domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.id,
    required super.name,
    required super.imageUrl,
    required super.sortOrder,
  });

  factory CategoryModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return CategoryModel(
      id: doc.id,
      name: data['name'] as String,
      imageUrl: data['imageUrl'] as String,
      sortOrder: data['sortOrder'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() => {
        'name': name,
        'imageUrl': imageUrl,
        'sortOrder': sortOrder,
      };
}
