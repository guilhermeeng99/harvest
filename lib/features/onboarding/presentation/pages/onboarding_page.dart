import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:harvest/app/routes/app_routes.dart';
import 'package:harvest/app/theme/app_colors.dart';
import 'package:harvest/app/theme/app_typography.dart';
import 'package:harvest/app/widgets/harvest_button.dart';
import 'package:harvest/gen/i18n/strings.g.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _controller = PageController();
  int _currentPage = 0;

  static const _icons = [
    Icons.shopping_basket_outlined,
    Icons.agriculture_outlined,
    Icons.local_shipping_outlined,
  ];

  List<_OnboardingStep> get _steps => [
        _OnboardingStep(
          icon: _icons[0],
          title: t.onboarding.step1.title,
          description: t.onboarding.step1.description,
        ),
        _OnboardingStep(
          icon: _icons[1],
          title: t.onboarding.step2.title,
          description: t.onboarding.step2.description,
        ),
        _OnboardingStep(
          icon: _icons[2],
          title: t.onboarding.step3.title,
          description: t.onboarding.step3.description,
        ),
      ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () => context.go(AppRoutes.signIn),
                child: Text(t.general.skip),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (index) =>
                    setState(() => _currentPage = index),
                itemCount: _steps.length,
                itemBuilder: (_, index) {
                  final step = _steps[index];
                  return _StepContent(step: step);
                },
              ),
            ),
            _PageIndicator(
              count: _steps.length,
              current: _currentPage,
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: _currentPage == _steps.length - 1
                  ? HarvestButton(
                      label: t.onboarding.getStarted,
                      onPressed: () => context.go(AppRoutes.signIn),
                      width: double.infinity,
                    )
                  : HarvestButton(
                      label: t.general.next,
                      onPressed: () => _controller.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      ),
                      width: double.infinity,
                    ),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}

class _OnboardingStep {
  const _OnboardingStep({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;
}

class _StepContent extends StatelessWidget {
  const _StepContent({required this.step});

  final _OnboardingStep step;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              step.icon,
              size: 80,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 48),
          Text(
            step.title,
            style: AppTypography.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            step.description,
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.onBackgroundLight,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({required this.count, required this.current});

  final int count;
  final int current;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 28 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : AppColors.divider,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
