import 'package:flutter/material.dart';

class HarvestTextField extends StatelessWidget {
  const HarvestTextField({
    required this.controller,
    this.label,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.textInputAction,
    this.maxLines = 1,
    this.enabled = true,
    super.key,
  });

  final TextEditingController controller;
  final String? label;
  final String? hint;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final TextInputAction? textInputAction;
  final int maxLines;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      textInputAction: textInputAction,
      maxLines: maxLines,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon != null
            ? Padding(
                padding: const EdgeInsetsDirectional.only(start: 16, end: 8),
                child: IconTheme.merge(
                  data: const IconThemeData(size: 18),
                  child: prefixIcon!,
                ),
              )
            : null,
        prefixIconConstraints: prefixIcon != null
            ? const BoxConstraints()
            : null,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
