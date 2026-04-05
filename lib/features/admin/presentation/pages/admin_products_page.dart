import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:harvest/app/di/injection_container.dart';
import 'package:harvest/app/routes/app_routes.dart';
import 'package:harvest/features/admin/presentation/cubit/admin_products_cubit.dart';
import 'package:harvest/features/admin/presentation/cubit/admin_products_state.dart';
import 'package:harvest/features/admin/presentation/widgets/animated_list_item.dart';
import 'package:harvest/gen/i18n/strings.g.dart';

class AdminProductsPage extends StatelessWidget {
  const AdminProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = sl<AdminProductsCubit>();
        unawaited(cubit.loadProducts());
        return cubit;
      },
      child: const _AdminProductsView(),
    );
  }
}

class _AdminProductsView extends StatelessWidget {
  const _AdminProductsView();

  @override
  Widget build(BuildContext context) {
    final i18n = t.admin;
    return Scaffold(
      body: BlocBuilder<AdminProductsCubit, AdminProductsState>(
        builder: (context, state) {
          if (state.status == AdminProductsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == AdminProductsStatus.error) {
            return Center(child: Text(state.errorMessage ?? ''));
          }
          if (state.products.isEmpty) {
            return Center(child: Text(i18n.noProducts));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.products.length,
            itemBuilder: (context, index) {
              final product = state.products[index];
              return AnimatedListItem(
                index: index,
                child: Card(
                  child: ListTile(
                    leading: product.imageUrl.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              product.imageUrl,
                              width: 56,
                              height: 56,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) =>
                                  const Icon(Icons.image_not_supported),
                            ),
                          )
                        : const Icon(Icons.inventory_2),
                    title: Text(product.name),
                    subtitle: Text(
                      'R\$ ${product.price.toStringAsFixed(2)}'
                      ' · ${product.unit}'
                      ' \u00b7 '
                      '${t.admin.stockLabel(count: product.stock.toString())}',
                    ),
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
                              AppRoutes.adminProductEditPath(product.id),
                            );
                            if (result == true && context.mounted) {
                              unawaited(
                                context
                                    .read<AdminProductsCubit>()
                                    .loadProducts(),
                              );
                            }
                          },
                        ),
                        IconButton(
                          icon: const FaIcon(
                            FontAwesomeIcons.trashCan,
                            size: 18,
                          ),
                          onPressed: () =>
                              _confirmDelete(context, product.id, product.name),
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
          final result = await context.push<bool>(AppRoutes.adminProductAdd);
          if (result == true && context.mounted) {
            unawaited(
              context.read<AdminProductsCubit>().loadProducts(),
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
    final cubit = context.read<AdminProductsCubit>();
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
                unawaited(cubit.deleteProduct(id));
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
