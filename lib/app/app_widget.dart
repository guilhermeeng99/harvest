import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harvest/app/di/injection_container.dart';
import 'package:harvest/app/routes/app_router.dart';
import 'package:harvest/app/theme/app_theme.dart';
import 'package:harvest/features/address/presentation/cubit/address_cubit.dart';
import 'package:harvest/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:harvest/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:harvest/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:harvest/gen/i18n/strings.g.dart';

class HarvestApp extends StatefulWidget {
  const HarvestApp({super.key});

  @override
  State<HarvestApp> createState() => _HarvestAppState();
}

class _HarvestAppState extends State<HarvestApp> {
  late final AuthBloc _authBloc;
  late final CartBloc _cartBloc;
  late final AddressCubit _addressCubit;
  late final NotificationsCubit _notificationsCubit;

  @override
  void initState() {
    super.initState();
    _authBloc = sl<AuthBloc>()..add(const AuthCheckRequested());
    _cartBloc = sl<CartBloc>();
    _addressCubit = sl<AddressCubit>();
    unawaited(_addressCubit.loadAddresses());
    _notificationsCubit = sl<NotificationsCubit>()..loadNotifications();
  }

  @override
  void dispose() {
    unawaited(_authBloc.close());
    unawaited(_cartBloc.close());
    unawaited(_addressCubit.close());
    unawaited(_notificationsCubit.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _authBloc),
        BlocProvider.value(value: _cartBloc),
        BlocProvider.value(value: _addressCubit),
        BlocProvider.value(value: _notificationsCubit),
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
