import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/product_model.dart';
import '../../providers/product_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_theme.dart';
import '../../utils/theme_helper.dart';
import 'product_detail_screen.dart';

class ProductSearchScreen extends StatefulWidget {
  const ProductSearchScreen({super.key});

  @override
  State<ProductSearchScreen> createState() => _ProductSearchScreenState();
}

class _ProductSearchScreenState extends State<ProductSearchScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search Food, Drinks, etc',
            border: InputBorder.none,
          ),
          style: AppTextStyles.bodyMedium.copyWith(
            color: ThemeHelper.getTextPrimaryColor(context),
          ),
          onChanged: (value) => setState(() => _query = value.trim()),
        ),
        iconTheme: IconThemeData(
          color: ThemeHelper.getTextPrimaryColor(context),
        ),
        backgroundColor: ThemeHelper.getBackgroundColor(context),
      ),
      backgroundColor: ThemeHelper.getBackgroundColor(context),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, _) {
          final List<ProductModel> allProducts = productProvider.products;

          final filtered = _query.isEmpty
              ? allProducts
              : allProducts
                  .where(
                    (p) =>
                        p.name.toLowerCase().contains(_query.toLowerCase()) ||
                        p.category.toLowerCase().contains(_query.toLowerCase()),
                  )
                  .toList();

          if (filtered.isEmpty) {
            return Center(
              child: Text(
                _query.isEmpty
                    ? 'Start typing to search menu items'
                    : 'No results for "$_query"',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: ThemeHelper.getTextSecondaryColor(context),
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            itemCount: filtered.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppTheme.spacingS),
            itemBuilder: (context, index) {
              final product = filtered[index];
              return ListTile(
                tileColor: ThemeHelper.getSurfaceColor(context),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusM),
                ),
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  child: Text(
                    product.name.isNotEmpty ? product.name[0].toUpperCase() : '?',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
                title: Text(
                  product.name,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: ThemeHelper.getTextPrimaryColor(context),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  '${product.category} • ${product.formattedCurrentPrice}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: ThemeHelper.getTextSecondaryColor(context),
                  ),
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: AppColors.primary,
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ProductDetailScreen(productId: product.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}


