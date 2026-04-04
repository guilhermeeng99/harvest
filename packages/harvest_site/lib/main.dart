import 'package:flutter/material.dart';
import 'package:harvest_site/router/site_router.dart';
import 'package:harvest_site/theme/site_theme.dart';

void main() {
  runApp(const HarvestSiteApp());
}

class HarvestSiteApp extends StatelessWidget {
  const HarvestSiteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Harvest - Fresh from the Farm',
      theme: SiteTheme.light,
      routerConfig: siteRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
