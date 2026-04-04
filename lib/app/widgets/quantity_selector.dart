import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:harvest/app/theme/app_colors.dart';
import 'package:harvest/app/theme/app_typography.dart';

class QuantitySelector extends StatelessWidget {
  const QuantitySelector({
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    this.min = 1,
    this.max = 99,
    super.key,
  });

  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final int min;
  final int max;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _QuantityButton(
            icon: const FaIcon(FontAwesomeIcons.minus, size: 14),
            onPressed: quantity > min ? onDecrement : null,
          ),
          SizedBox(
            width: 40,
            child: Text(
              '$quantity',
              style: AppTypography.titleMedium,
              textAlign: TextAlign.center,
            ),
          ),
          _QuantityButton(
            icon: const FaIcon(FontAwesomeIcons.plus, size: 14),
            onPressed: quantity < max ? onIncrement : null,
          ),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({
    required this.icon,
    required this.onPressed,
  });

  final Widget icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      width: 36,
      child: IconButton(
        onPressed: onPressed,
        icon: icon,
        padding: EdgeInsets.zero,
        color: onPressed != null
            ? AppColors.primary
            : AppColors.onBackgroundLight,
      ),
    );
  }
}
