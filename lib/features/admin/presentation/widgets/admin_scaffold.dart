import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:harvest/app/routes/app_routes.dart';
import 'package:harvest/gen/i18n/strings.g.dart';

class AdminScaffold extends StatefulWidget {
  const AdminScaffold({
    required this.currentPath,
    required this.child,
    super.key,
  });

  final String currentPath;
  final Widget child;

  @override
  State<AdminScaffold> createState() => _AdminScaffoldState();
}

class _AdminScaffoldState extends State<AdminScaffold>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;
  int _previousIndex = -1;

  int get _selectedIndex {
    if (widget.currentPath.startsWith(AppRoutes.adminProducts)) return 0;
    if (widget.currentPath.startsWith(AppRoutes.adminCategories)) return 1;
    if (widget.currentPath.startsWith(AppRoutes.adminOrders)) return 2;
    if (widget.currentPath.startsWith(AppRoutes.adminUsers)) return 3;
    return 0;
  }

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _previousIndex = _selectedIndex;
    _fadeController.value = 1.0;
  }

  @override
  void didUpdateWidget(covariant AdminScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_selectedIndex != _previousIndex) {
      _previousIndex = _selectedIndex;
      _fadeController.value = 0.0;
      unawaited(_fadeController.forward());
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final i18n = t.admin;
    return Scaffold(
      appBar: AppBar(
        title: Text(i18n.title),
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.arrowLeft, size: 18),
          onPressed: () => context.go(AppRoutes.profile),
        ),
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            labelType: NavigationRailLabelType.all,
            onDestinationSelected: (index) {
              switch (index) {
                case 0:
                  context.go(AppRoutes.adminProducts);
                case 1:
                  context.go(AppRoutes.adminCategories);
                case 2:
                  context.go(AppRoutes.adminOrders);
                case 3:
                  context.go(AppRoutes.adminUsers);
              }
            },
            destinations: [
              NavigationRailDestination(
                icon: const FaIcon(
                  FontAwesomeIcons.boxesStacked,
                  size: 20,
                ),
                selectedIcon: const FaIcon(
                  FontAwesomeIcons.boxesStacked,
                  size: 20,
                ),
                label: Text(i18n.products),
              ),
              NavigationRailDestination(
                icon: const FaIcon(FontAwesomeIcons.tags, size: 20),
                selectedIcon: const FaIcon(
                  FontAwesomeIcons.tags,
                  size: 20,
                ),
                label: Text(i18n.categories),
              ),
              NavigationRailDestination(
                icon: const FaIcon(FontAwesomeIcons.clipboardList, size: 20),
                selectedIcon: const FaIcon(
                  FontAwesomeIcons.clipboardList,
                  size: 20,
                ),
                label: Text(i18n.orders),
              ),
              NavigationRailDestination(
                icon: const FaIcon(FontAwesomeIcons.users, size: 20),
                selectedIcon: const FaIcon(
                  FontAwesomeIcons.users,
                  size: 20,
                ),
                label: Text(i18n.users),
              ),
            ],
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: FadeTransition(opacity: _fadeAnimation, child: widget.child),
          ),
        ],
      ),
    );
  }
}
