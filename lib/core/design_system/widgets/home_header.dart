import 'package:flutter/material.dart';
import 'package:medihub/core/constants/digia_screen_ids.dart';
import 'package:medihub/core/theme/app_colors.dart';
import 'package:medihub/core/theme/app_text_styles.dart';
import 'package:medihub/views/search/search_screen.dart';

class HomeHeader extends StatelessWidget {
  final String deliveryAddress;
  final VoidCallback? onAddressTap;

  const HomeHeader({
    super.key,
    required this.deliveryAddress,
    this.onAddressTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.headerBlue,
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Color(0xFFFFFFFF),
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Delivery to ',
                    style: AppTextStyles.roboto12Regular(
                      color: const Color(0xFFFFFFFF).withValues(alpha: 0.7),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: onAddressTap,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              deliveryAddress,
                              style: AppTextStyles.roboto12Medium(
                                color: const Color(0xFFFFFFFF),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Icon(
                            Icons.arrow_drop_down,
                            color: Color(0xFFFFFFFF),
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      settings:
                          const RouteSettings(name: ScreenIds.search),
                      builder: (_) => const SearchScreen(),
                    ),
                  );
                },
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: colors.cardBackground,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search,
                        color: colors.iconSecondary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Search for medicine & health products',
                        style: AppTextStyles.bodySmall(
                            color: colors.contentSecondary),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
