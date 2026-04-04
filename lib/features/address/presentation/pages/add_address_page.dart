import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:harvest/app/theme/app_colors.dart';
import 'package:harvest/app/widgets/harvest_button.dart';
import 'package:harvest/app/widgets/harvest_text_field.dart';
import 'package:harvest/features/address/domain/entities/address_entity.dart';
import 'package:harvest/features/address/presentation/cubit/address_cubit.dart';
import 'package:harvest/gen/i18n/strings.g.dart';

class AddAddressPage extends StatefulWidget {
  const AddAddressPage({super.key});

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  final _formKey = GlobalKey<FormState>();
  final _labelController = TextEditingController();
  final _streetController = TextEditingController();
  final _numberController = TextEditingController();
  final _neighborhoodController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipCodeController = TextEditingController();
  final _complementController = TextEditingController();
  bool _isDefault = false;

  @override
  void dispose() {
    _labelController.dispose();
    _streetController.dispose();
    _numberController.dispose();
    _neighborhoodController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    _complementController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) return;

    final address = AddressEntity(
      id: '',
      label: _labelController.text.trim().isNotEmpty
          ? _labelController.text.trim()
          : null,
      street: _streetController.text.trim(),
      number: _numberController.text.trim(),
      neighborhood: _neighborhoodController.text.trim(),
      city: _cityController.text.trim(),
      state: _stateController.text.trim(),
      zipCode: _zipCodeController.text.trim(),
      complement: _complementController.text.trim().isNotEmpty
          ? _complementController.text.trim()
          : null,
      isDefault: _isDefault,
    );

    unawaited(context.read<AddressCubit>().addAddress(address));
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(t.address.addTitle), centerTitle: true),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            HarvestTextField(
              controller: _labelController,
              label: t.address.label,
              hint: t.address.labelHint,
              prefixIcon: const FaIcon(FontAwesomeIcons.tag),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            HarvestTextField(
              controller: _streetController,
              label: t.address.street,
              prefixIcon: const FaIcon(FontAwesomeIcons.locationDot),
              textInputAction: TextInputAction.next,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? t.address.required : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: HarvestTextField(
                    controller: _numberController,
                    label: t.address.number,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    validator: (v) => v == null || v.trim().isEmpty
                        ? t.address.required
                        : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 3,
                  child: HarvestTextField(
                    controller: _complementController,
                    label: t.address.complement,
                    textInputAction: TextInputAction.next,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            HarvestTextField(
              controller: _neighborhoodController,
              label: t.address.neighborhood,
              textInputAction: TextInputAction.next,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? t.address.required : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: HarvestTextField(
                    controller: _cityController,
                    label: t.address.city,
                    textInputAction: TextInputAction.next,
                    validator: (v) => v == null || v.trim().isEmpty
                        ? t.address.required
                        : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: HarvestTextField(
                    controller: _stateController,
                    label: t.address.state,
                    textInputAction: TextInputAction.next,
                    validator: (v) => v == null || v.trim().isEmpty
                        ? t.address.required
                        : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            HarvestTextField(
              controller: _zipCodeController,
              label: t.address.zipCode,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? t.address.required : null,
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: Text(t.address.setAsDefault),
              value: _isDefault,
              onChanged: (v) => setState(() => _isDefault = v),
              activeThumbColor: AppColors.primary,
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 24),
            HarvestButton(
              label: t.general.save,
              onPressed: _onSave,
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}
