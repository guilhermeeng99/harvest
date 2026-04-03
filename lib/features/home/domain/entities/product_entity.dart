import 'package:equatable/equatable.dart';

class NutritionFacts extends Equatable {
  const NutritionFacts({
    this.calories,
    this.protein,
    this.fiber,
    this.vitamins,
  });

  final String? calories;
  final String? protein;
  final String? fiber;
  final String? vitamins;

  @override
  List<Object?> get props => [calories, protein, fiber, vitamins];
}

class ProductEntity extends Equatable {
  const ProductEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.unit,
    required this.categoryId,
    required this.imageUrl,
    required this.farmName,
    this.isFeatured = false,
    this.isOrganic = false,
    this.stock = 0,
    this.nutritionFacts,
  });

  final String id;
  final String name;
  final String description;
  final double price;
  final String unit;
  final String categoryId;
  final String imageUrl;
  final String farmName;
  final bool isFeatured;
  final bool isOrganic;
  final int stock;
  final NutritionFacts? nutritionFacts;

  bool get inStock => stock > 0;

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        price,
        unit,
        categoryId,
        imageUrl,
        farmName,
        isFeatured,
        isOrganic,
        stock,
        nutritionFacts,
      ];
}
