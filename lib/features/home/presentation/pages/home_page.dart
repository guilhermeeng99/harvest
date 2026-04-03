import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:harvest/app/di/injection_container.dart';
import 'package:harvest/app/routes/app_routes.dart';
import 'package:harvest/app/theme/app_colors.dart';
import 'package:harvest/app/theme/app_typography.dart';
import 'package:harvest/app/widgets/category_chip.dart';
import 'package:harvest/app/widgets/error_view.dart';
import 'package:harvest/app/widgets/loading_shimmer.dart';
import 'package:harvest/app/widgets/product_card.dart';
import 'package:harvest/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:harvest/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:harvest/features/home/presentation/bloc/home_bloc.dart';
import 'package:harvest/gen/i18n/strings.g.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HomeBloc>()..add(const HomeLoadRequested()),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state.status == HomeStatus.loading) {
              return const _LoadingView();
            }
            if (state.status == HomeStatus.error) {
              return ErrorView(
                message: state.errorMessage ?? t.general.error,
                onRetry: () => context
                    .read<HomeBloc>()
                    .add(const HomeLoadRequested()),
              );
            }
            return const _LoadedView();
          },
        ),
      ),
    );
  }
}

class _LoadedView extends StatelessWidget {
  const _LoadedView();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _Header()),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
        const SliverToBoxAdapter(child: _CategoriesSection()),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
        const SliverToBoxAdapter(child: _FeaturedSection()),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
        const _CategoryProductsGrid(),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final name = context.select<AuthBloc, String?>(
      (bloc) => bloc.state.user?.name,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.home.greeting(name: name ?? ''),
            style: AppTypography.headlineMedium,
          ),
          const SizedBox(height: 4),
          Text(
            t.home.subtitle,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.onBackgroundLight,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoriesSection extends StatelessWidget {
  const _CategoriesSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (prev, curr) =>
          prev.categories != curr.categories ||
          prev.selectedCategoryId != curr.selectedCategoryId,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                t.home.categories,
                style: AppTypography.titleLarge,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 44,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: state.categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, index) {
                  final category = state.categories[index];
                  return CategoryChip(
                    label: category.name,
                    isSelected:
                        state.selectedCategoryId == category.id,
                    onTap: () => context
                        .read<HomeBloc>()
                        .add(HomeCategorySelected(category.id)),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _FeaturedSection extends StatelessWidget {
  const _FeaturedSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (prev, curr) =>
          prev.featuredProducts != curr.featuredProducts,
      builder: (context, state) {
        if (state.featuredProducts.isEmpty) {
          return const SizedBox.shrink();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                t.home.featured,
                style: AppTypography.titleLarge,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 220,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: state.featuredProducts.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (_, index) {
                  final product = state.featuredProducts[index];
                  return SizedBox(
                    width: 170,
                    child: ProductCard(
                      name: product.name,
                      price: product.price,
                      unit: product.unit,
                      imageUrl: product.imageUrl,
                      farmName: product.farmName,
                      isOrganic: product.isOrganic,
                      onTap: () => context.push(
                        AppRoutes.productDetailsPath(product.id),
                      ),
                      onAddToCart: () => context
                          .read<CartBloc>()
                          .add(CartItemAdded(product)),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CategoryProductsGrid extends StatelessWidget {
  const _CategoryProductsGrid();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (prev, curr) =>
          prev.categoryProducts != curr.categoryProducts ||
          prev.categoryProductsStatus != curr.categoryProductsStatus,
      builder: (context, state) {
        if (state.selectedCategoryId == null) {
          return const SliverToBoxAdapter(child: SizedBox.shrink());
        }

        if (state.categoryProductsStatus == HomeStatus.loading) {
          return SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid.count(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.72,
              children: List.generate(
                4,
                (_) => const ProductCardShimmer(),
              ),
            ),
          );
        }

        if (state.categoryProducts.isEmpty) {
          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Text(
                  t.general.noResults,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.onBackgroundLight,
                  ),
                ),
              ),
            ),
          );
        }

        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverGrid.count(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.72,
            children: state.categoryProducts.map((product) {
              return ProductCard(
                name: product.name,
                price: product.price,
                unit: product.unit,
                imageUrl: product.imageUrl,
                farmName: product.farmName,
                isOrganic: product.isOrganic,
                onTap: () => context.push(
                  AppRoutes.productDetailsPath(product.id),
                ),
                onAddToCart: () =>
                    context.read<CartBloc>().add(CartItemAdded(product)),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          LoadingShimmer(width: 200, height: 28),
          SizedBox(height: 8),
          LoadingShimmer(width: 280, height: 16),
          SizedBox(height: 32),
          LoadingShimmer(width: 120, height: 20),
          SizedBox(height: 12),
          Row(
            children: [
              LoadingShimmer(width: 80, height: 40, borderRadius: 20),
              SizedBox(width: 8),
              LoadingShimmer(width: 80, height: 40, borderRadius: 20),
              SizedBox(width: 8),
              LoadingShimmer(width: 80, height: 40, borderRadius: 20),
            ],
          ),
          SizedBox(height: 32),
          LoadingShimmer(width: 160, height: 20),
          SizedBox(height: 12),
          Expanded(
            child: Row(
              children: [
                Expanded(child: ProductCardShimmer()),
                SizedBox(width: 12),
                Expanded(child: ProductCardShimmer()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
