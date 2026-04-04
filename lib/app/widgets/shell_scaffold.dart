import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:harvest/app/routes/app_routes.dart';
import 'package:harvest/app/theme/app_colors.dart';
import 'package:harvest/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:harvest/gen/i18n/strings.g.dart';

class ShellScaffold extends StatelessWidget {
  const ShellScaffold({
    required this.currentPath,
    required this.child,
    super.key,
  });

  final String currentPath;
  final Widget child;

  int get _currentIndex {
    if (currentPath == AppRoutes.home) return 0;
    if (currentPath == AppRoutes.search) return 1;
    if (currentPath == AppRoutes.cart) return 2;
    if (currentPath == AppRoutes.orders) return 3;
    if (currentPath == AppRoutes.profile) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => _onItemTapped(context, index),
        items: [
          BottomNavigationBarItem(
            icon: const FaIcon(FontAwesomeIcons.house, size: 22),
            activeIcon: const FaIcon(FontAwesomeIcons.house, size: 22),
            label: t.nav.home,
          ),
          BottomNavigationBarItem(
            icon: const FaIcon(
              FontAwesomeIcons.magnifyingGlass,
              size: 22,
            ),
            activeIcon: const FaIcon(
              FontAwesomeIcons.magnifyingGlass,
              size: 22,
            ),
            label: t.nav.search,
          ),
          BottomNavigationBarItem(
            icon: BlocBuilder<CartBloc, CartState>(
              builder: (context, state) {
                return Badge(
                  isLabelVisible: !state.isEmpty,
                  label: Text('${state.itemCount}'),
                  backgroundColor: AppColors.secondary,
                  child: const FaIcon(
                    FontAwesomeIcons.bagShopping,
                    size: 22,
                  ),
                );
              },
            ),
            activeIcon: BlocBuilder<CartBloc, CartState>(
              builder: (context, state) {
                return Badge(
                  isLabelVisible: !state.isEmpty,
                  label: Text('${state.itemCount}'),
                  backgroundColor: AppColors.secondary,
                  child: const FaIcon(
                    FontAwesomeIcons.bagShopping,
                    size: 22,
                  ),
                );
              },
            ),
            label: t.nav.cart,
          ),
          BottomNavigationBarItem(
            icon: const FaIcon(FontAwesomeIcons.receipt, size: 22),
            activeIcon: const FaIcon(
              FontAwesomeIcons.receipt,
              size: 22,
            ),
            label: t.nav.orders,
          ),
          BottomNavigationBarItem(
            icon: const FaIcon(FontAwesomeIcons.user, size: 22),
            activeIcon: const FaIcon(FontAwesomeIcons.user, size: 22),
            label: t.nav.profile,
          ),
        ],
      ),
    );
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRoutes.home);
      case 1:
        context.go(AppRoutes.search);
      case 2:
        context.go(AppRoutes.cart);
      case 3:
        context.go(AppRoutes.orders);
      case 4:
        context.go(AppRoutes.profile);
    }
  }
}
