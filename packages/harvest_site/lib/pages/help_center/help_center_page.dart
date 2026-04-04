import 'package:flutter/material.dart';
import 'package:harvest_site/pages/help_center/data/faq_data.dart';
import 'package:harvest_site/pages/help_center/widgets/faq_section.dart';
import 'package:harvest_site/pages/help_center/widgets/help_hero.dart';
import 'package:harvest_site/router/site_router.dart';
import 'package:harvest_site/theme/site_colors.dart';
import 'package:harvest_site/widgets/site_footer.dart';
import 'package:harvest_site/widgets/site_header.dart';

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width > 900;

    return Scaffold(
      backgroundColor: SiteColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SiteHeader(activeRoute: SiteRoutes.help),
            const HelpHero(),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 120 : 24,
                vertical: 64,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0; i < faqSections.length; i++) ...[
                    if (i > 0) const SizedBox(height: 48),
                    FaqSection(
                      title: faqSections[i].title,
                      icon: faqSections[i].icon,
                      items: faqSections[i].items,
                    ),
                  ],
                ],
              ),
            ),
            const SiteFooter(),
          ],
        ),
      ),
    );
  }
}
