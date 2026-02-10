import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../theme/app_colors.dart';

/// Centralized wishlist heart icon component.
///
/// Displays a heart icon that can be toggled between liked/unliked states.
/// Uses SVG icons from Cloudinary for consistent rendering.
///
/// Usage:
/// ```dart
/// WishlistIcon(
///   isLiked: _isLiked,
///   onTap: () => setState(() => _isLiked = !_isLiked),
/// )
/// ```
class WishlistIcon extends StatelessWidget {
  final bool isLiked;
  final VoidCallback? onTap;
  final double size;
  final Color? likedColor;
  final Color? unlikedColor;

  const WishlistIcon({
    super.key,
    required this.isLiked,
    this.onTap,
    this.size = 16,
    this.likedColor,
    this.unlikedColor,
  });

  static const String _likedIconUrl =
      'https://res.cloudinary.com/digia/image/upload/v1756715904/heart-like-svgrepo-com_1_tb519g.svg';
  static const String _unlikedIconUrl =
      'https://res.cloudinary.com/digia/image/upload/v1756715904/heart-like-svgrepo-com_gulaxk.svg';

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: size,
        height: size,
        child: SvgPicture.network(
          isLiked ? _likedIconUrl : _unlikedIconUrl,
          colorFilter: ColorFilter.mode(
            isLiked
                ? (likedColor ?? AppColors.tokenOrange)
                : (unlikedColor ?? colors.contentSecondary),
            BlendMode.srcIn,
          ),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

/// Stateful wishlist icon that manages its own liked state
class StatefulWishlistIcon extends StatefulWidget {
  final bool initialLiked;
  final void Function(bool isLiked)? onChanged;
  final double size;

  const StatefulWishlistIcon({
    super.key,
    this.initialLiked = false,
    this.onChanged,
    this.size = 16,
  });

  @override
  State<StatefulWishlistIcon> createState() => _StatefulWishlistIconState();
}

class _StatefulWishlistIconState extends State<StatefulWishlistIcon> {
  late bool _isLiked;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.initialLiked;
  }

  @override
  Widget build(BuildContext context) {
    return WishlistIcon(
      isLiked: _isLiked,
      size: widget.size,
      onTap: () {
        setState(() {
          _isLiked = !_isLiked;
        });
        widget.onChanged?.call(_isLiked);
      },
    );
  }
}
