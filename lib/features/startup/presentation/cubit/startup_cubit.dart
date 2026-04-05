import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harvest/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:harvest/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:harvest/features/home/domain/usecases/get_all_products_usecase.dart';
import 'package:harvest/features/home/domain/usecases/get_categories_usecase.dart';
import 'package:harvest/features/home/domain/usecases/get_featured_products_usecase.dart';
import 'package:harvest/features/home/presentation/bloc/home_bloc.dart';
import 'package:harvest/features/orders/domain/usecases/get_orders_usecase.dart';
import 'package:harvest/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:harvest/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:harvest/features/startup/presentation/cubit/startup_state.dart';

class StartupCubit extends Cubit<StartupState> {
  StartupCubit({
    required GetCategoriesUseCase getCategoriesUseCase,
    required GetAllProductsUseCase getAllProductsUseCase,
    required GetFeaturedProductsUseCase getFeaturedProductsUseCase,
    required GetOrdersUseCase getOrdersUseCase,
    required AuthBloc authBloc,
    required HomeBloc homeBloc,
    required OrdersBloc ordersBloc,
    required ProfileCubit profileCubit,
    required CartBloc cartBloc,
  }) : _getCategoriesUseCase = getCategoriesUseCase,
       _getAllProductsUseCase = getAllProductsUseCase,
       _getFeaturedProductsUseCase = getFeaturedProductsUseCase,
       _getOrdersUseCase = getOrdersUseCase,
       _authBloc = authBloc,
       _homeBloc = homeBloc,
       _ordersBloc = ordersBloc,
       _profileCubit = profileCubit,
       _cartBloc = cartBloc,
       super(const StartupInitial());

  final GetCategoriesUseCase _getCategoriesUseCase;
  final GetAllProductsUseCase _getAllProductsUseCase;
  final GetFeaturedProductsUseCase _getFeaturedProductsUseCase;
  final GetOrdersUseCase _getOrdersUseCase;
  final AuthBloc _authBloc;
  final HomeBloc _homeBloc;
  final OrdersBloc _ordersBloc;
  final ProfileCubit _profileCubit;
  final CartBloc _cartBloc;

  Future<void> initialize() async {
    try {
      emit(const StartupLoading(step: 'profile', progress: 0));
      final isAuthenticated = await _waitForAuth();
      if (!isAuthenticated) {
        emit(const StartupUnauthenticated());
        return;
      }

      emit(const StartupLoading(step: 'categories', progress: 0.2));
      final categoriesResult = await _getCategoriesUseCase();
      final categoriesFailed = categoriesResult.isLeft();

      emit(const StartupLoading(step: 'products', progress: 0.4));
      final results = await Future.wait([
        _getAllProductsUseCase(),
        _getFeaturedProductsUseCase(),
      ]);
      final allProductsFailed = results[0].isLeft();

      if (categoriesFailed && allProductsFailed) {
        emit(const StartupError('Failed to load essential data'));
        return;
      }

      emit(const StartupLoading(step: 'orders', progress: 0.7));
      await _getOrdersUseCase();

      emit(const StartupLoading(step: 'cart', progress: 0.85));
      _cartBloc.add(const CartLoadRequested());

      emit(const StartupLoading(step: 'finishing', progress: 0.95));
      _homeBloc.add(const HomeLoadRequested());
      _ordersBloc.add(const OrdersLoadRequested());
      await _profileCubit.refreshProfile();

      emit(const StartupComplete());
    } on Exception {
      emit(const StartupError('Something went wrong during startup'));
    }
  }

  Future<bool> _waitForAuth() async {
    if (_authBloc.state.status == AuthStatus.authenticated) return true;
    if (_authBloc.state.status == AuthStatus.unauthenticated) return false;

    final completer = Completer<bool>();
    final subscription = _authBloc.stream.listen((state) {
      if (state.status == AuthStatus.authenticated) {
        if (!completer.isCompleted) completer.complete(true);
      } else if (state.status == AuthStatus.unauthenticated ||
          state.status == AuthStatus.error) {
        if (!completer.isCompleted) completer.complete(false);
      }
    });

    final result = await completer.future;
    await subscription.cancel();
    return result;
  }
}
