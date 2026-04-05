import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:harvest/app/theme/app_colors.dart';
import 'package:harvest/app/theme/app_typography.dart';
import 'package:harvest/app/widgets/harvest_button.dart';
import 'package:harvest/core/extensions/context_extensions.dart';
import 'package:harvest/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:harvest/gen/i18n/strings.g.dart';

class AuthLayout extends StatelessWidget {
  const AuthLayout({
    required this.formKey,
    required this.title,
    required this.subtitle,
    required this.fields,
    required this.buttonLabel,
    required this.onSubmit,
    required this.bottomText,
    required this.bottomActionLabel,
    required this.onBottomAction,
    this.onGoogleSignIn,
    super.key,
  });

  final GlobalKey<FormState> formKey;
  final String title;
  final String subtitle;
  final List<Widget> fields;
  final String buttonLabel;
  final VoidCallback onSubmit;
  final String bottomText;
  final String bottomActionLabel;
  final VoidCallback onBottomAction;
  final VoidCallback? onGoogleSignIn;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.error && state.errorMessage != null) {
            context.showErrorSnackBar(state.errorMessage!);
          }
        },
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Center(
                        child: FaIcon(
                          FontAwesomeIcons.seedling,
                          size: 56,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        title,
                        style: AppTypography.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        subtitle,
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.onBackgroundLight,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),
                      for (int i = 0; i < fields.length; i++) ...[
                        if (i > 0) const SizedBox(height: 16),
                        fields[i],
                      ],
                      const SizedBox(height: 24),
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          return HarvestButton(
                            label: buttonLabel,
                            onPressed: onSubmit,
                            isLoading: state.status == AuthStatus.loading,
                            width: double.infinity,
                          );
                        },
                      ),
                      if (onGoogleSignIn != null) ...[
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Expanded(child: Divider()),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Text(
                                t.general.or,
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.onBackgroundLight,
                                ),
                              ),
                            ),
                            const Expanded(child: Divider()),
                          ],
                        ),
                        const SizedBox(height: 16),
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            return OutlinedButton.icon(
                              onPressed: state.status == AuthStatus.loading
                                  ? null
                                  : onGoogleSignIn,
                              icon: const FaIcon(
                                FontAwesomeIcons.google,
                                size: 18,
                              ),
                              label: Text(t.auth.signInWithGoogle),
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 48),
                                side: const BorderSide(
                                  color: AppColors.surfaceVariant,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(bottomText, style: AppTypography.bodyMedium),
                          TextButton(
                            onPressed: onBottomAction,
                            child: Text(bottomActionLabel),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
