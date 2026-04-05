import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:harvest/app/theme/app_typography.dart';
import 'package:harvest/core/extensions/context_extensions.dart';
import 'package:harvest/features/home/domain/entities/category_entity.dart';
import 'package:harvest/features/search/presentation/cubit/search_cubit.dart';
import 'package:harvest/gen/i18n/strings.g.dart';

class SearchCategoriesGrid extends StatelessWidget {
  const SearchCategoriesGrid({required this.categories, super.key});

  final List<CategoryEntity> categories;

  static const _colors = [
    Color(0xFF2D6A4F),
    Color(0xFFE76F51),
    Color(0xFF264653),
    Color(0xFFF4A261),
    Color(0xFF606C38),
    Color(0xFFBC6C25),
    Color(0xFF457B9D),
    Color(0xFF9B2226),
    Color(0xFF386641),
    Color(0xFFDDA15E),
  ];

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
            child: Text(
              t.search.browseCategories,
              style: AppTypography.headlineSmall,
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final category = categories[index];
                final color = _colors[index % _colors.length];
                return _CategoryCard(
                  category: category,
                  color: color,
                  onTap: () =>
                      context.read<SearchCubit>().browseCategory(category.id),
                );
              },
              childCount: categories.length,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: context.isMobile
                  ? 2
                  : context.isTablet
                  ? 3
                  : 6,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.65,
            ),
          ),
        ),
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.category,
    required this.color,
    required this.onTap,
  });

  final CategoryEntity category;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: 88,
              child: CachedNetworkImage(
                imageUrl: category.imageUrl,
                fit: BoxFit.cover,
                placeholder: (_, _) => ColoredBox(
                  color: Colors.white.withValues(alpha: 0.15),
                ),
                errorWidget: (_, _, _) => ColoredBox(
                  color: Colors.white.withValues(alpha: 0.15),
                  child: const FaIcon(
                    FontAwesomeIcons.leaf,
                    color: Colors.white70,
                    size: 28,
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withValues(alpha: 0.4)],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  category.name,
                  style: AppTypography.titleLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
