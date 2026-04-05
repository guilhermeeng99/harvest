import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:harvest/app/di/injection_container.dart';
import 'package:harvest/app/routes/app_routes.dart';
import 'package:harvest/app/theme/app_colors.dart';
import 'package:harvest/app/theme/app_typography.dart';
import 'package:harvest/features/startup/presentation/cubit/startup_cubit.dart';
import 'package:harvest/features/startup/presentation/cubit/startup_state.dart';
import 'package:harvest/features/startup/presentation/widgets/startup_widgets.dart';
import 'package:harvest/gen/assets.gen.dart';
import 'package:harvest/gen/i18n/strings.g.dart';

class StartupPage extends StatelessWidget {
  const StartupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = sl<StartupCubit>();
        unawaited(cubit.initialize());
        return cubit;
      },
      child: const _StartupView(),
    );
  }
}

class _StartupView extends StatelessWidget {
  const _StartupView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<StartupCubit, StartupState>(
      listener: (context, state) {
        if (state is StartupComplete) {
          context.go(AppRoutes.home);
        } else if (state is StartupUnauthenticated) {
          context.go(AppRoutes.onboarding);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: BlocBuilder<StartupCubit, StartupState>(
              builder: (context, state) {
                return switch (state) {
                  StartupError(:final message) => _ErrorContent(
                    message: message,
                  ),
                  StartupLoading(:final step, :final progress) =>
                    _LoadingContent(step: step, progress: progress),
                  _ => const _LoadingContent(step: 'profile', progress: 0),
                };
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _LoadingContent extends StatelessWidget {
  const _LoadingContent({required this.step, required this.progress});

  final String step;
  final double progress;

  String _stepLabel() {
    return switch (step) {
      'profile' => t.startup.authenticating,
      'categories' => t.startup.loadingCategories,
      'products' => t.startup.loadingProducts,
      'orders' => t.startup.loadingOrders,
      'cart' => t.startup.loadingCart,
      'finishing' => t.startup.finishing,
      _ => t.general.loading,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(flex: 2),
        Image.asset(Assets.lib.app.assets.images.logo.path, height: 100),
        const SizedBox(height: 16),
        Text(
          t.app.name,
          style: AppTypography.headlineLarge.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          t.app.tagline,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.onBackgroundLight,
          ),
          textAlign: TextAlign.center,
        ),
        const Spacer(),
        StartupAnimatedIcons(progress: progress),
        const SizedBox(height: 32),
        StartupProgressBar(progress: progress),
        const SizedBox(height: 16),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            _stepLabel(),
            key: ValueKey(step),
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.onBackgroundLight,
            ),
          ),
        ),
        const Spacer(flex: 2),
      ],
    );
  }
}

class _ErrorContent extends StatelessWidget {
  const _ErrorContent({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error_outline, size: 64, color: AppColors.error),
        const SizedBox(height: 16),
        Text(
          message,
          style: AppTypography.bodyLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: () {
            unawaited(context.read<StartupCubit>().initialize());
          },
          child: Text(t.general.retry),
        ),
      ],
    );
  }
}
