import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/services/analytics_service.dart';
import '../../providers/theme_provider.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: colors.backgroundSecondary,
      appBar: AppBar(
        title: Text(
          'Account',
          style: AppTextStyles.headingSmall(color: colors.contentPrimary),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: colors.cardBackground,
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor:
                        AppColors.headerBlue.withValues(alpha: 0.1),
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: AppColors.headerBlue,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bruce Wayne',
                          style: AppTextStyles.bodyLarge(
                            color: colors.contentPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'bruce@wayneenterprises.com',
                          style: AppTextStyles.bodySmall(
                              color: colors.contentSecondary),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: colors.iconSecondary,
                    size: 18,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              color: colors.cardBackground,
              child: Column(
                children: [
                  _buildSettingItem(
                    context: context,
                    icon: Icons.location_on_outlined,
                    title: 'Saved Addresses',
                    onTap: () {},
                  ),
                  _buildDivider(context),
                  _buildSettingItem(
                    context: context,
                    icon: Icons.shopping_bag_outlined,
                    title: 'My Orders',
                    onTap: () {},
                  ),
                  _buildDivider(context),
                  _buildSettingItem(
                    context: context,
                    icon: Icons.favorite_outline,
                    title: 'Wishlist',
                    onTap: () {},
                  ),
                  _buildDivider(context),
                  _buildSettingItem(
                    context: context,
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              color: colors.cardBackground,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      'Appearance',
                      style:
                          AppTextStyles.label(color: colors.contentSecondary),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        Icon(
                          themeProvider.isDarkMode
                              ? Icons.dark_mode
                              : Icons.light_mode,
                          color: colors.iconSecondary,
                          size: 24,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'Dark Mode',
                            style: AppTextStyles.bodyDefault(
                              color: colors.contentPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Switch(
                          value: themeProvider.isDarkMode,
                          onChanged: (_) {
                            themeProvider.toggleTheme();
                            AnalyticsService().trackDarkModeToggled(
                              isDarkMode: !themeProvider.isDarkMode,
                            );
                          },
                          activeThumbColor: AppColors.headerBlue,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              color: colors.cardBackground,
              child: Column(
                children: [
                  _buildSettingItem(
                    context: context,
                    icon: Icons.help_outline,
                    title: 'Help & Support',
                    onTap: () {},
                  ),
                  _buildDivider(context),
                  _buildSettingItem(
                    context: context,
                    icon: Icons.info_outline,
                    title: 'About',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final colors = AppColors.of(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: colors.iconSecondary, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.bodyDefault(
                  color: colors.contentPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: colors.iconSecondary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    final colors = AppColors.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 56),
      child: Divider(height: 1, color: colors.divider),
    );
  }
}
