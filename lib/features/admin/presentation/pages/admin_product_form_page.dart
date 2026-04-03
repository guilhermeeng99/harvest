import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:harvest/features/admin/presentation/controllers/admin_product_form_controller.dart';
import 'package:harvest/features/admin/presentation/widgets/admin_form_section.dart';
import 'package:harvest/features/admin/presentation/widgets/admin_image_picker.dart';
import 'package:harvest/gen/i18n/strings.g.dart';

class AdminProductFormPage extends StatefulWidget {
  const AdminProductFormPage({this.productId, super.key});

  final String? productId;

  @override
  State<AdminProductFormPage> createState() => _AdminProductFormPageState();
}

class _AdminProductFormPageState extends State<AdminProductFormPage> {
  late final AdminProductFormController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AdminProductFormController(productId: widget.productId);
    _ctrl.addListener(_onStateChanged);
  }

  void _onStateChanged() {
    if (mounted) setState(() {});
    if (_ctrl.errorMessage != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_ctrl.errorMessage!)));
      _ctrl.errorMessage = null;
    }
  }

  Future<void> _onSubmit() async {
    final success = await _ctrl.submit();
    if (success && mounted) context.pop();
  }

  @override
  void dispose() {
    _ctrl
      ..removeListener(_onStateChanged)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final i18n = t.admin;
    return Scaffold(
      appBar: AppBar(
        title: Text(_ctrl.isEditing ? i18n.editProduct : i18n.addProduct),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _ctrl.loading ? null : _onSubmit,
        icon: Icon(_ctrl.isEditing ? Icons.save : Icons.add),
        label: Text(_ctrl.isEditing ? i18n.save : i18n.addProduct),
      ),
      body: _ctrl.loading
          ? const Center(child: CircularProgressIndicator())
          : LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 800;
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1000),
                      child: Form(
                        key: _ctrl.formKey,
                        child: isWide
                            ? _WideLayout(ctrl: _ctrl)
                            : _NarrowLayout(ctrl: _ctrl),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class _WideLayout extends StatelessWidget {
  const _WideLayout({required this.ctrl});

  final AdminProductFormController ctrl;

  @override
  Widget build(BuildContext context) {
    final i18n = t.admin;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  AdminFormSection(
                    icon: Icons.image_outlined,
                    title: 'Image',
                    child: AdminImagePicker(
                      imageUrl: ctrl.imageUrl,
                      imageBytes: ctrl.imageBytes,
                      onTap: ctrl.pickImage,
                    ),
                  ),
                  const SizedBox(height: 16),
                  AdminFormSection(
                    icon: Icons.info_outline,
                    title: i18n.productName,
                    child: _BasicInfoFields(ctrl: ctrl),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  AdminFormSection(
                    icon: Icons.attach_money,
                    title: i18n.productPrice,
                    child: _PricingFields(ctrl: ctrl),
                  ),
                  const SizedBox(height: 16),
                  AdminFormSection(
                    icon: Icons.category_outlined,
                    title: i18n.productCategory,
                    child: _ClassificationFields(ctrl: ctrl),
                  ),
                  const SizedBox(height: 16),
                  AdminFormSection(
                    icon: Icons.restaurant_menu,
                    title: i18n.nutritionFacts,
                    child: _NutritionFields(ctrl: ctrl),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 80),
      ],
    );
  }
}

class _NarrowLayout extends StatelessWidget {
  const _NarrowLayout({required this.ctrl});

  final AdminProductFormController ctrl;

  @override
  Widget build(BuildContext context) {
    final i18n = t.admin;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AdminImagePicker(
          imageUrl: ctrl.imageUrl,
          imageBytes: ctrl.imageBytes,
          onTap: ctrl.pickImage,
        ),
        const SizedBox(height: 16),
        _BasicInfoFields(ctrl: ctrl),
        const SizedBox(height: 12),
        _PricingFields(ctrl: ctrl),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          initialValue: ctrl.categoryId,
          decoration: InputDecoration(labelText: i18n.productCategory),
          items: ctrl.categories
              .map((c) => DropdownMenuItem(value: c.id, child: Text(c.name)))
              .toList(),
          onChanged: ctrl.setCategoryId,
        ),
        const SizedBox(height: 12),
        SwitchListTile(
          title: Text(i18n.productFeatured),
          value: ctrl.isFeatured,
          onChanged: (v) => ctrl.setFeatured(value: v),
        ),
        SwitchListTile(
          title: Text(i18n.productOrganic),
          value: ctrl.isOrganic,
          onChanged: (v) => ctrl.setOrganic(value: v),
        ),
        const SizedBox(height: 16),
        Text(
          i18n.nutritionFacts,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        _NutritionFields(ctrl: ctrl),
        const SizedBox(height: 80),
      ],
    );
  }
}

