import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const FaIcon(
                            FontAwesomeIcons.penToSquare,
                            size: 18,
                          ),
                          onPressed: () async {
                            final result = await context.push<bool>(
                              AppRoutes.adminCategoryEditPath(category.id),
                            );
                            if (result == true && context.mounted) {
                              unawaited(
                                context
                                    .read<AdminCategoriesCubit>()
                                    .loadCategories(),
                              );
                            }
                          },
                        ),
                        IconButton(
                          icon: const FaIcon(
                            FontAwesomeIcons.trashCan,
                            size: 18,
                          ),
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
        onPressed: () async {
          final result = await context.push<bool>(AppRoutes.adminCategoryAdd);
          if (result == true && context.mounted) {
            unawaited(
              context.read<AdminCategoriesCubit>().loadCategories(),
            );
          }
        },
        child: const FaIcon(
          FontAwesomeIcons.plus,
          size: 20,
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, String id, String name) {
    final cubit = context.read<AdminCategoriesCubit>();
    unawaited(
      showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(t.admin.confirmDelete),
          content: Text(name),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(t.general.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                unawaited(cubit.deleteCategory(id));
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
