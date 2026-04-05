import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:harvest/app/theme/app_colors.dart';

class StartupAnimatedIcons extends StatefulWidget {
  const StartupAnimatedIcons({required this.progress, super.key});

  final double progress;

  @override
  State<StartupAnimatedIcons> createState() => _StartupAnimatedIconsState();
}

class _StartupAnimatedIconsState extends State<StartupAnimatedIcons>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  static const _icons = [
    '🍎',
    '🥦',
    '🥕',
    '🍊',
    '🫐',
    '🥬',
    '🍋',
    '🍇',
    '🌽',
    '🥑',
    '🍓',
    '🥝',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );
    unawaited(_controller.repeat());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final visibleCount = (widget.progress * _icons.length).ceil().clamp(
          1,
          _icons.length,
        );
        return SizedBox(
          height: 120,
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            runSpacing: 12,
            children: List.generate(visibleCount, (index) {
              final delay = index / _icons.length;
              final wave = math.sin(
                (_controller.value + delay) * 2 * math.pi,
              );
              return Transform.translate(
                offset: Offset(0, wave * 4),
                child: AnimatedOpacity(
                  opacity: index < visibleCount ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 400),
                  child: Text(
                    _icons[index],
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}

class StartupProgressBar extends StatelessWidget {
  const StartupProgressBar({required this.progress, super.key});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            height: 8,
            width: double.infinity,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                AnimatedFractionallySizedBox(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOut,
                  widthFactor: progress.clamp(0, 1),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryLight],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
