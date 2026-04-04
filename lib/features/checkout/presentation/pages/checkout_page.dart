import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:harvest/app/routes/app_routes.dart';
import 'package:harvest/app/theme/app_colors.dart';
import 'package:harvest/app/theme/app_typography.dart';
import 'package:harvest/app/widgets/harvest_button.dart';
import 'package:harvest/core/extensions/context_extensions.dart';
import 'package:harvest/core/utils/currency_formatter.dart';
import 'package:harvest/features/address/presentation/cubit/address_cubit.dart';
import 'package:harvest/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:harvest/features/checkout/domain/entities/order_entity.dart';
import 'package:harvest/features/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:harvest/gen/i18n/strings.g.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String _paymentMethod = 'Credit Card';

  void _onPlaceOrder() {
    final selectedAddress = context.read<AddressCubit>().state.selectedAddress;

    if (selectedAddress == null) {
      context.showErrorSnackBar(t.checkout.selectAddressError);
      return;
    }

    context.read<CheckoutBloc>()
      ..add(
        CheckoutAddressUpdated(
          DeliveryAddress(
            street: '${selectedAddress.street}, ${selectedAddress.number}',
            city: selectedAddress.city,
            zipCode: selectedAddress.zipCode,
          ),
        ),
      )
      ..add(CheckoutPaymentMethodUpdated(_paymentMethod))
      ..add(CheckoutSubmitted(context.read<CartBloc>().state.items));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(t.checkout.title),
        centerTitle: true,
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.arrowLeft, size: 18),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocListener<CheckoutBloc, CheckoutState>(
        listener: (context, state) {
          if (state.status == CheckoutStatus.success) {
            context.read<CartBloc>().add(const CartCleared());
            context.go(AppRoutes.orderConfirmation);
          }
          if (state.status == CheckoutStatus.error &&
              state.errorMessage != null) {
            context.showErrorSnackBar(state.errorMessage!);
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                t.checkout.deliveryAddress,
                style: AppTypography.titleLarge,
              ),
              const SizedBox(height: 16),
              const _AddressSection(),
              const SizedBox(height: 28),
              Text(t.checkout.paymentMethod, style: AppTypography.titleLarge),
              const SizedBox(height: 12),
              _PaymentOption(
                label: t.checkout.creditCard,
                icon: const FaIcon(
                  FontAwesomeIcons.creditCard,
                  color: AppColors.onBackground,
                ),
                isSelected: _paymentMethod == 'Credit Card',
                onTap: () => setState(() => _paymentMethod = 'Credit Card'),
              ),
              const SizedBox(height: 8),
              _PaymentOption(
                label: t.checkout.applePay,
                icon: const FaIcon(
                  FontAwesomeIcons.apple,
                  color: AppColors.onBackground,
                ),
                isSelected: _paymentMethod == 'Apple Pay',
                onTap: () => setState(() => _paymentMethod = 'Apple Pay'),
              ),
              const SizedBox(height: 8),
              _PaymentOption(
                label: t.checkout.googlePay,
                icon: const FaIcon(
                  FontAwesomeIcons.googlePay,
                  color: AppColors.onBackground,
                ),
                isSelected: _paymentMethod == 'Google Pay',
                onTap: () => setState(() => _paymentMethod = 'Google Pay'),
              ),
              const SizedBox(height: 28),
              Text(t.checkout.orderSummary, style: AppTypography.titleLarge),
              const SizedBox(height: 12),
              BlocBuilder<CartBloc, CartState>(
                builder: (context, cartState) {
                  return Column(
                    children: [
                      _SummaryRow(
                        label: t.cart.subtotal,
                        value: CurrencyFormatter.format(cartState.subtotal),
                      ),
                      const SizedBox(height: 4),
                      _SummaryRow(
                        label: t.cart.deliveryFee,
                        value: cartState.deliveryFee == 0
                            ? t.cart.free
                            : CurrencyFormatter.format(cartState.deliveryFee),
                      ),
                      const Divider(height: 20),
                      _SummaryRow(
                        label: t.cart.total,
                        value: CurrencyFormatter.format(cartState.total),
                        isBold: true,
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
              BlocBuilder<CheckoutBloc, CheckoutState>(
                builder: (context, state) {
                  return HarvestButton(
                    label: t.checkout.placeOrder,
                    onPressed: _onPlaceOrder,
                    isLoading: state.status == CheckoutStatus.loading,
                    width: double.infinity,
                  );
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddressSection extends StatelessWidget {
  const _AddressSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddressCubit, AddressState>(
      builder: (context, state) {
        if (state.status == AddressStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        final address = state.selectedAddress;

        if (address == null) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.divider),
            ),
            child: Column(
              children: [
                const FaIcon(
                  FontAwesomeIcons.locationDot,
                  size: 32,
                  color: AppColors.onBackgroundLight,
                ),
                const SizedBox(height: 12),
                Text(
                  t.checkout.noAddress,
                  style: AppTypography.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  t.checkout.noAddressSubtitle,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.onBackgroundLight,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                HarvestButton(
                  label: t.checkout.addAddress,
                  onPressed: () => context.push(AppRoutes.addressAdd),
                ),
              ],
            ),
          );
        }

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.divider),
          ),
          child: Row(
            children: [
              const FaIcon(
                FontAwesomeIcons.locationDot,
                size: 20,
                color: AppColors.primary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (address.label != null)
                      Text(
                        address.label!,
                        style: AppTypography.titleMedium,
                      ),
                    Text(
                      address.shortAddress,
                      style: AppTypography.bodyMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${address.city}, ${address.state} - ${address.zipCode}',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.onBackgroundLight,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () => context.push(AppRoutes.addresses),
                child: Text(
                  t.checkout.changeAddress,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PaymentOption extends StatelessWidget {
  const _PaymentOption({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final Widget icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 12),
            Text(label, style: AppTypography.bodyLarge),
            const Spacer(),
            if (isSelected)
              const FaIcon(
                FontAwesomeIcons.circleCheck,
                color: AppColors.primary,
              ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  final String label;
  final String value;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isBold
              ? AppTypography.titleMedium
              : AppTypography.bodyMedium.copyWith(
                  color: AppColors.onBackgroundLight,
                ),
        ),
        Text(
          value,
          style: isBold ? AppTypography.priceMedium : AppTypography.bodyMedium,
        ),
      ],
    );
  }
}
