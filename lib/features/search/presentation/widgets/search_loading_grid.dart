import 'package:flutter/material.dart';
import 'package:harvest/app/widgets/loading_shimmer.dart';

class SearchLoadingGrid extends StatelessWidget {
  const SearchLoadingGrid({super.key});

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
      itemBuilder: (_, _) => const ProductCardShimmer(),
    );
  }
}
