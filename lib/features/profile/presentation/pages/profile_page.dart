import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:harvest/app/di/injection_container.dart';
import 'package:harvest/app/routes/app_routes.dart';
import 'package:harvest/app/theme/app_colors.dart';
import 'package:harvest/app/theme/app_typography.dart';
import 'package:harvest/core/constants/admin_constants.dart';
import 'package:harvest/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:harvest/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:harvest/gen/i18n/strings.g.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = sl<ProfileCubit>();
        unawaited(cubit.loadProfile());
        return cubit;
      },
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(t.profile.title), centerTitle: true),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _UserCard(
                name: state.user?.name ?? '',
                email: state.user?.email ?? '',
              ),
              const SizedBox(height: 24),
              _MenuItem(
                icon: const FaIcon(
                  FontAwesomeIcons.receipt,
                  size: 20,
                  color: AppColors.onBackground,
                ),
                label: t.profile.myOrders,
                onTap: () => context.go(AppRoutes.orders),
              ),
              _MenuItem(
                icon: const FaIcon(
                  FontAwesomeIcons.locationDot,
                  size: 20,
                  color: AppColors.onBackground,
                ),
                label: t.profile.deliveryAddresses,
                onTap: () => context.push(AppRoutes.addresses),
              ),
              _MenuItem(
                icon: const FaIcon(
                  FontAwesomeIcons.wallet,
                  size: 20,
                  color: AppColors.onBackground,
                ),
                label: t.profile.paymentMethods,
                onTap: () {},
              ),
              _MenuItem(
                icon: const FaIcon(
                  FontAwesomeIcons.bell,
                  size: 20,
                  color: AppColors.onBackground,
                ),
                label: t.profile.notifications,
                onTap: () => context.push(AppRoutes.notifications),
              ),
              const Divider(height: 32),
              _MenuItem(
                icon: const FaIcon(
                  FontAwesomeIcons.circleQuestion,
                  size: 20,
                  color: AppColors.onBackground,
                ),
                label: t.profile.helpCenter,
                onTap: () {},
              ),
              _MenuItem(
                icon: const FaIcon(
                  FontAwesomeIcons.circleInfo,
                  size: 20,
                  color: AppColors.onBackground,
                ),
                label: t.profile.about,
                onTap: () {},
              ),
              const SizedBox(height: 24),
              if (state.user?.email == AdminConstants.adminEmail)
                _MenuItem(
                  icon: const FaIcon(
                    FontAwesomeIcons.screwdriverWrench,
                    size: 20,
                    color: AppColors.onBackground,
                  ),
                  label: t.admin.adminPanel,
                  onTap: () => context.go(AppRoutes.admin),
                ),
              _MenuItem(
                icon: const FaIcon(
                  FontAwesomeIcons.rightFromBracket,
                  size: 20,
                  color: AppColors.error,
                ),
                label: t.auth.signOut,
                onTap: () =>
                    context.read<AuthBloc>().add(const AuthSignOutRequested()),
                isDestructive: true,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  const _UserCard({required this.name, required this.email});

  final String name;
  final String email;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: AppColors.primaryLight.withValues(alpha: 0.2),
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : '?',
              style: AppTypography.headlineMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTypography.titleLarge),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.onBackgroundLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
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
