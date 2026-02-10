import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../theme/app_colors.dart';
import 'app_loading.dart';

/// Centralized image component with loading and error states.
///
/// Wraps CachedNetworkImage with consistent placeholder and error handling.
///
/// Usage:
/// ```dart
/// AppImage(
///   imageUrl: product.imageUrl,
///   width: 100,
///   height: 100,
/// )
/// ```
class AppImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? errorWidget;
  final Widget? loadingWidget;

  const AppImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.errorWidget,
    this.loadingWidget,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    if (imageUrl == null || imageUrl!.isEmpty) {
      return _buildErrorPlaceholder(colors);
    }

    Widget imageWidget = CachedNetworkImage(
      imageUrl: imageUrl!,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) =>
          loadingWidget ?? _buildLoadingPlaceholder(colors),
      errorWidget: (context, url, error) =>
          errorWidget ?? _buildErrorPlaceholder(colors),
    );

    if (borderRadius != null) {
      imageWidget = ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  Widget _buildLoadingPlaceholder(AppColorScheme colors) {
    return Container(
      width: width,
      height: height,
      color: colors.backgroundSecondary,
      child: Center(
        child: AppLoading.small(),
      ),
    );
  }

  Widget _buildErrorPlaceholder(AppColorScheme colors) {
    return Container(
      width: width,
      height: height,
      color: colors.backgroundSecondary,
      child: Icon(
        Icons.image_not_supported,
        size: 24,
        color: colors.iconSecondary,
      ),
    );
  }
}

/// Product image variant with standard sizing
class AppProductImage extends StatelessWidget {
  final String? imageUrl;
  final double size;

  const AppProductImage({
    super.key,
    required this.imageUrl,
    this.size = 92,
  });

  @override
  Widget build(BuildContext context) {
    return AppImage(
      imageUrl: imageUrl,
      width: size,
      height: size,
      fit: BoxFit.cover,
    );
  }
}

/// Avatar image variant with circular clipping
class AvatarImage extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final IconData fallbackIcon;

  const AvatarImage({
    super.key,
    required this.imageUrl,
    this.size = 40,
    this.fallbackIcon = Icons.person,
  });

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: AppImage(
        imageUrl: imageUrl,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorWidget: Container(
          width: size,
          height: size,
          color: AppColors.of(context).backgroundSecondary,
          child: Icon(
            fallbackIcon,
            size: size * 0.6,
            color: AppColors.of(context).iconSecondary,
          ),
        ),
      ),
    );
  }
}
