import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:harvest/app/di/injection_container.dart';
import 'package:harvest/app/routes/app_routes.dart';
import 'package:harvest/app/widgets/shell_scaffold.dart';
import 'package:harvest/features/address/presentation/pages/add_address_page.dart';
import 'package:harvest/features/address/presentation/pages/address_selection_page.dart';
import 'package:harvest/features/admin/presentation/pages/admin_categories_page.dart';
import 'package:harvest/features/admin/presentation/pages/admin_category_form_page.dart';
import 'package:harvest/features/admin/presentation/pages/admin_orders_page.dart';
import 'package:harvest/features/admin/presentation/pages/admin_product_form_page.dart';
import 'package:harvest/features/admin/presentation/pages/admin_products_page.dart';
import 'package:harvest/features/admin/presentation/pages/admin_user_detail_page.dart';
import 'package:harvest/features/admin/presentation/pages/admin_users_page.dart';
import 'package:harvest/features/admin/presentation/widgets/admin_scaffold.dart';
import 'package:harvest/features/auth/domain/entities/user_entity.dart';
import 'package:harvest/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:harvest/features/auth/presentation/pages/sign_in_page.dart';
import 'package:harvest/features/auth/presentation/pages/sign_up_page.dart';
import 'package:harvest/features/cart/presentation/pages/cart_page.dart';
import 'package:harvest/features/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:harvest/features/checkout/presentation/pages/checkout_page.dart';
import 'package:harvest/features/checkout/presentation/pages/order_confirmation_page.dart';
import 'package:harvest/features/home/presentation/pages/home_page.dart';
import 'package:harvest/features/notifications/presentation/pages/notifications_page.dart';
import 'package:harvest/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:harvest/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:harvest/features/orders/presentation/pages/order_details_page.dart';
import 'package:harvest/features/orders/presentation/pages/orders_page.dart';
import 'package:harvest/features/product_details/presentation/pages/product_details_page.dart';
import 'package:harvest/features/profile/presentation/pages/profile_page.dart';
import 'package:harvest/features/profile/presentation/pages/web_view_page.dart';
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
      final isAdminRoute = state.matchedLocation.startsWith(AppRoutes.admin);

      if (!isAuth && !isAuthRoute) return AppRoutes.signIn;
      if (isAuth && isAuthRoute) return AppRoutes.home;
      if (isAdminRoute && authState.user?.isAdmin != true) {
        return AppRoutes.home;
      }
      return null;
    },
    refreshListenable: _AuthNotifier(authBloc),
    routes: [
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (_, _) => const OnboardingPage(),
      ),
      GoRoute(path: AppRoutes.signIn, builder: (_, _) => const SignInPage()),
      GoRoute(path: AppRoutes.signUp, builder: (_, _) => const SignUpPage()),
      ShellRoute(
        builder: (_, state, child) =>
            ShellScaffold(currentPath: state.matchedLocation, child: child),
        routes: [
          GoRoute(path: AppRoutes.home, builder: (_, _) => const HomePage()),
          GoRoute(
            path: AppRoutes.search,
            builder: (_, state) {
              final categoryId = state.uri.queryParameters['categoryId'];
              return SearchPage(initialCategoryId: categoryId);
            },
          ),
          GoRoute(path: AppRoutes.cart, builder: (_, _) => const CartPage()),
          GoRoute(
            path: AppRoutes.orders,
            builder: (_, _) => const OrdersPage(),
          ),
          GoRoute(
            path: AppRoutes.profile,
            builder: (_, _) => const ProfilePage(),
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
        builder: (_, _) => BlocProvider(
          create: (_) => sl<CheckoutBloc>(),
          child: const CheckoutPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.orderConfirmation,
        builder: (_, _) => const OrderConfirmationPage(),
      ),
      GoRoute(
        path: AppRoutes.orderDetails,
        builder: (_, state) {
          final id = state.pathParameters['id']!;
          return BlocProvider(
            create: (_) => sl<OrdersBloc>()..add(const OrdersLoadRequested()),
            child: OrderDetailsPage(orderId: id),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.addresses,
        builder: (_, _) => const AddressSelectionPage(),
      ),
      GoRoute(
        path: AppRoutes.addressAdd,
        builder: (_, _) => const AddAddressPage(),
      ),
      GoRoute(
        path: AppRoutes.notifications,
        builder: (_, _) => const NotificationsPage(),
      ),
      ShellRoute(
        builder: (_, state, child) =>
            AdminScaffold(currentPath: state.matchedLocation, child: child),
        routes: [
          GoRoute(
            path: AppRoutes.admin,
            redirect: (_, _) => AppRoutes.adminProducts,
          ),
          GoRoute(
            path: AppRoutes.adminProducts,
            builder: (_, _) => const AdminProductsPage(),
          ),
          GoRoute(
            path: AppRoutes.adminCategories,
            builder: (_, _) => const AdminCategoriesPage(),
          ),
          GoRoute(
            path: AppRoutes.adminOrders,
            builder: (_, _) => const AdminOrdersPage(),
          ),
          GoRoute(
            path: AppRoutes.adminUsers,
            builder: (_, _) => const AdminUsersPage(),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.adminProductAdd,
        builder: (_, _) => const AdminProductFormPage(),
      ),
      GoRoute(
        path: AppRoutes.adminProductEdit,
        builder: (_, state) {
          final id = state.pathParameters['id']!;
          return AdminProductFormPage(productId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.adminCategoryAdd,
        builder: (_, _) => const AdminCategoryFormPage(),
      ),
      GoRoute(
        path: AppRoutes.adminCategoryEdit,
        builder: (_, state) {
          final id = state.pathParameters['id']!;
          return AdminCategoryFormPage(categoryId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.adminUserDetail,
        builder: (_, state) {
          final user = state.extra! as UserEntity;
          return AdminUserDetailPage(user: user);
        },
      ),
      GoRoute(
        path: AppRoutes.webView,
        builder: (_, state) {
          final extra = state.extra! as Map<String, String>;
          return WebViewPage(url: extra['url']!, title: extra['title']!);
        },
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
