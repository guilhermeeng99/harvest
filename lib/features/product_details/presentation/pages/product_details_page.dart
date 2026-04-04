import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:harvest/app/di/injection_container.dart';
import 'package:harvest/app/theme/app_colors.dart';
import 'package:harvest/app/widgets/error_view.dart';
import 'package:harvest/features/home/domain/entities/product_entity.dart';
import 'package:harvest/features/home/domain/usecases/get_product_by_id_usecase.dart';
import 'package:harvest/features/product_details/presentation/widgets/product_content.dart';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({required this.productId, super.key});

  final String productId;

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  ProductEntity? _product;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    unawaited(_loadProduct());
  }

  Future<void> _loadProduct() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final result = await sl<GetProductByIdUseCase>()(widget.productId);
    if (!mounted) return;

    result.fold(
      (failure) => setState(() {
        _loading = false;
        _error = failure.message;
      }),
      (product) => setState(() {
        _loading = false;
        _product = product;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.arrowLeft, size: 18),
          onPressed: () => context.pop(),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? ErrorView(message: _error!, onRetry: _loadProduct)
          : _product != null
          ? ProductContent(product: _product!)
          : const SizedBox.shrink(),
    );
  }
}
