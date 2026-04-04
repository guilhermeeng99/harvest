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

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSignUp() {
    if (!_formKey.currentState!.validate()) return;

    context.read<AuthBloc>().add(
      AuthSignUpRequested(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      formKey: _formKey,
      title: t.auth.createAccount,
      subtitle: t.auth.signUpSubtitle,
      fields: [
        HarvestTextField(
          controller: _nameController,
          label: t.auth.name,
          hint: t.auth.nameHint,
          prefixIcon: const FaIcon(FontAwesomeIcons.user),
          textInputAction: TextInputAction.next,
          validator: Validators.name,
        ),
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
      buttonLabel: t.auth.signUp,
      onSubmit: _onSignUp,
      bottomText: t.auth.hasAccount,
      bottomActionLabel: t.auth.signIn,
      onBottomAction: () => context.go(AppRoutes.signIn),
    );
  }
}
