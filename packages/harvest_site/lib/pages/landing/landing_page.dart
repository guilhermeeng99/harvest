import 'package:flutter/material.dart';
import 'package:harvest_site/pages/landing/widgets/cta_section.dart';
import 'package:harvest_site/pages/landing/widgets/features_section.dart';
import 'package:harvest_site/pages/landing/widgets/hero_section.dart';
import 'package:harvest_site/pages/landing/widgets/how_it_works_section.dart';
import 'package:harvest_site/router/site_router.dart';
import 'package:harvest_site/theme/site_colors.dart';
import 'package:harvest_site/widgets/site_footer.dart';
import 'package:harvest_site/widgets/site_header.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: SiteColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SiteHeader(activeRoute: SiteRoutes.home),
            HeroSection(),
            FeaturesSection(),
            HowItWorksSection(),
            CtaSection(),
            SiteFooter(),
          ],
        ),
      ),
    );
  }
}
