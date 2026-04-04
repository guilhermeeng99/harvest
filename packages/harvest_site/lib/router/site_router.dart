import 'package:go_router/go_router.dart';
import 'package:harvest_site/pages/help_center/help_center_page.dart';
import 'package:harvest_site/pages/landing/landing_page.dart';

abstract final class SiteRoutes {
  static const String home = '/';
  static const String help = '/help';
}

final siteRouter = GoRouter(
  routes: [
    GoRoute(path: SiteRoutes.home, builder: (_, _) => const LandingPage()),
    GoRoute(path: SiteRoutes.help, builder: (_, _) => const HelpCenterPage()),
  ],
);
