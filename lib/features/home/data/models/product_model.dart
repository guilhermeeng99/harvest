import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:harvest/features/home/domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.unit,
    required super.categoryId,
    required super.imageUrl,
    required super.farmName,
    super.isFeatured,
    super.isOrganic,
    super.stock,
    super.nutritionFacts,
  });

  factory ProductModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return ProductModel(
      id: doc.id,
      name: data['name'] as String,
      description: data['description'] as String? ?? '',
      price: (data['price'] as num).toDouble(),
      unit: data['unit'] as String? ?? 'kg',
      categoryId: data['categoryId'] as String,
      imageUrl: data['imageUrl'] as String? ?? '',
      farmName: data['farmName'] as String? ?? '',
      isFeatured: data['isFeatured'] as bool? ?? false,
      isOrganic: data['isOrganic'] as bool? ?? false,
      stock: data['stock'] as int? ?? 0,
      nutritionFacts: data['nutritionFacts'] != null
          ? _parseNutritionFacts(
              data['nutritionFacts'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  static NutritionFacts _parseNutritionFacts(Map<String, dynamic> data) {
    return NutritionFacts(
      calories: data['calories'] as String?,
      protein: data['protein'] as String?,
      fiber: data['fiber'] as String?,
      vitamins: data['vitamins'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() => {
        'name': name,
        'description': description,
        'price': price,
        'unit': unit,
        'categoryId': categoryId,
        'imageUrl': imageUrl,
        'farmName': farmName,
        'isFeatured': isFeatured,
        'isOrganic': isOrganic,
        'stock': stock,
        if (nutritionFacts != null)
          'nutritionFacts': {
            'calories': nutritionFacts!.calories,
            'protein': nutritionFacts!.protein,
            'fiber': nutritionFacts!.fiber,
            'vitamins': nutritionFacts!.vitamins,
          },
      };
}
