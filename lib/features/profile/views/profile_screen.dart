import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:craft_chain/core/widgets/empty_state.dart';
import 'package:craft_chain/core/widgets/user_avatar.dart';
import 'package:craft_chain/features/auth/models/app_user.dart';
import 'package:craft_chain/features/profile/model/review.dart';
import 'package:craft_chain/features/profile/viewmodels/profile_cubit/profile_cubit.dart';
import 'package:craft_chain/features/profile/views/widgets/profile_action_button.dart';
import 'package:craft_chain/features/profile/views/widgets/profile_reviews_section.dart';
import 'package:craft_chain/features/profile/views/widgets/profile_skills_section.dart';
import 'package:craft_chain/features/profile/views/widgets/profile_stats_row.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.userId});

  final String userId;

  static const String routePath = '/profile/:userId';

  bool get _isOwnProfile => userId == kFakeCurrentUserId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileFailure) {
          return _ErrorBody(message: state.message);
        }

        final isLoading = state is ProfileLoading || state is ProfileInitial;
        final user = state is ProfileSuccess ? state.user : AppUser.placeholder;
        final reviews = state is ProfileSuccess ? state.reviews : <Review>[];

        return Skeletonizer(
          enabled: isLoading,
          child: _ProfileBody(
            user: user,
            reviews: reviews,
            isOwnProfile: _isOwnProfile,
          ),
        );
      },
    );
  }
}

// ── Body (shared between mobile and web via ResponsiveLayout) ─────────────────

class _ProfileBody extends StatelessWidget {
  const _ProfileBody({
    required this.user,
    required this.reviews,
    required this.isOwnProfile,
  });

  final AppUser user;
  final List<Review> reviews;
  final bool isOwnProfile;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= 700) {
      return _WebLayout(
        user: user,
        reviews: reviews,
        isOwnProfile: isOwnProfile,
      );
    }
    return _MobileLayout(
      user: user,
      reviews: reviews,
      isOwnProfile: isOwnProfile,
    );
  }
}

// ── Mobile Layout ─────────────────────────────────────────────────────────────

class _MobileLayout extends StatelessWidget {
  const _MobileLayout({
    required this.user,
    required this.reviews,
    required this.isOwnProfile,
  });

  final AppUser user;
  final List<Review> reviews;
  final bool isOwnProfile;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      body: Stack(
        children: [
          // ── Scrollable content ─────────────────────────────────────────
          CustomScrollView(
            slivers: [
              // Gradient header with AppBar area
              SliverToBoxAdapter(
                child: _MobileHeader(user: user, isOwnProfile: isOwnProfile),
              ),

              // Body padding
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // ── Skills & About ───────────────────────────────────
                    ProfileSkillsSection(user: user),

                    // ── Reviews ──────────────────────────────────────────
                    ProfileReviewsSection(reviews: reviews),

                    // Space for the fixed bottom button
                    const SizedBox(height: 100),
                  ]),
                ),
              ),
            ],
          ),

          // ── Fixed bottom action ────────────────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ProfileBottomAction(isOwnProfile: isOwnProfile, user: user),
          ),
        ],
      ),
    );
  }
}

// ── Mobile Header ─────────────────────────────────────────────────────────────

class _MobileHeader extends StatelessWidget {
  const _MobileHeader({required this.user, required this.isOwnProfile});

