import 'package:flutter/material.dart';
import 'package:harvest/app/theme/app_colors.dart';
import 'package:harvest/features/address/presentation/widgets/address_form.dart';
import 'package:harvest/gen/i18n/strings.g.dart';

class AddAddressPage extends StatelessWidget {
  const AddAddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(t.address.addTitle), centerTitle: true),
      body: const AddressForm(),
    );
  }
}
