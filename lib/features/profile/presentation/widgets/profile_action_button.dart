import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:craft_chain/features/profile/domain/entities/user_profile_entity.dart';
import 'package:craft_chain/features/profile/presentation/logic/profile_cubit/profile_cubit.dart';
import 'package:craft_chain/features/profile/presentation/views/edit_profile_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// ── Mobile bottom bar ─────────────────────────────────────────────────────────

/// Fixed bottom action bar used in the mobile profile layout.
///
/// Shows "Edit Profile" (outlined) for own profile, or "Send Barter Request"
/// (filled) for another user's profile.
class ProfileBottomAction extends StatelessWidget {
  const ProfileBottomAction({
    super.key,
    required this.isOwnProfile,
    required this.user,
  });

  final bool isOwnProfile;
  final UserProfileEntity user;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        MediaQuery.paddingOf(context).bottom + 12,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: isOwnProfile
          ? _EditButton.outlined(context, user)
          : _BarterButton.filled(),
    );
  }
}

// ── Web inline button ─────────────────────────────────────────────────────────

/// Inline action button shown inside the gradient header on the web layout.
///
/// Same logic as [ProfileBottomAction] but styled for a dark background.
class ProfileWebAction extends StatelessWidget {
  const ProfileWebAction({
    super.key,
    required this.isOwnProfile,
    required this.user,
  });

  final bool isOwnProfile;
  final UserProfileEntity user;

  @override
  Widget build(BuildContext context) {
    return isOwnProfile
        ? _EditButton.outlinedWhite(context, user)
        : SizedBox(width: 200, child: _BarterButton.filledWhite(context));
  }
}

// ── Private button builders ───────────────────────────────────────────────────

class _EditButton {
  /// Outlined blue button — used in mobile bottom bar.
  static Widget outlined(BuildContext context, UserProfileEntity user) {
    final colors = context.colors;
    return OutlinedButton(
      onPressed: () => context.pushNamed(
        'profile-edit',
        pathParameters: {'userId': user.id},
        extra: user,
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: colors.primary,
        side: BorderSide(color: colors.primary, width: 1.5),
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        'profile.edit_profile'.tr(),
        style: AppTextStyles.buttonLarge,
      ),
    );
  }

  /// Outlined white button — used inside the gradient header on web.
  static Widget outlinedWhite(BuildContext context, UserProfileEntity user) {
    return OutlinedButton(
      onPressed: () => context.pushNamed(
        'profile-edit',
        pathParameters: {'userId': user.id},
        extra: {'user': user, 'cubit': context.read<ProfileCubit>()},
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: const BorderSide(color: Colors.white, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text('profile.edit_profile'.tr()),
    );
  }
}

class _BarterButton {
  /// Filled primary button — mobile bottom bar.
  static Widget filled() {
    return Builder(
      builder: (context) => ElevatedButton(
        onPressed: () {
          // TODO: open barter request bottom sheet
        },
        child: Text('profile.send_barter_request'.tr()),
      ),
    );
  }

  /// Filled white button — web gradient header.
  static Widget filledWhite(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // TODO: open barter request bottom sheet
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: context.colors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      child: Text('profile.send_barter_request'.tr()),
    );
  }
}
