import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:harvest/app/theme/app_colors.dart';
import 'package:harvest/features/checkout/domain/entities/order_entity.dart';
import 'package:harvest/gen/i18n/strings.g.dart';

extension OrderStatusX on OrderStatus {
  Color get color {
    return switch (this) {
      OrderStatus.pending => AppColors.warning,
      OrderStatus.confirmed => AppColors.primaryLight,
      OrderStatus.harvesting => AppColors.primary,
      OrderStatus.delivering => AppColors.secondary,
      OrderStatus.delivered => AppColors.success,
      OrderStatus.cancelled => AppColors.error,
    };
  }

  String get label {
    return switch (this) {
      OrderStatus.pending => t.orders.status.pending,
      OrderStatus.confirmed => t.orders.status.confirmed,
      OrderStatus.harvesting => t.orders.status.harvesting,
      OrderStatus.delivering => t.orders.status.delivering,
      OrderStatus.delivered => t.orders.status.delivered,
      OrderStatus.cancelled => t.orders.status.cancelled,
    };
  }

  FaIconData get icon {
    return switch (this) {
      OrderStatus.pending => FontAwesomeIcons.clock,
      OrderStatus.confirmed => FontAwesomeIcons.circleCheck,
      OrderStatus.harvesting => FontAwesomeIcons.seedling,
      OrderStatus.delivering => FontAwesomeIcons.truck,
      OrderStatus.delivered => FontAwesomeIcons.check,
      OrderStatus.cancelled => FontAwesomeIcons.ban,
    };
  }
}
