import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:harvest/app/routes/app_routes.dart';
import 'package:harvest/app/theme/app_colors.dart';
import 'package:harvest/app/theme/app_typography.dart';
import 'package:harvest/app/widgets/harvest_button.dart';
import 'package:harvest/gen/i18n/strings.g.dart';

class EmptyCart extends StatelessWidget {
  const EmptyCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const FaIcon(
              FontAwesomeIcons.bagShopping,
              size: 64,
              color: AppColors.onBackgroundLight,
            ),
            const SizedBox(height: 16),
            Text(
              t.cart.empty,
              style: AppTypography.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              t.cart.emptySubtitle,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.onBackgroundLight,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            HarvestButton(
              label: t.cart.browseProducts,
              onPressed: () => context.go(AppRoutes.home),
            ),
          ],
        ),
      ),
    );
  }
}
