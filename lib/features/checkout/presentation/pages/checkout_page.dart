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
import 'package:harvest/features/checkout/presentation/widgets/checkout_address_section.dart';
import 'package:harvest/features/checkout/presentation/widgets/checkout_payment_option.dart';
import 'package:harvest/features/checkout/presentation/widgets/checkout_summary_row.dart';
import 'package:harvest/features/orders/presentation/bloc/orders_bloc.dart';
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
            context.read<OrdersBloc>().add(const OrdersRefreshRequested());
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
              const CheckoutAddressSection(),
              const SizedBox(height: 28),
              Text(t.checkout.paymentMethod, style: AppTypography.titleLarge),
              const SizedBox(height: 12),
              CheckoutPaymentOption(
                label: t.checkout.creditCard,
                icon: const FaIcon(
                  FontAwesomeIcons.creditCard,
                  color: AppColors.onBackground,
                ),
                isSelected: _paymentMethod == 'Credit Card',
                onTap: () => setState(() => _paymentMethod = 'Credit Card'),
              ),
              const SizedBox(height: 8),
              CheckoutPaymentOption(
                label: t.checkout.applePay,
                icon: const FaIcon(
                  FontAwesomeIcons.apple,
                  color: AppColors.onBackground,
                ),
                isSelected: _paymentMethod == 'Apple Pay',
                onTap: () => setState(() => _paymentMethod = 'Apple Pay'),
              ),
              const SizedBox(height: 8),
              CheckoutPaymentOption(
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
                      CheckoutSummaryRow(
                        label: t.cart.subtotal,
                        value: CurrencyFormatter.format(cartState.subtotal),
                      ),
                      const SizedBox(height: 4),
                      CheckoutSummaryRow(
                        label: t.cart.deliveryFee,
                        value: cartState.deliveryFee == 0
                            ? t.cart.free
                            : CurrencyFormatter.format(cartState.deliveryFee),
                      ),
                      const Divider(height: 20),
                      CheckoutSummaryRow(
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
