import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:harvest/app/routes/app_routes.dart';
import 'package:harvest/app/theme/app_colors.dart';
import 'package:harvest/app/widgets/harvest_button.dart';
import 'package:harvest/features/onboarding/presentation/widgets/onboarding_page_indicator.dart';
import 'package:harvest/features/onboarding/presentation/widgets/onboarding_step.dart';
import 'package:harvest/features/onboarding/presentation/widgets/onboarding_step_content.dart';
import 'package:harvest/gen/i18n/strings.g.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _controller = PageController();
  int _currentPage = 0;

  static const List<Widget> _icons = [
    FaIcon(
      FontAwesomeIcons.basketShopping,
      size: 72,
      color: AppColors.primary,
    ),
    FaIcon(
      FontAwesomeIcons.tractor,
      size: 72,
      color: AppColors.primary,
    ),
    FaIcon(
      FontAwesomeIcons.truckFast,
      size: 72,
      color: AppColors.primary,
    ),
  ];

  List<OnboardingStep> get _steps => [
    OnboardingStep(
      icon: _icons[0],
      title: t.onboarding.step1.title,
      description: t.onboarding.step1.description,
    ),
    OnboardingStep(
      icon: _icons[1],
      title: t.onboarding.step2.title,
      description: t.onboarding.step2.description,
    ),
    OnboardingStep(
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
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemCount: _steps.length,
                itemBuilder: (_, index) =>
                    OnboardingStepContent(step: _steps[index]),
              ),
            ),
            OnboardingPageIndicator(
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
