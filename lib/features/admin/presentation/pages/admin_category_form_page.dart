import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:harvest/features/admin/presentation/controllers/admin_category_form_controller.dart';
import 'package:harvest/features/admin/presentation/widgets/admin_form_section.dart';
import 'package:harvest/features/admin/presentation/widgets/admin_image_picker.dart';
import 'package:harvest/gen/i18n/strings.g.dart';

class AdminCategoryFormPage extends StatefulWidget {
  const AdminCategoryFormPage({this.categoryId, super.key});

  final String? categoryId;

  @override
  State<AdminCategoryFormPage> createState() => _AdminCategoryFormPageState();
}

class _AdminCategoryFormPageState extends State<AdminCategoryFormPage> {
  late final AdminCategoryFormController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AdminCategoryFormController(categoryId: widget.categoryId);
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
    if (success && mounted) context.pop(true);
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
        title: Text(_ctrl.isEditing ? i18n.editCategory : i18n.addCategory),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _ctrl.loading ? null : _onSubmit,
        icon: FaIcon(
          _ctrl.isEditing ? FontAwesomeIcons.floppyDisk : FontAwesomeIcons.plus,
          size: 20,
        ),
        label: Text(_ctrl.isEditing ? i18n.save : i18n.addCategory),
      ),
      body: _ctrl.loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Form(
                    key: _ctrl.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AdminFormSection(
                          icon: FaIcon(
                            FontAwesomeIcons.tag,
                            size: 18,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          title: i18n.categories,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                controller: _ctrl.imageUrlCtrl,
                                decoration: InputDecoration(
                                  labelText: i18n.image,
                                  hintText: 'https://...',
                                ),
                                onChanged: (_) => setState(() {}),
                              ),
                              const SizedBox(height: 12),
                              AdminImagePicker(
                                imageUrl: _ctrl.imageUrl,
                                height: 180,
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _ctrl.nameCtrl,
                                decoration: InputDecoration(
                                  labelText: i18n.categoryName,
                                ),
                                validator: (v) => v == null || v.isEmpty
                                    ? t.general.required
                                    : null,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
