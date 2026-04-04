import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:harvest/app/routes/app_routes.dart';
import 'package:harvest/app/theme/app_colors.dart';
import 'package:harvest/app/theme/app_typography.dart';
import 'package:harvest/features/address/presentation/cubit/address_cubit.dart';
import 'package:harvest/gen/i18n/strings.g.dart';

class AddressSelectionPage extends StatelessWidget {
  const AddressSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(t.address.title), centerTitle: true),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.addressAdd),
        backgroundColor: AppColors.primary,
        child: const FaIcon(
          FontAwesomeIcons.plus,
          color: AppColors.onPrimary,
          size: 20,
        ),
      ),
      body: BlocBuilder<AddressCubit, AddressState>(
        builder: (context, state) {
          if (state.status == AddressStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.addresses.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FaIcon(
                    FontAwesomeIcons.mapPin,
                    size: 56,
                    color: AppColors.onBackgroundLight.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(t.address.empty, style: AppTypography.titleLarge),
                  const SizedBox(height: 8),
                  Text(
                    t.address.emptySubtitle,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.onBackgroundLight,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: state.addresses.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final address = state.addresses[index];
              final isSelected = address.id == state.selectedAddress?.id;

              return _AddressCard(
                label: address.label,
                address: address.shortAddress,
                fullAddress:
                    '${address.city}, ${address.state} - ${address.zipCode}',
                isSelected: isSelected,
                onTap: () {
                  unawaited(
                    context.read<AddressCubit>().setDefault(address.id),
                  );
                },
                onDelete: () {
                  unawaited(
                    context.read<AddressCubit>().deleteAddress(address.id),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  const _AddressCard({
    required this.address,
    required this.fullAddress,
    required this.isSelected,
    required this.onTap,
    required this.onDelete,
    this.label,
  });

  final String? label;
  final String address;
  final String fullAddress;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            FaIcon(
              FontAwesomeIcons.locationDot,
              size: 20,
              color: isSelected
                  ? AppColors.primary
                  : AppColors.onBackgroundLight,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (label != null && label!.isNotEmpty)
                    Text(
                      label!,
                      style: AppTypography.labelLarge.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  Text(address, style: AppTypography.bodyLarge),
                  const SizedBox(height: 2),
                  Text(fullAddress, style: AppTypography.bodySmall),
                ],
              ),
            ),
            if (isSelected)
              const FaIcon(
                FontAwesomeIcons.circleCheck,
                color: AppColors.primary,
              )
            else
              IconButton(
                icon: const FaIcon(
                  FontAwesomeIcons.trashCan,
                  color: AppColors.onBackgroundLight,
                  size: 18,
                ),
                onPressed: onDelete,
              ),
          ],
        ),
      ),
    );
  }
}
