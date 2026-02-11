import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/product_model.dart';
import '../../providers/product_provider.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_theme.dart';
import '../../utils/theme_helper.dart';
import '../../widgets/product_card.dart';
import '../product/product_detail_screen.dart';

class AllProductsScreen extends StatelessWidget {
  const AllProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Best Deals'),
        backgroundColor: ThemeHelper.getBackgroundColor(context),
        foregroundColor: ThemeHelper.getTextPrimaryColor(context),
        elevation: 0,
      ),
      backgroundColor: ThemeHelper.getBackgroundColor(context),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, _) {
          final List<ProductModel> products = productProvider.products;

          if (products.isEmpty) {
            return Center(
              child: Text(
                'No deals available right now',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: ThemeHelper.getTextSecondaryColor(context),
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: AppTheme.spacingM),
                child: ProductCard(
                  imageUrl: product.imageUrl,
                  title: product.name,
                  quantity: product.quantity,
                  currentPrice: product.formattedCurrentPrice,
                  originalPrice: product.originalPrice != null
                      ? product.formattedOriginalPrice
                      : null,
                  isFavorite: false,
                  onFavoriteTap: () {},
                  onAddTap: () {},
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ProductDetailScreen(
                          productId: product.id,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}


