import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:harvest/app/routes/app_routes.dart';
import 'package:harvest/app/theme/app_colors.dart';
import 'package:harvest/app/theme/app_typography.dart';
import 'package:harvest/app/widgets/harvest_button.dart';
import 'package:harvest/app/widgets/harvest_text_field.dart';
import 'package:harvest/core/extensions/context_extensions.dart';
import 'package:harvest/core/utils/currency_formatter.dart';
import 'package:harvest/core/utils/validators.dart';
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
  final _formKey = GlobalKey<FormState>();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _zipController = TextEditingController();
  String _paymentMethod = 'Credit Card';

  @override
  void dispose() {
    _streetController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    super.dispose();
  }

  void _onPlaceOrder() {
    if (!_formKey.currentState!.validate()) return;

    context.read<CheckoutBloc>()
      ..add(
        CheckoutAddressUpdated(
          DeliveryAddress(
            street: _streetController.text.trim(),
            city: _cityController.text.trim(),
            zipCode: _zipController.text.trim(),
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.checkout.deliveryAddress,
                  style: AppTypography.titleLarge,
                ),
                const SizedBox(height: 16),
                HarvestTextField(
                  controller: _streetController,
                  label: t.checkout.street,
                  prefixIcon: const FaIcon(
                    FontAwesomeIcons.locationDot,
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (v) => Validators.required(v, fieldName: 'Street'),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: HarvestTextField(
                        controller: _cityController,
                        label: t.checkout.city,
                        textInputAction: TextInputAction.next,
                        validator: (v) =>
                            Validators.required(v, fieldName: 'City'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: HarvestTextField(
                        controller: _zipController,
                        label: t.checkout.zipCode,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        validator: (v) =>
                            Validators.required(v, fieldName: 'ZIP'),
                      ),
                    ),
                  ],
                ),
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
      ),
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
