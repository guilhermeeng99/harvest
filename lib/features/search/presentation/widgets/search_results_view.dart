import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:harvest/app/routes/app_routes.dart';
import 'package:harvest/app/theme/app_colors.dart';
import 'package:harvest/app/theme/app_typography.dart';
import 'package:harvest/app/widgets/product_card.dart';
import 'package:harvest/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:harvest/features/search/presentation/cubit/search_cubit.dart';
import 'package:harvest/gen/i18n/strings.g.dart';

class SearchResultsView extends StatelessWidget {
  const SearchResultsView({
    required this.state,
    required this.onClearAll,
    super.key,
  });

  final SearchState state;
  final VoidCallback onClearAll;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                if (state.selectedCategoryName != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: InputChip(
                      label: Text(state.selectedCategoryName!),
                      onDeleted: onClearAll,
                      backgroundColor: AppColors.primaryLight.withValues(
                        alpha: 0.15,
                      ),
                      deleteIconColor: AppColors.primary,
                      side: BorderSide.none,
                    ),
                  ),
                FilterChip(
                  label: Text(t.search.organicOnly),
                  selected: state.organicOnly,
                  onSelected: (value) => context
                      .read<SearchCubit>()
                      .updateFilters(organicOnly: value),
                ),
                if (state.hasActiveFilters)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: TextButton(
                      onPressed: () {
                        context.read<SearchCubit>().clearFilters();
                      },
                      child: Text(t.search.clearFilters),
                    ),
                  ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
          child: Text(
            state.query.isNotEmpty
                ? t.search.resultsFor(query: state.query)
                : t.search.productsIn(
                    category: state.selectedCategoryName ?? '',
                  ),
            style: AppTypography.bodySmall,
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.72,
            ),
            itemCount: state.results.length,
            itemBuilder: (_, index) {
              final product = state.results[index];
              return ProductCard(
                name: product.name,
                price: product.price,
                unit: product.unit,
                imageUrl: product.imageUrl,
                farmName: product.farmName,
                isOrganic: product.isOrganic,
                onTap: () =>
                    context.push(AppRoutes.productDetailsPath(product.id)),
                onAddToCart: () =>
                    context.read<CartBloc>().add(CartItemAdded(product)),
              );
            },
          ),
        ),
      ],
    );
  }
}
