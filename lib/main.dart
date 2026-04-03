import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:harvest/app/app_widget.dart';
import 'package:harvest/app/di/injection_container.dart';
import 'package:harvest/firebase_options.dart';
import 'package:harvest/gen/i18n/strings.g.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await LocaleSettings.useDeviceLocale();
  initDependencies();

  runApp(const HarvestApp());
}
