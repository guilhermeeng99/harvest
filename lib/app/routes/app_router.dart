import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:harvest/app/di/injection_container.dart';
import 'package:harvest/app/routes/app_routes.dart';
import 'package:harvest/app/widgets/shell_scaffold.dart';
import 'package:harvest/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:harvest/features/auth/presentation/pages/sign_in_page.dart';
import 'package:harvest/features/auth/presentation/pages/sign_up_page.dart';
import 'package:harvest/features/cart/presentation/pages/cart_page.dart';
import 'package:harvest/features/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:harvest/features/checkout/presentation/pages/checkout_page.dart';
import 'package:harvest/features/checkout/presentation/pages/order_confirmation_page.dart';
import 'package:harvest/features/home/presentation/pages/home_page.dart';
import 'package:harvest/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:harvest/features/orders/presentation/pages/orders_page.dart';
import 'package:harvest/features/product_details/presentation/pages/product_details_page.dart';
import 'package:harvest/features/profile/presentation/pages/profile_page.dart';
import 'package:harvest/features/search/presentation/pages/search_page.dart';

GoRouter createRouter(AuthBloc authBloc) {
  return GoRouter(
    initialLocation: AppRoutes.onboarding,
    redirect: (context, state) {
      final authState = authBloc.state;
      final isAuth = authState.status == AuthStatus.authenticated;
      final isAuthRoute =
          state.matchedLocation == AppRoutes.signIn ||
          state.matchedLocation == AppRoutes.signUp ||
          state.matchedLocation == AppRoutes.onboarding;

      if (!isAuth && !isAuthRoute) return AppRoutes.signIn;
      if (isAuth && isAuthRoute) return AppRoutes.home;
      return null;
    },
    refreshListenable: _AuthNotifier(authBloc),
    routes: [
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (_, __) => const OnboardingPage(),
      ),
      GoRoute(path: AppRoutes.signIn, builder: (_, __) => const SignInPage()),
      GoRoute(path: AppRoutes.signUp, builder: (_, __) => const SignUpPage()),
      ShellRoute(
        builder: (_, state, child) =>
            ShellScaffold(currentPath: state.matchedLocation, child: child),
        routes: [
          GoRoute(path: AppRoutes.home, builder: (_, __) => const HomePage()),
          GoRoute(
            path: AppRoutes.search,
            builder: (_, __) => const SearchPage(),
          ),
          GoRoute(path: AppRoutes.cart, builder: (_, __) => const CartPage()),
          GoRoute(
            path: AppRoutes.orders,
            builder: (_, __) => const OrdersPage(),
          ),
          GoRoute(
            path: AppRoutes.profile,
            builder: (_, __) => const ProfilePage(),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.productDetails,
        builder: (_, state) {
          final id = state.pathParameters['id']!;
          return ProductDetailsPage(productId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.checkout,
        builder: (_, __) => BlocProvider(
          create: (_) => sl<CheckoutBloc>(),
          child: const CheckoutPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.orderConfirmation,
        builder: (_, __) => const OrderConfirmationPage(),
      ),
    ],
  );
}

class _AuthNotifier extends ChangeNotifier {
  _AuthNotifier(this._bloc) {
    _bloc.stream.listen((_) => notifyListeners());
  }

  final AuthBloc _bloc;
}