  final AppUser user;
  final bool isOwnProfile;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    const starColor = Color(0xFFF59E0B);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [colors.gradientStart, colors.gradientEnd],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── AppBar row ──────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    color: Colors.white,
                    onPressed: () {
                      if (context.canPop()) context.pop();
                    },
                  ),
                  Expanded(
                    child: Text(
                      'profile.title'.tr(),
                      textAlign: TextAlign.center,
                      style: AppTextStyles.titleLarge.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  // For symmetry — space equal to back button width
                  const SizedBox(width: 48),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Avatar ──────────────────────────────────────────────────
            UserAvatar(
              initials: user.initials,
              imageUrl: user.photoUrl,
              radius: 48,
              colorSeed: user.uid.hashCode,
            ),
            const SizedBox(height: 14),

            // ── Name ────────────────────────────────────────────────────
            Text(
              user.name,
              style: AppTextStyles.headlineMedium.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 6),

            // ── City ────────────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_on_rounded,
                  size: 14,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
                const SizedBox(width: 4),
                Text(
                  user.city,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // ── Stars + rating ───────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...List.generate(5, (i) {
                  final filled = i < user.rating.floor();
                  return Icon(
                    filled ? Icons.star_rounded : Icons.star_outline_rounded,
                    size: 16,
                    color: filled
                        ? starColor
                        : Colors.white.withValues(alpha: 0.4),
                  );
                }),
                const SizedBox(width: 6),
                Text(
                  '${'profile.rating_value'.tr(namedArgs: {'value': user.rating.toStringAsFixed(1)})} · ${user.barterCount} ${'profile.barters_label'.tr()}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ── Stats row ────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: MobileStatsRow(user: user),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// ── Web Layout ────────────────────────────────────────────────────────────────

class _WebLayout extends StatelessWidget {
  const _WebLayout({
    required this.user,
    required this.reviews,
    required this.isOwnProfile,
  });

  final AppUser user;
  final List<Review> reviews;
  final bool isOwnProfile;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    const starColor = Color(0xFFF59E0B);

    return Scaffold(
      backgroundColor: colors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child:
                Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Profile card ────────────────────────────────────────
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Blue header strip
                              Container(
                                padding: const EdgeInsets.fromLTRB(
                                  28,
                                  24,
                                  28,
                                  24,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      colors.gradientStart,
                                      colors.gradientEnd,
                                    ],
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Avatar
                                    UserAvatar(
                                      initials: user.initials,
                                      imageUrl: user.photoUrl,
                                      radius: 40,
                                      colorSeed: user.uid.hashCode,
                                    ),
                                    const SizedBox(width: 20),
                                    // Name, city, rating
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            user.name,
                                            style: AppTextStyles.headlineMedium
                                                .copyWith(color: Colors.white),
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.location_on_rounded,
                                                size: 13,
                                                color: Colors.white.withValues(
                                                  alpha: 0.8,
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                user.city,
                                                style: AppTextStyles.bodyMedium
                                                    .copyWith(
                                                      color: Colors.white
                                                          .withValues(
                                                            alpha: 0.8,
                                                          ),
                                                    ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          Row(
                                            children: [
                                              ...List.generate(5, (i) {
                                                final filled =
                                                    i < user.rating.floor();
                                                return Icon(
                                                  filled
                                                      ? Icons.star_rounded
                                                      : Icons
                                                            .star_outline_rounded,
                                                  size: 14,
                                                  color: filled
                                                      ? starColor
                                                      : Colors.white.withValues(
                                                          alpha: 0.4,
                                                        ),
                                                );
                                              }),
                                              const SizedBox(width: 6),
                                              Text(
                                                '${user.rating.toStringAsFixed(1)} · ${user.barterCount} ${'profile.barters_label'.tr()} ${'profile.sessions_label'.tr()}',
                                                style: AppTextStyles.bodySmall
                                                    .copyWith(
                                                      color: Colors.white
                                                          .withValues(
                                                            alpha: 0.9,
                                                          ),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Action button
                                    ProfileWebAction(
                                      isOwnProfile: isOwnProfile,
                                      user: user,
                                    ),
                                  ],
                                ),
                              ),

                              // White card body
                              Container(
                                color: colors.surface,
                                padding: const EdgeInsets.all(28),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Stats row (4 boxes)
                                    WebStatsRow(user: user),
                                    const SizedBox(height: 28),
                                    Divider(color: colors.inputBorder),
                                    const SizedBox(height: 24),

                                    // Two-column content
                                    IntrinsicHeight(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Left: About + Skills
                                          Expanded(
                                            flex: 5,
                                            child: ProfileSkillsSection(
                                              user: user,
                                            ),
                                          ),
                                          const SizedBox(width: 32),
                                          VerticalDivider(
                                            color: colors.inputBorder,
                                          ),
                                          const SizedBox(width: 32),
                                          // Right: Reviews
                                          Expanded(
                                            flex: 5,
                                            child: ProfileReviewsSection(
                                              reviews: reviews,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                    .animate()
                    .fadeIn(duration: 400.ms)
                    .slideY(begin: 0.03, end: 0, duration: 400.ms),
          ),
        ),
      ),
    );
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('profile.title'.tr())),
      body: EmptyState(
        icon: Icons.error_outline_rounded,
        title: 'profile.error_title'.tr(),
        subtitle: message.tr(),
      ),
    );
  }
}
