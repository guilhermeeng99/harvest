import 'dart:async';

import 'package:flutter/material.dart';
import 'package:harvest/app/di/injection_container.dart';
import 'package:harvest/features/admin/domain/repositories/admin_repository.dart';
import 'package:harvest/features/home/domain/entities/category_entity.dart';

class AdminCategoryFormController extends ChangeNotifier {
  AdminCategoryFormController({this.categoryId}) {
    if (isEditing) unawaited(_loadCategory());
  }

  final String? categoryId;

  final formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final sortCtrl = TextEditingController(text: '0');
  final imageUrlCtrl = TextEditingController();

  String get imageUrl => imageUrlCtrl.text.trim();
  bool loading = false;
  String? errorMessage;
  CategoryEntity? _existing;

  AdminRepository get _repo => sl<AdminRepository>();

  bool get isEditing => categoryId != null;

  Future<void> _loadCategory() async {
    loading = true;
    notifyListeners();

    final result = await _repo.getCategories();
    result.fold((_) {}, (cats) {
      final found = cats.where((c) => c.id == categoryId);
      if (found.isNotEmpty) {
        _existing = found.first;
        nameCtrl.text = _existing!.name;
        sortCtrl.text = _existing!.sortOrder.toString();
        imageUrlCtrl.text = _existing!.imageUrl;
      }
    });

    loading = false;
    notifyListeners();
  }

  Future<bool> submit() async {
    if (!formKey.currentState!.validate()) return false;

    loading = true;
    errorMessage = null;
    notifyListeners();

    final category = CategoryEntity(
      id: _existing?.id ?? '',
      name: nameCtrl.text.trim(),
      imageUrl: imageUrl,
      sortOrder: int.tryParse(sortCtrl.text) ?? 0,
    );

    final result = isEditing
        ? await _repo.updateCategory(category)
        : await _repo.addCategory(category);

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
    sortCtrl.dispose();
    imageUrlCtrl.dispose();
    super.dispose();
  }
}
