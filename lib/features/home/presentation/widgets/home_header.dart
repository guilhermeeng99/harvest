import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:harvest/app/routes/app_routes.dart';
import 'package:harvest/app/theme/app_colors.dart';
import 'package:harvest/app/theme/app_typography.dart';
import 'package:harvest/features/address/presentation/cubit/address_cubit.dart';
import 'package:harvest/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:harvest/gen/i18n/strings.g.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 12, 0),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => context.push(AppRoutes.addresses),
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: AppColors.primary,
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: BlocBuilder<AddressCubit, AddressState>(
                      builder: (context, state) {
                        final address = state.selectedAddress;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              t.address.deliverTo,
                              style: AppTypography.labelSmall,
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    address?.shortAddress ??
                                        t.address.selectAddress,
                                    style: AppTypography.titleMedium.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 20,
                                  color: AppColors.onBackground,
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          BlocBuilder<NotificationsCubit, NotificationsState>(
            builder: (context, state) {
              final unread = state.unreadCount;
              return IconButton(
                onPressed: () => context.push(AppRoutes.notifications),
                icon: Badge(
                  isLabelVisible: unread > 0,
                  label: Text(
                    unread.toString(),
                    style: const TextStyle(fontSize: 10),
                  ),
                  child: const Icon(
                    Icons.notifications_outlined,
                    color: AppColors.onBackground,
                    size: 26,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
