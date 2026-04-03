import 'dart:async';

import 'package:flutter/material.dart';
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
    if (widget.currentPath.startsWith(AppRoutes.adminUsers)) return 2;
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
          icon: const Icon(Icons.arrow_back),
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
                  context.go(AppRoutes.adminUsers);
              }
            },
            destinations: [
              NavigationRailDestination(
                icon: const Icon(Icons.inventory_2_outlined),
                selectedIcon: const Icon(Icons.inventory_2),
                label: Text(i18n.products),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.category_outlined),
                selectedIcon: const Icon(Icons.category),
                label: Text(i18n.categories),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.people_outlined),
                selectedIcon: const Icon(Icons.people),
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
