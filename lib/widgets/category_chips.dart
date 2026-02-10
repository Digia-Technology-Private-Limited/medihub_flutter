import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const CategoryChip({
    super.key,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(
          minWidth: 60,
          minHeight: 30,
        ),
        height: 30,
        decoration: BoxDecoration(
          color: colors.backgroundTertiary,
          borderRadius: BorderRadius.circular(6),
        ),
        alignment: Alignment.center,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.clip,
            style: AppTextStyles.roboto12SemiBold(
              color: colors.contentPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryChips extends StatelessWidget {
  final List<String> categories;
  final int? selectedIndex;
  final Function(int)? onSelected;

  const CategoryChips({
    super.key,
    required this.categories,
    this.selectedIndex,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: CategoryChip(
              label: categories[index],
              onTap: () => onSelected?.call(index),
            ),
          );
        },
      ),
    );
  }
}
