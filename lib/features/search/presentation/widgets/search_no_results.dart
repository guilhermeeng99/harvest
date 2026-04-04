import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:harvest/app/theme/app_colors.dart';
import 'package:harvest/app/theme/app_typography.dart';
import 'package:harvest/gen/i18n/strings.g.dart';

class SearchNoResults extends StatelessWidget {
  const SearchNoResults({required this.onBack, super.key});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const FaIcon(
            FontAwesomeIcons.magnifyingGlass,
            size: 56,
            color: AppColors.onBackgroundLight,
          ),
          const SizedBox(height: 16),
          Text(
            t.general.noResults,
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.onBackgroundLight,
            ),
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: onBack,
            icon: const FaIcon(FontAwesomeIcons.arrowLeft, size: 16),
            label: Text(t.search.browseCategories),
          ),
        ],
      ),
    );
  }
}
