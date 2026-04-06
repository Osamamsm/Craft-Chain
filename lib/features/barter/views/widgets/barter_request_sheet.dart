import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:craft_chain/core/widgets/skill_chip.dart';
import 'package:craft_chain/features/barter/viewmodels/barter_request_cubit/barter_request_cubit.dart';
import 'package:craft_chain/features/barter/viewmodels/create_barter_cubit/create_barter_cubit.dart';
import 'package:craft_chain/features/barter/viewmodels/create_barter_cubit/create_barter_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A bottom sheet that lets the current user select one skill to teach and
/// one skill to learn from the target user, then submit a barter request.
///
/// Must be shown with a [BlocProvider] wrapping [BarterRequestCubit] in scope.
class BarterRequestSheet extends StatelessWidget {
  const BarterRequestSheet({
    super.key,
    required this.currentUserSkills,
    required this.targetUserSkills,
    required this.targetUserName,
    required this.targetUserId,
    this.onRequestSent,
  });

  /// Skills the *current* user can teach (for the top picker).
  final List<String> currentUserSkills;

  /// Skills the *target* user can teach (for the bottom picker).
  final List<String> targetUserSkills;

  final String targetUserName;
  final String targetUserId;

  /// Optional callback invoked after the request is sent successfully.
  final VoidCallback? onRequestSent;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateBarterCubit, CreateBarterState>(
      listener: (context, state) async {
        if (!state.isSendingRequest && state.selectedTeachSkill == null) {
          // Request just completed — sheet is already popped by the bloc.
        }
      },
      builder: (context, state) {
        return _BarterRequestSheetContent(
          currentUserSkills: currentUserSkills,
          targetUserSkills: targetUserSkills,
          targetUserName: targetUserName,
          targetUserId: targetUserId,
          onRequestSent: onRequestSent,
          state: state,
        );
      },
    );
  }
}

// ── Internal stateful content ──────────────────────────────────────────────────

class _BarterRequestSheetContent extends StatelessWidget {
  const _BarterRequestSheetContent({
    required this.currentUserSkills,
    required this.targetUserSkills,
    required this.targetUserName,
    required this.targetUserId,
    required this.state,
    this.onRequestSent,
  });

  final List<String> currentUserSkills;
  final List<String> targetUserSkills;
  final String targetUserName;
  final String targetUserId;
  final CreateBarterState state;
  final VoidCallback? onRequestSent;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final cubit = context.read<CreateBarterCubit>();

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Handle ──────────────────────────────────────────────────────────
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colors.inputBorder,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          // ── Header ──────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'barter.sheet_title'.tr(),
                    style: AppTextStyles.titleLarge.copyWith(
                      color: colors.onSurface,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close_rounded,
                      color: colors.secondaryText, size: 22),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'barter.sheet_subtitle'.tr(
                namedArgs: {'name': targetUserName},
              ),
              style: AppTextStyles.bodyMedium.copyWith(
                color: colors.secondaryText,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionLabel(
                    icon: Icons.school_rounded,
                    label: 'barter.what_you_teach'.tr(),
                    color: colors.teachChipText,
                  ),
                  const SizedBox(height: 10),
                  _SkillPickerRow(
                    skills: currentUserSkills,
                    selected: state.selectedTeachSkill,
                    type: SkillChipType.teach,
                    onSelect: cubit.selectTeachSkill,
                  ),

                  const SizedBox(height: 24),

                  // ── Section 2: What do you want to LEARN? ───────────────────
                  _SectionLabel(
                    icon: Icons.auto_stories_rounded,
                    label: 'barter.what_you_learn'.tr(
                      namedArgs: {'name': targetUserName},
                    ),
                    color: colors.primary,
                  ),
                  const SizedBox(height: 10),
                  _SkillPickerRow(
                    skills: targetUserSkills,
                    selected: state.selectedLearnSkill,
                    type: SkillChipType.learn,
                    onSelect: cubit.selectLearnSkill,
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),

          // ── Submit button ────────────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(
              24,
              0,
              24,
              MediaQuery.of(context).viewInsets.bottom + 24,
            ),
            child: _SendButton(
              canSubmit: state.canSubmitRequest,
              isLoading: state.isSendingRequest,
              onPressed: () async {
                final success = await cubit.sendBarterRequest(
                  targetUserId: targetUserId,
                  targetUserName: targetUserName,
                );
                if (success && context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('barter.request_sent_snackbar'.tr()),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: colors.greenAccent,
                    ),
                  );
                  onRequestSent?.call();
                }
              },
            ),
          ),
        ],
      ),
    ).animate().slideY(
          begin: 0.1,
          end: 0,
          duration: 280.ms,
          curve: Curves.easeOutCubic,
        );
  }
}

// ── Sub-widgets ────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({
    required this.icon,
    required this.label,
    required this.color,
  });
  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(7),
          ),
          child: Icon(icon, size: 15, color: color),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.titleMedium.copyWith(
              color: context.colors.onSurface,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}

class _SkillPickerRow extends StatelessWidget {
  const _SkillPickerRow({
    required this.skills,
    required this.selected,
    required this.type,
    required this.onSelect,
  });
  final List<String> skills;
  final String? selected;
  final SkillChipType type;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: skills
          .map(
            (s) => SkillChip(
              label: s,
              type: type,
              isSelected: s == selected,
              onTap: () => onSelect(s),
            ),
          )
          .toList(),
    );
  }
}

class _SendButton extends StatelessWidget {
  const _SendButton({
    required this.canSubmit,
    required this.isLoading,
    required this.onPressed,
  });
  final bool canSubmit;
  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: (canSubmit && !isLoading) ? onPressed : null,
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text('barter.send_request'.tr()),
      ),
    );
  }
}
