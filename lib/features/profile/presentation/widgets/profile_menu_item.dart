import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:harvest/app/theme/app_colors.dart';
import 'package:harvest/app/theme/app_typography.dart';

class ProfileMenuItem extends StatelessWidget {
  const ProfileMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
    super.key,
  });

  final Widget icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? AppColors.error : AppColors.onBackground;
    return ListTile(
      leading: icon,
      title: Text(label, style: AppTypography.bodyLarge.copyWith(color: color)),
      trailing: isDestructive
          ? null
          : const FaIcon(
              FontAwesomeIcons.chevronRight,
              color: AppColors.onBackgroundLight,
              size: 16,
            ),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }
}
