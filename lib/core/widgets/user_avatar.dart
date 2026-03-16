import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/theme/app_text_styles.dart';

/// Circular avatar widget with:
/// - Network image (via [imageUrl] + [CachedNetworkImage])
/// - In-memory bytes (via [imageBytes]) — used during profile setup before upload
/// - Initials fallback (via [initials])
/// - Coloured background that cycles based on [colorSeed]
class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    this.imageUrl,
    this.imageBytes,
    this.initials,
    this.radius = 24,
    this.colorSeed = 0,
    this.onTap,
    this.showCameraBadge = false,
    this.isDashed = false,
  });

  final String? imageUrl;
  final List<int>? imageBytes;

  /// 1–2 characters shown when no image is available.
  final String? initials;
  final double radius;

  /// Index used to pick a consistent avatar background colour.
  final int colorSeed;
  final VoidCallback? onTap;

  /// Shows a camera icon badge at bottom-right — used in photo picker.
  final bool showCameraBadge;

  /// Renders a dashed border (empty state) instead of a solid one.
  final bool isDashed;

  static const _bgColors = [
    AppColors.avatarTeal,
    AppColors.avatarPurple,
    AppColors.avatarOrange,
    AppColors.avatarGreen,
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final hasImage = imageUrl != null || imageBytes != null;
    final bgColor = _bgColors[colorSeed % _bgColors.length];

    Widget avatar = CircleAvatar(
      radius: radius,
      backgroundColor: hasImage ? Colors.transparent : bgColor,
      child: hasImage ? _buildImage() : _buildInitials(),
    );

    if (isDashed && !hasImage) {
      avatar = Container(
        width: radius * 2,
        height: radius * 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colors.surface2,
          border: Border.all(
            color: colors.inputBorder,
            width: 2,
            strokeAlign: BorderSide.strokeAlignOutside,
          ),
        ),
        child: Center(
          child: Icon(
            Icons.person_outline_rounded,
            size: radius * 0.9,
            color: colors.secondaryText,
          ),
        ),
      );
    }

    Widget result = Stack(
      clipBehavior: Clip.none,
      children: [
        ClipOval(child: avatar),
        if (showCameraBadge)
          Positioned(
            bottom: -2,
            right: -2,
            child: Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: colors.primary,
                shape: BoxShape.circle,
                border: Border.all(color: colors.surface, width: 2.5),
              ),
              child: const Icon(
                Icons.camera_alt_rounded,
                size: 12,
                color: Colors.white,
              ),
            ),
          ),
      ],
    );

    if (onTap != null) {
      result = GestureDetector(onTap: onTap, child: result);
    }

    return result;
  }

  Widget _buildImage() {
    if (imageBytes != null) {
      return SizedBox(
        width: radius * 2,
        height: radius * 2,
        child: Image.memory(
          Uint8List.fromList(imageBytes!),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildInitials(),
        ),
      );
    }
    return CachedNetworkImage(
      imageUrl: imageUrl!,
      imageBuilder: (context, image) => Container(
        width: radius * 2,
        height: radius * 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(image: image, fit: BoxFit.cover),
        ),
      ),
      errorWidget: (context, url, error) => _buildInitials(),
    );
  }

  Widget _buildInitials() {
    final text = (initials ?? '?')
        .substring(0, initials!.isNotEmpty ? 1 : 1)
        .toUpperCase();
    return Text(
      text,
      style: AppTextStyles.titleLarge.copyWith(
        color: Colors.white,
        fontSize: radius * 0.7,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}
