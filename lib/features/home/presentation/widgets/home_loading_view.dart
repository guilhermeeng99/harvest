import 'package:flutter/material.dart';
import 'package:harvest/app/widgets/loading_shimmer.dart';

class HomeLoadingView extends StatelessWidget {
  const HomeLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16),
          Row(
            children: [
              LoadingShimmer(width: 44, height: 44, borderRadius: 22),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LoadingShimmer(width: 160, height: 18),
                    SizedBox(height: 6),
                    LoadingShimmer(width: 200, height: 14),
                  ],
                ),
              ),
              LoadingShimmer(width: 44, height: 44, borderRadius: 22),
            ],
          ),
          SizedBox(height: 16),
          LoadingShimmer(width: double.infinity, height: 50, borderRadius: 16),
          SizedBox(height: 20),
          LoadingShimmer(width: double.infinity, height: 150, borderRadius: 20),
          SizedBox(height: 24),
          LoadingShimmer(width: 120, height: 20),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _CategoryShimmer(),
              _CategoryShimmer(),
              _CategoryShimmer(),
              _CategoryShimmer(),
            ],
          ),
          SizedBox(height: 24),
          LoadingShimmer(width: 160, height: 20),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: ProductCardShimmer()),
              SizedBox(width: 12),
              Expanded(child: ProductCardShimmer()),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryShimmer extends StatelessWidget {
  const _CategoryShimmer();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        LoadingShimmer(width: 64, height: 64, borderRadius: 32),
        SizedBox(height: 6),
        LoadingShimmer(width: 48, height: 12),
      ],
    );
  }
}