class _BasicInfoFields extends StatelessWidget {
  const _BasicInfoFields({required this.ctrl});

  final AdminProductFormController ctrl;

  @override
  Widget build(BuildContext context) {
    final i18n = t.admin;
    return Column(
      children: [
        TextFormField(
          controller: ctrl.nameCtrl,
          decoration: InputDecoration(labelText: i18n.productName),
          validator: (v) => v == null || v.isEmpty ? t.general.required : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: ctrl.descCtrl,
          decoration: InputDecoration(labelText: i18n.productDescription),
          maxLines: 4,
        ),
      ],
    );
  }
}

class _PricingFields extends StatelessWidget {
  const _PricingFields({required this.ctrl});

  final AdminProductFormController ctrl;

  @override
  Widget build(BuildContext context) {
    final i18n = t.admin;
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: ctrl.priceCtrl,
                decoration: InputDecoration(
                  labelText: i18n.productPrice,
                  prefixText: r'R$ ',
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
                ],
                validator: (v) =>
                    v == null || v.isEmpty ? t.general.required : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: ctrl.unitCtrl,
                decoration: InputDecoration(labelText: i18n.productUnit),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: ctrl.stockCtrl,
                decoration: InputDecoration(labelText: i18n.productStock),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: ctrl.farmCtrl,
                decoration: InputDecoration(labelText: i18n.productFarm),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ClassificationFields extends StatelessWidget {
  const _ClassificationFields({required this.ctrl});

  final AdminProductFormController ctrl;

  @override
  Widget build(BuildContext context) {
    final i18n = t.admin;
    return Column(
      children: [
        DropdownButtonFormField<String>(
          initialValue: ctrl.categoryId,
          decoration: InputDecoration(labelText: i18n.productCategory),
          items: ctrl.categories
              .map((c) => DropdownMenuItem(value: c.id, child: Text(c.name)))
              .toList(),
          onChanged: ctrl.setCategoryId,
        ),
        const SizedBox(height: 8),
        SwitchListTile(
          title: Text(i18n.productFeatured),
          value: ctrl.isFeatured,
          onChanged: (v) => ctrl.setFeatured(value: v),
          contentPadding: EdgeInsets.zero,
        ),
        SwitchListTile(
          title: Text(i18n.productOrganic),
          value: ctrl.isOrganic,
          onChanged: (v) => ctrl.setOrganic(value: v),
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }
}

class _NutritionFields extends StatelessWidget {
  const _NutritionFields({required this.ctrl});

  final AdminProductFormController ctrl;

  @override
  Widget build(BuildContext context) {
    final i18n = t.admin;
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: ctrl.caloriesCtrl,
                decoration: InputDecoration(labelText: i18n.calories),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: ctrl.proteinCtrl,
                decoration: InputDecoration(labelText: i18n.protein),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: ctrl.fiberCtrl,
                decoration: InputDecoration(labelText: i18n.fiber),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: ctrl.vitaminsCtrl,
                decoration: InputDecoration(labelText: i18n.vitamins),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
