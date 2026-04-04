import 'package:flutter/material.dart';

class OnboardingStep {
  const OnboardingStep({
    required this.icon,
    required this.title,
    required this.description,
  });

  final Widget icon;
  final String title;
  final String description;
}
