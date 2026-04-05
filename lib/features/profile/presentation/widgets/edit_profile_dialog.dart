import 'package:flutter/material.dart';
import 'package:harvest/app/theme/app_colors.dart';
import 'package:harvest/app/theme/app_typography.dart';
import 'package:harvest/app/widgets/harvest_button.dart';
import 'package:harvest/app/widgets/harvest_text_field.dart';
import 'package:harvest/gen/i18n/strings.g.dart';

class EditProfileDialog extends StatefulWidget {
  const EditProfileDialog({
    required this.currentName,
    required this.onSave,
    this.currentPhotoUrl,
    super.key,
  });

  final String currentName;
  final Future<bool> Function(String name) onSave;
  final String? currentPhotoUrl;

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  late final TextEditingController _nameController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    if (name.isEmpty || _isSaving) return;

    setState(() => _isSaving = true);

    final success = await widget.onSave(name);

    if (!mounted) return;

    if (success) {
      Navigator.pop(context);
    } else {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(t.profile.editProfile, style: AppTypography.titleLarge),
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 48,
              backgroundColor: AppColors.primaryLight.withValues(
                alpha: 0.2,
              ),
              backgroundImage: widget.currentPhotoUrl != null
                  ? NetworkImage(widget.currentPhotoUrl!)
                  : null,
              child: widget.currentPhotoUrl == null
                  ? Text(
                      widget.currentName.isNotEmpty
                          ? widget.currentName[0].toUpperCase()
                          : '?',
                      style: AppTypography.headlineMedium.copyWith(
                        color: AppColors.primary,
                      ),
                    )
                  : null,
            ),
            const SizedBox(height: 20),
            HarvestTextField(
              controller: _nameController,
              label: t.auth.name,
              hint: t.auth.nameHint,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(t.general.cancel),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: HarvestButton(
                    label: t.general.save,
                    isLoading: _isSaving,
                    onPressed: _submit,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
