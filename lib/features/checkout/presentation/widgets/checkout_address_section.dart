import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:harvest/app/routes/app_routes.dart';
import 'package:harvest/app/theme/app_colors.dart';
import 'package:harvest/app/theme/app_typography.dart';
import 'package:harvest/app/widgets/harvest_button.dart';
import 'package:harvest/features/address/presentation/cubit/address_cubit.dart';
import 'package:harvest/gen/i18n/strings.g.dart';

class CheckoutAddressSection extends StatelessWidget {
  const CheckoutAddressSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddressCubit, AddressState>(
      builder: (context, state) {
        if (state.status == AddressStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        final address = state.selectedAddress;

        if (address == null) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.divider),
            ),
            child: Column(
              children: [
                const FaIcon(
                  FontAwesomeIcons.locationDot,
                  size: 32,
                  color: AppColors.onBackgroundLight,
                ),
                const SizedBox(height: 12),
                Text(
                  t.checkout.noAddress,
                  style: AppTypography.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  t.checkout.noAddressSubtitle,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.onBackgroundLight,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                HarvestButton(
                  label: t.checkout.addAddress,
                  onPressed: () => context.push(AppRoutes.addressAdd),
                ),
              ],
            ),
          );
        }

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.divider),
          ),
          child: Row(
            children: [
              const FaIcon(
                FontAwesomeIcons.locationDot,
                size: 20,
                color: AppColors.primary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (address.label != null)
                      Text(address.label!, style: AppTypography.titleMedium),
                    Text(
                      address.shortAddress,
                      style: AppTypography.bodyMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${address.city}, ${address.state} - ${address.zipCode}',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.onBackgroundLight,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () => context.push(AppRoutes.addresses),
                child: Text(
                  t.checkout.changeAddress,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
