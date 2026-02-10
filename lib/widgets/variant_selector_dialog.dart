import 'package:flutter/material.dart';
import '../models/product.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/price_utils.dart';

class VariantSelectorDialog extends StatelessWidget {
  final List<Variant> variants;
  final Variant? selectedVariant;
  final ValueChanged<Variant> onSelect;

  const VariantSelectorDialog({
    super.key,
    required this.variants,
    this.selectedVariant,
    required this.onSelect,
  });

  static Future<Variant?> show({
    required BuildContext context,
    required List<Variant> variants,
    Variant? selectedVariant,
  }) async {
    return showDialog<Variant>(
      context: context,
      builder: (context) => VariantSelectorDialog(
        variants: variants,
        selectedVariant: selectedVariant,
        onSelect: (variant) => Navigator.pop(context, variant),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: colors.cardBackground,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Quantity',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: colors.contentPrimary,
              ),
            ),
            const SizedBox(height: 16),
            ...variants.map((variant) {
              final isSelected = variant.id == selectedVariant?.id;
              return GestureDetector(
                onTap: () => onSelect(variant),
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.ctaOrange.withValues(alpha: 0.1)
                        : colors.backgroundTertiary,
                    borderRadius: BorderRadius.circular(8),
                    border: isSelected
                        ? Border.all(color: AppColors.ctaOrange, width: 1.5)
                        : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        variant.title,
                        style: TextStyle(
                          fontSize: 15,
                          color: isSelected
                              ? colors.contentPrimary
                              : colors.contentSecondary,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                      Text(
                        PriceUtils.formatPrice(variant.price.amount),
                        style: TextStyle(
                          fontSize: 14,
                          color: colors.contentPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
