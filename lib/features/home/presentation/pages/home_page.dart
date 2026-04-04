import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harvest/app/di/injection_container.dart';
import 'package:harvest/app/theme/app_colors.dart';
import 'package:harvest/app/widgets/error_view.dart';
import 'package:harvest/features/home/presentation/bloc/home_bloc.dart';
import 'package:harvest/features/home/presentation/widgets/home_all_products_grid.dart';
import 'package:harvest/features/home/presentation/widgets/home_categories_grid.dart';
import 'package:harvest/features/home/presentation/widgets/home_featured_section.dart';
import 'package:harvest/features/home/presentation/widgets/home_header.dart';
import 'package:harvest/features/home/presentation/widgets/home_loading_view.dart';
import 'package:harvest/features/home/presentation/widgets/home_popular_section.dart';
import 'package:harvest/features/home/presentation/widgets/promo_banner.dart';
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
              return const HomeLoadingView();
            }
            if (state.status == HomeStatus.error) {
              return ErrorView(
                message: state.errorMessage ?? t.general.error,
                onRetry: () =>
                    context.read<HomeBloc>().add(const HomeLoadRequested()),
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
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        context.read<HomeBloc>().add(const HomeLoadRequested());
        await context.read<HomeBloc>().stream.firstWhere(
          (state) => state.status != HomeStatus.loading,
        );
      },
      child: const CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: HomeHeader()),
          SliverToBoxAdapter(child: SizedBox(height: 20)),
          SliverToBoxAdapter(child: PromoBanner()),
          SliverToBoxAdapter(child: SizedBox(height: 24)),
          SliverToBoxAdapter(child: HomeCategoriesGrid()),
          SliverToBoxAdapter(child: SizedBox(height: 24)),
          SliverToBoxAdapter(child: HomeFeaturedSection()),
          SliverToBoxAdapter(child: SizedBox(height: 24)),
          SliverToBoxAdapter(child: HomePopularSection()),
          SliverToBoxAdapter(child: SizedBox(height: 24)),
          SliverToBoxAdapter(child: HomeAllProductsHeader()),
          SliverToBoxAdapter(child: SizedBox(height: 12)),
          HomeAllProductsGrid(),
          SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}
