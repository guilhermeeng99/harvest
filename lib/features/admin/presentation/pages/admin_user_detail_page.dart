import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:harvest/app/di/injection_container.dart';
import 'package:harvest/app/theme/app_colors.dart';
import 'package:harvest/app/theme/app_typography.dart';
import 'package:harvest/features/address/domain/entities/address_entity.dart';
import 'package:harvest/features/admin/domain/repositories/admin_repository.dart';
import 'package:harvest/features/auth/domain/entities/user_entity.dart';
import 'package:harvest/features/checkout/domain/entities/order_entity.dart';
import 'package:harvest/gen/i18n/strings.g.dart';
import 'package:intl/intl.dart';

class AdminUserDetailPage extends StatefulWidget {
  const AdminUserDetailPage({required this.user, super.key});

  final UserEntity user;

  @override
  State<AdminUserDetailPage> createState() => _AdminUserDetailPageState();
}

class _AdminUserDetailPageState extends State<AdminUserDetailPage> {
  final AdminRepository _repo = sl<AdminRepository>();

  List<AddressEntity> _addresses = [];
  List<OrderEntity> _orders = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    unawaited(_loadData());
  }

  Future<void> _loadData() async {
    final results = await Future.wait([
      _repo.getUserAddresses(widget.user.id),
      _repo.getUserOrders(widget.user.id),
    ]);

    if (!mounted) return;

    results[0].fold(
      (_) {},
      (data) => _addresses = data as List<AddressEntity>,
    );
    results[1].fold(
      (_) {},
      (data) => _orders = data as List<OrderEntity>,
    );

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.user.name ?? widget.user.email)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _UserInfoCard(user: widget.user),
                      const SizedBox(height: 24),
                      _AddressesSection(addresses: _addresses),
                      const SizedBox(height: 24),
                      _OrdersSection(orders: _orders),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

class _UserInfoCard extends StatelessWidget {
  const _UserInfoCard({required this.user});

  final UserEntity user;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: user.photoUrl != null
                  ? NetworkImage(user.photoUrl!)
                  : null,
              backgroundColor: AppColors.primaryLight.withValues(alpha: 0.2),
              child: user.photoUrl == null
                  ? Text(
                      (user.name ?? user.email)[0].toUpperCase(),
                      style: AppTypography.headlineMedium.copyWith(
                        color: AppColors.primary,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (user.name != null)
                    Text(user.name!, style: AppTypography.titleLarge),
                  const SizedBox(height: 4),
                  Text(
                    user.email,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.onBackgroundLight,
                    ),
                  ),
                  const SizedBox(height: 4),
                  SelectableText(
                    'ID: ${user.id}',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.onBackgroundLight,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddressesSection extends StatelessWidget {
  const _AddressesSection({required this.addresses});

  final List<AddressEntity> addresses;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const FaIcon(FontAwesomeIcons.locationDot, size: 18),
            const SizedBox(width: 8),
            Text(t.address.title, style: AppTypography.titleMedium),
            const SizedBox(width: 8),
            Text(
              '(${addresses.length})',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.onBackgroundLight,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (addresses.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Center(child: Text(t.address.empty)),
            ),
          )
        else
          ...addresses.map(
            (address) => Card(
              child: ListTile(
                leading: const FaIcon(FontAwesomeIcons.house, size: 16),
                title: Text(
                  address.label ?? address.shortAddress,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  '${address.street}, ${address.number}'
                  '${address.complement != null
                      ? ' - ${address.complement}'
                      : ''}\n'
                  '${address.neighborhood} - '
                  '${address.city}/${address.state}\n'
                  'CEP: ${address.zipCode}',
                ),
                isThreeLine: true,
                trailing: address.isDefault
                    ? Chip(
                        label: Text(
                          t.address.setAsDefault,
                          style: AppTypography.labelSmall.copyWith(
                            fontSize: 10,
                          ),
                        ),
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      )
                    : null,
              ),
            ),
          ),
      ],
    );
  }
}

class _OrdersSection extends StatelessWidget {
  const _OrdersSection({required this.orders});

  final List<OrderEntity> orders;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const FaIcon(FontAwesomeIcons.receipt, size: 18),
            const SizedBox(width: 8),
            Text(t.orders.title, style: AppTypography.titleMedium),
            const SizedBox(width: 8),
            Text(
              '(${orders.length})',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.onBackgroundLight,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (orders.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Center(child: Text(t.orders.empty)),
            ),
          )
        else
          ...orders.map(
            (order) => Card(
              child: ExpansionTile(
                leading: _statusIcon(order.status),
                title: Text(
                  t.orders.orderNumber(
                    number: order.id.substring(0, 8),
                  ),
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  '${DateFormat.yMd().format(order.createdAt)}'
                  ' \u2022 ${order.status.name}'
                  ' \u2022 R\$ '
                  '${order.totalAmount.toStringAsFixed(2)}',
                  style: AppTypography.bodySmall,
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(),
                        ...order.items.map(
                          (item) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    '${item.quantity}x ${item.name}',
                                    style: AppTypography.bodySmall,
                                  ),
                                ),
                                Text(
                                  'R\$ ${item.totalPrice.toStringAsFixed(2)}',
                                  style: AppTypography.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              t.cart.total,
                              style: AppTypography.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'R\$ ${order.totalAmount.toStringAsFixed(2)}',
                              style: AppTypography.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${order.deliveryAddress.street}, '
                          '${order.deliveryAddress.city} - '
                          '${order.deliveryAddress.zipCode}',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.onBackgroundLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _statusIcon(OrderStatus status) {
    final (FaIconData icon, Color color) = switch (status) {
      OrderStatus.pending => (FontAwesomeIcons.clock, Colors.orange),
      OrderStatus.confirmed => (FontAwesomeIcons.check, Colors.blue),
      OrderStatus.harvesting => (FontAwesomeIcons.leaf, AppColors.primary),
      OrderStatus.delivering => (FontAwesomeIcons.truck, Colors.indigo),
      OrderStatus.delivered => (
        FontAwesomeIcons.circleCheck,
        AppColors.success,
      ),
      OrderStatus.cancelled => (FontAwesomeIcons.xmark, Colors.red),
    };
    return FaIcon(icon, size: 18, color: color);
  }
}
