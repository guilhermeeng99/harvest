import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harvest/app/di/injection_container.dart';
import 'package:harvest/app/routes/app_router.dart';
import 'package:harvest/app/theme/app_theme.dart';
import 'package:harvest/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:harvest/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:harvest/gen/i18n/strings.g.dart';

class HarvestApp extends StatefulWidget {
  const HarvestApp({super.key});

  @override
  State<HarvestApp> createState() => _HarvestAppState();
}

class _HarvestAppState extends State<HarvestApp> {
  late final AuthBloc _authBloc;
  late final CartBloc _cartBloc;

  @override
  void initState() {
    super.initState();
    _authBloc = sl<AuthBloc>()..add(const AuthCheckRequested());
    _cartBloc = sl<CartBloc>();
  }

  @override
  void dispose() {
    _authBloc.close();
    _cartBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _authBloc),
        BlocProvider.value(value: _cartBloc),
      ],
      child: TranslationProvider(
        child: MaterialApp.router(
          title: t.app.name,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          routerConfig: createRouter(_authBloc),
        ),
      ),
    );
  }
}
