import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:harvest/app/di/injection_container.dart';
import 'package:harvest/app/routes/app_routes.dart';
import 'package:harvest/features/admin/presentation/cubit/admin_categories_cubit.dart';
import 'package:harvest/features/admin/presentation/cubit/admin_categories_state.dart';
import 'package:harvest/features/admin/presentation/widgets/animated_list_item.dart';
import 'package:harvest/gen/i18n/strings.g.dart';

class AdminCategoriesPage extends StatelessWidget {
  const AdminCategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = sl<AdminCategoriesCubit>();
        unawaited(cubit.loadCategories());
        return cubit;
      },
      child: const _AdminCategoriesView(),
    );
  }
}

class _AdminCategoriesView extends StatelessWidget {
  const _AdminCategoriesView();

  @override
  Widget build(BuildContext context) {
    final i18n = t.admin;
    return Scaffold(
      body: BlocBuilder<AdminCategoriesCubit, AdminCategoriesState>(
        builder: (context, state) {
          if (state.status == AdminCategoriesStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == AdminCategoriesStatus.error) {
            return Center(child: Text(state.errorMessage ?? ''));
          }
          if (state.categories.isEmpty) {
            return Center(child: Text(i18n.noCategories));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.categories.length,
            itemBuilder: (context, index) {
              final category = state.categories[index];
              return AnimatedListItem(
                index: index,
                child: Card(
                  child: ListTile(
                    leading: category.imageUrl.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              category.imageUrl,
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) =>
                                  const Icon(Icons.category),
                            ),
                          )
                        : const Icon(Icons.category),
                    title: Text(category.name),
                    subtitle: Text('Sort: ${category.sortOrder}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => context.push(
                            AppRoutes.adminCategoryEditPath(category.id),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => _confirmDelete(
                            context,
                            category.id,
                            category.name,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.adminCategoryAdd),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _confirmDelete(BuildContext context, String id, String name) {
    unawaited(
      showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(t.admin.confirmDelete),
          content: Text(name),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(t.general.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                unawaited(
                  context.read<AdminCategoriesCubit>().deleteCategory(id),
                );
              },
              child: Text(
                t.general.delete,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
