import 'package:flutter/material.dart';

class SectionContainer extends StatelessWidget {
  const SectionContainer({
    required this.child,
    this.color,
    this.padding,
    super.key,
  });

  final Widget child;
  final Color? color;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width > 900;

    return Container(
      width: double.infinity,
      color: color,
      padding:
          padding ??
          EdgeInsets.symmetric(horizontal: isDesktop ? 80 : 24, vertical: 80),
      child: child,
    );
  }
}
