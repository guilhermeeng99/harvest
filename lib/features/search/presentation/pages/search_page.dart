import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:harvest/app/di/injection_container.dart';
import 'package:harvest/app/routes/app_routes.dart';
import 'package:harvest/app/theme/app_colors.dart';
import 'package:harvest/app/theme/app_typography.dart';
import 'package:harvest/app/widgets/error_view.dart';
import 'package:harvest/app/widgets/loading_shimmer.dart';
import 'package:harvest/app/widgets/product_card.dart';
import 'package:harvest/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:harvest/features/search/presentation/cubit/search_cubit.dart';
import 'package:harvest/gen/i18n/strings.g.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SearchCubit>(),
      child: const _SearchView(),
    );
  }
}

class _SearchView extends StatefulWidget {
  const _SearchView();

  @override
  State<_SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<_SearchView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: TextField(
                controller: _searchController,
                onSubmitted: (query) =>
                    context.read<SearchCubit>().search(query),
                decoration: InputDecoration(
                  hintText: t.search.hint,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: BlocBuilder<SearchCubit, SearchState>(
                    builder: (context, state) {
                      if (state.query.isEmpty) return const SizedBox.shrink();
                      return IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _searchController.clear();
                          context.read<SearchCubit>().search('');
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            _FilterBar(),
            const SizedBox(height: 8),
            Expanded(
              child: BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  if (state.status == SearchStatus.initial) {
                    return _EmptySearch();
                  }
                  if (state.status == SearchStatus.loading) {
                    return const _LoadingGrid();
                  }
                  if (state.status == SearchStatus.error) {
                    return ErrorView(
                      message: state.errorMessage ?? t.general.error,
                      onRetry: () =>
                          context.read<SearchCubit>().search(state.query),
                    );
                  }
                  if (state.results.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.search_off,
                            size: 64,
                            color: AppColors.onBackgroundLight,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            t.general.noResults,
                            style: AppTypography.bodyLarge.copyWith(
                              color: AppColors.onBackgroundLight,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return _ResultsGrid(state: state);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      buildWhen: (prev, curr) =>
          prev.organicOnly != curr.organicOnly ||
          prev.hasActiveFilters != curr.hasActiveFilters,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              FilterChip(
                label: Text(t.search.organicOnly),
                selected: state.organicOnly,
                onSelected: (value) => context
                    .read<SearchCubit>()
                    .updateFilters(organicOnly: value),
              ),
              const Spacer(),
              if (state.hasActiveFilters)
                TextButton(
                  onPressed: () => context.read<SearchCubit>().clearFilters(),
                  child: Text(t.search.clearFilters),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _ResultsGrid extends StatelessWidget {
  const _ResultsGrid({required this.state});

  final SearchState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            t.search.resultsFor(query: state.query),
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.onBackgroundLight,
            ),
          ),
        ),
        const SizedBox(height: 12),
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

class _EmptySearch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.search,
            size: 64,
            color: AppColors.onBackgroundLight,
          ),
          const SizedBox(height: 16),
          Text(
            t.search.hint,
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.onBackgroundLight,
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingGrid extends StatelessWidget {
  const _LoadingGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.72,
      ),
      itemCount: 6,
      itemBuilder: (_, __) => const ProductCardShimmer(),
    );
  }
}
