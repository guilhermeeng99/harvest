import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:harvest/app/di/injection_container.dart';
import 'package:harvest/features/admin/domain/repositories/admin_repository.dart';
import 'package:harvest/features/home/domain/entities/category_entity.dart';
import 'package:image_picker/image_picker.dart';

class AdminCategoryFormController extends ChangeNotifier {
  AdminCategoryFormController({this.categoryId}) {
    if (isEditing) unawaited(_loadCategory());
  }

  final String? categoryId;

  final formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final sortCtrl = TextEditingController(text: '0');

  String imageUrl = '';
  Uint8List? imageBytes;
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
        imageUrl = _existing!.imageUrl;
      }
    });

    loading = false;
    notifyListeners();
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 400,
    );
    if (file == null) return;
    final bytes = await file.readAsBytes();
    imageBytes = bytes;
    notifyListeners();
  }

  Future<bool> submit() async {
    if (!formKey.currentState!.validate()) return false;

    loading = true;
    errorMessage = null;
    notifyListeners();

    var finalImageUrl = imageUrl;
    if (imageBytes != null) {
      final fileName = 'category_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final result = await _repo.uploadImage(imageBytes!, fileName);
      final failed = result.fold<bool>(
        (f) {
          errorMessage = f.message;
          loading = false;
          notifyListeners();
          return true;
        },
        (url) {
          finalImageUrl = url;
          return false;
        },
      );
      if (failed) return false;
    }

    final category = CategoryEntity(
      id: _existing?.id ?? '',
      name: nameCtrl.text.trim(),
      imageUrl: finalImageUrl,
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
    super.dispose();
  }
}
