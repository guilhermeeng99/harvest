import 'dart:async';

import 'package:flutter/material.dart';
import 'package:harvest/app/di/injection_container.dart';
import 'package:harvest/features/admin/domain/repositories/admin_repository.dart';
import 'package:harvest/features/home/domain/entities/category_entity.dart';
import 'package:harvest/features/home/domain/entities/product_entity.dart';

class AdminProductFormController extends ChangeNotifier {
  AdminProductFormController({this.productId}) {
    unawaited(_loadData());
  }

  final String? productId;

  final formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final unitCtrl = TextEditingController(text: 'kg');
  final farmCtrl = TextEditingController();
  final stockCtrl = TextEditingController(text: '0');
  final caloriesCtrl = TextEditingController();
  final proteinCtrl = TextEditingController();
  final fiberCtrl = TextEditingController();
  final vitaminsCtrl = TextEditingController();
  final imageUrlCtrl = TextEditingController();

  String? categoryId;
  bool isFeatured = false;
  bool isOrganic = false;
  String get imageUrl => imageUrlCtrl.text.trim();
  bool loading = false;
  String? errorMessage;

  List<CategoryEntity> categories = [];
  ProductEntity? _existingProduct;

  AdminRepository get _repo => sl<AdminRepository>();

  bool get isEditing => productId != null;

  void refreshPreview() => notifyListeners();

  Future<void> _loadData() async {
    loading = true;
    notifyListeners();

    final catResult = await _repo.getCategories();
    catResult.fold((_) {}, (cats) => categories = cats);

    if (isEditing) {
      final prodResult = await _repo.getProducts();
      prodResult.fold((_) {}, (products) {
        final found = products.where((p) => p.id == productId);
        if (found.isNotEmpty) {
          _existingProduct = found.first;
          _populateFields(_existingProduct!);
        }
      });
    }

    loading = false;
    notifyListeners();
  }

  void _populateFields(ProductEntity p) {
    nameCtrl.text = p.name;
    descCtrl.text = p.description;
    priceCtrl.text = p.price.toString();
    unitCtrl.text = p.unit;
    farmCtrl.text = p.farmName;
    stockCtrl.text = p.stock.toString();
    categoryId = p.categoryId;
    isFeatured = p.isFeatured;
    isOrganic = p.isOrganic;
    imageUrlCtrl.text = p.imageUrl;
    caloriesCtrl.text = p.nutritionFacts?.calories ?? '';
    proteinCtrl.text = p.nutritionFacts?.protein ?? '';
    fiberCtrl.text = p.nutritionFacts?.fiber ?? '';
    vitaminsCtrl.text = p.nutritionFacts?.vitamins ?? '';
  }

  void setCategoryId(String? value) {
    categoryId = value;
    notifyListeners();
  }

  void setFeatured({required bool value}) {
    isFeatured = value;
    notifyListeners();
  }

  void setOrganic({required bool value}) {
    isOrganic = value;
    notifyListeners();
  }

  Future<bool> submit() async {
    if (!formKey.currentState!.validate()) return false;
    if (categoryId == null) {
      errorMessage = 'Please select a category';
      notifyListeners();
      return false;
    }

    loading = true;
    errorMessage = null;
    notifyListeners();

    final finalImageUrl = imageUrl;

    final hasNutrition =
        caloriesCtrl.text.isNotEmpty ||
        proteinCtrl.text.isNotEmpty ||
        fiberCtrl.text.isNotEmpty ||
        vitaminsCtrl.text.isNotEmpty;

    final product = ProductEntity(
      id: _existingProduct?.id ?? '',
      name: nameCtrl.text.trim(),
      description: descCtrl.text.trim(),
      price: double.tryParse(priceCtrl.text) ?? 0,
      unit: unitCtrl.text.trim(),
      categoryId: categoryId!,
      imageUrl: finalImageUrl,
      farmName: farmCtrl.text.trim(),
      isFeatured: isFeatured,
      isOrganic: isOrganic,
      stock: int.tryParse(stockCtrl.text) ?? 0,
      nutritionFacts: hasNutrition
          ? NutritionFacts(
              calories: caloriesCtrl.text.trim().isNotEmpty
                  ? caloriesCtrl.text.trim()
                  : null,
              protein: proteinCtrl.text.trim().isNotEmpty
                  ? proteinCtrl.text.trim()
                  : null,
              fiber: fiberCtrl.text.trim().isNotEmpty
                  ? fiberCtrl.text.trim()
                  : null,
              vitamins: vitaminsCtrl.text.trim().isNotEmpty
                  ? vitaminsCtrl.text.trim()
                  : null,
            )
          : null,
    );

    final result = isEditing
        ? await _repo.updateProduct(product)
        : await _repo.addProduct(product);

    loading = false;

    return result.fold(
      (f) {
        errorMessage = f.message;
        notifyListeners();
        return false;
      },
      (_) {
        notifyListeners();
        return true;
      },
    );
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    descCtrl.dispose();
    priceCtrl.dispose();
    unitCtrl.dispose();
    farmCtrl.dispose();
    stockCtrl.dispose();
    caloriesCtrl.dispose();
    proteinCtrl.dispose();
    fiberCtrl.dispose();
    vitaminsCtrl.dispose();
    imageUrlCtrl.dispose();
    super.dispose();
  }
}
