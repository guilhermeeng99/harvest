import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:harvest/app/routes/app_routes.dart';
import 'package:harvest/app/widgets/harvest_text_field.dart';
import 'package:harvest/core/utils/validators.dart';
import 'package:harvest/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:harvest/features/auth/presentation/widgets/auth_layout.dart';
import 'package:harvest/gen/i18n/strings.g.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSignIn() {
    if (!_formKey.currentState!.validate()) return;

    context.read<AuthBloc>().add(
      AuthSignInRequested(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      formKey: _formKey,
      title: t.auth.welcomeBack,
      subtitle: t.auth.signInSubtitle,
      fields: [
        HarvestTextField(
          controller: _emailController,
          label: t.auth.email,
          hint: t.auth.emailHint,
          prefixIcon: const FaIcon(FontAwesomeIcons.envelope),
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          validator: Validators.email,
        ),
        HarvestTextField(
          controller: _passwordController,
          label: t.auth.password,
          hint: t.auth.passwordHint,
          prefixIcon: const FaIcon(FontAwesomeIcons.lock),
          obscureText: _obscurePassword,
          textInputAction: TextInputAction.done,
          validator: Validators.password,
          suffixIcon: IconButton(
            icon: FaIcon(
              _obscurePassword
                  ? FontAwesomeIcons.eye
                  : FontAwesomeIcons.eyeSlash,
            ),
            onPressed: () =>
                setState(() => _obscurePassword = !_obscurePassword),
          ),
        ),
      ],
      buttonLabel: t.auth.signIn,
      onSubmit: _onSignIn,
      bottomText: t.auth.noAccount,
      bottomActionLabel: t.auth.signUp,
      onBottomAction: () => context.go(AppRoutes.signUp),
    );
  }
}
