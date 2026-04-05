import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:harvest/app/routes/app_routes.dart';
import 'package:harvest/app/theme/app_colors.dart';
import 'package:harvest/core/constants/site_urls.dart';
import 'package:harvest/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:harvest/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:harvest/features/profile/presentation/widgets/edit_profile_dialog.dart';
import 'package:harvest/features/profile/presentation/widgets/profile_menu_item.dart';
import 'package:harvest/features/profile/presentation/widgets/profile_user_card.dart';
import 'package:harvest/gen/i18n/strings.g.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ProfileView();
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  Future<void> _showEditProfile(
    BuildContext context,
    ProfileState state,
  ) async {
    final result = await showDialog<String>(
      context: context,
      builder: (_) => EditProfileDialog(
        currentName: state.user?.name ?? '',
        currentPhotoUrl: state.user?.photoUrl,
      ),
    );
    if (result == null || !context.mounted) return;
    final cubit = context.read<ProfileCubit>();
    final success = await cubit.updateProfile(name: result);
    if (success && context.mounted) {
      unawaited(cubit.loadProfile());
    }
  }

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
              ProfileUserCard(
                name: state.user?.name ?? '',
                email: state.user?.email ?? '',
                photoUrl: state.user?.photoUrl,
                onTap: () => _showEditProfile(context, state),
              ),
              const SizedBox(height: 24),
              ProfileMenuItem(
                icon: const FaIcon(
                  FontAwesomeIcons.receipt,
                  size: 20,
                  color: AppColors.onBackground,
                ),
                label: t.profile.myOrders,
                onTap: () => context.go(AppRoutes.orders),
              ),
              ProfileMenuItem(
                icon: const FaIcon(
                  FontAwesomeIcons.locationDot,
                  size: 20,
                  color: AppColors.onBackground,
                ),
                label: t.profile.deliveryAddresses,
                onTap: () => context.push(AppRoutes.addresses),
              ),
              ProfileMenuItem(
                icon: const FaIcon(
                  FontAwesomeIcons.wallet,
                  size: 20,
                  color: AppColors.onBackground,
                ),
                label: t.profile.paymentMethods,
                onTap: () {},
              ),
              ProfileMenuItem(
                icon: const FaIcon(
                  FontAwesomeIcons.bell,
                  size: 20,
                  color: AppColors.onBackground,
                ),
                label: t.profile.notifications,
                onTap: () => context.push(AppRoutes.notifications),
              ),
              const Divider(height: 32),
              ProfileMenuItem(
                icon: const FaIcon(
                  FontAwesomeIcons.circleQuestion,
                  size: 20,
                  color: AppColors.onBackground,
                ),
                label: t.profile.helpCenter,
                onTap: () {
                  if (kIsWeb) {
                    unawaited(
                      launchUrl(
                        Uri.parse(SiteUrls.helpCenter),
                        mode: LaunchMode.externalApplication,
                      ),
                    );
                  } else {
                    unawaited(
                      context.push(
                        AppRoutes.webView,
                        extra: <String, String>{
                          'url': SiteUrls.helpCenter,
                          'title': t.profile.helpCenter,
                        },
                      ),
                    );
                  }
                },
              ),
              ProfileMenuItem(
                icon: const FaIcon(
                  FontAwesomeIcons.circleInfo,
                  size: 20,
                  color: AppColors.onBackground,
                ),
                label: t.profile.about,
                onTap: () => launchUrl(
                  Uri.parse(SiteUrls.about),
                  mode: LaunchMode.externalApplication,
                ),
              ),
              const SizedBox(height: 24),
              if (state.user?.isAdmin == true)
                ProfileMenuItem(
                  icon: const FaIcon(
                    FontAwesomeIcons.screwdriverWrench,
                    size: 20,
                    color: AppColors.onBackground,
                  ),
                  label: t.admin.adminPanel,
                  onTap: () => context.go(AppRoutes.admin),
                ),
              ProfileMenuItem(
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
