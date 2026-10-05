import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:craft_chain/core/widgets/skill_chip.dart';
import 'package:craft_chain/features/barter/presentation/logic/send_barter_request_cubit/send_barter_request_cubit.dart';
import 'package:craft_chain/features/profile/domain/entities/profile_skill_entity.dart';
import 'package:craft_chain/features/profile/domain/entities/user_profile_entity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

/// A bottom sheet that lets the current user pick one skill to teach and one
/// skill to learn, both taken from the viewed user's profile:
///  - teach  → [recipient.wantsToLearn]  (becomes requesterSkillId)
///  - learn  → [recipient.teaches]       (becomes recipientSkillId)
class BarterRequestBottomSheet extends StatefulWidget {
  const BarterRequestBottomSheet({
    super.key,
    required this.recipient,
    this.onRequestSent,
  });

  final UserProfileEntity recipient;

  /// Optional callback invoked after the request is sent successfully.
  final VoidCallback? onRequestSent;

  /// Opens the sheet with its own [SendBarterRequestCubit].
  static Future<void> show(
    BuildContext context, {
    required UserProfileEntity recipient,
    VoidCallback? onRequestSent,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BarterRequestBottomSheet(
        recipient: recipient,
        onRequestSent: onRequestSent,
      ),
    );
  }

  @override
  State<BarterRequestBottomSheet> createState() =>
      _BarterRequestBottomSheetState();
}

class _BarterRequestBottomSheetState extends State<BarterRequestBottomSheet> {
  int? _teachSkillId; // requesterSkillId
  int? _learnSkillId; // recipientSkillId

  bool get _canSubmit => _teachSkillId != null && _learnSkillId != null;

  void _submit() {
    context.read<SendBarterRequestCubit>().sendBarterRequest(
      recipientId: widget.recipient.id,
      requesterSkillId: _teachSkillId!,
      recipientSkillId: _learnSkillId!,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final name = widget.recipient.fullName;

    return BlocConsumer<SendBarterRequestCubit, SendBarterRequestState>(
      listener: (context, state) {
        final messenger = ScaffoldMessenger.of(context);

        if (state is SendBarterRequestSuccess) {
          Navigator.of(context).pop();
          messenger.showSnackBar(
            SnackBar(
              content: Text('barter.request_sent_snackbar'.tr()),
              behavior: SnackBarBehavior.floating,
              backgroundColor: colors.greenAccent,
            ),
          );
          widget.onRequestSent?.call();
        } else if (state is SendBarterRequestError) {
          messenger.showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              behavior: SnackBarBehavior.floating,
              backgroundColor: colors.error,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is SendBarterRequestLoading;

        return Container(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Handle ──────────────────────────────────────────────────
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

              // ── Header ──────────────────────────────────────────────────
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
                      icon: Icon(
                        Icons.close_rounded,
                        color: colors.secondaryText,
                        size: 22,
                      ),
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
                  'barter.sheet_subtitle'.tr(namedArgs: {'name': name}),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: colors.secondaryText,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ── Pickers ─────────────────────────────────────────────────
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionLabel(
                        icon: Icons.school_rounded,
                        label: 'barter.what_you_teach'.tr(
                          namedArgs: {'name': name},
                        ),
                        color: colors.teachChipText,
                      ),
                      const SizedBox(height: 10),
                      _SkillPickerRow(
                        skills: widget.recipient.wantsToLearn,
                        emptyMessage: 'barter.recipient_wants_nothing'.tr(),
                        selectedId: _teachSkillId,
                        type: SkillChipType.teach,
                        onSelect: isLoading
                            ? null
                            : (id) => setState(() => _teachSkillId = id),
                      ),

                      const SizedBox(height: 24),

                      _SectionLabel(
                        icon: Icons.auto_stories_rounded,
                        label: 'barter.what_you_learn'.tr(
                          namedArgs: {'name': name},
                        ),
                        color: colors.primary,
                      ),
                      const SizedBox(height: 10),
                      _SkillPickerRow(
                        skills: widget.recipient.teaches,
                        emptyMessage: 'barter.recipient_no_skills'.tr(),
                        selectedId: _learnSkillId,
                        type: SkillChipType.learn,
                        onSelect: isLoading
                            ? null
                            : (id) => setState(() => _learnSkillId = id),
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),

              // ── Submit button ───────────────────────────────────────────
              Padding(
                padding: EdgeInsets.fromLTRB(
                  24,
                  0,
                  24,
                  MediaQuery.viewInsetsOf(context).bottom + 12,
                ),
                child: _SendButton(
                  canSubmit: _canSubmit,
                  isLoading: isLoading,
                  onPressed: _submit,
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
      },
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
    required this.emptyMessage,
    required this.selectedId,
    required this.type,
    required this.onSelect,
  });

  final List<ProfileSkillEntity> skills;
  final String emptyMessage;
  final int? selectedId;
  final SkillChipType type;
  final ValueChanged<int>? onSelect;

  @override
  Widget build(BuildContext context) {
    if (skills.isEmpty) {
      return Text(
        emptyMessage,
        style: AppTextStyles.bodyMedium.copyWith(
          color: context.colors.secondaryText,
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final skill in skills)
          SkillChip(
            label: skill.name,
            type: type,
            isSelected: skill.skillId == selectedId,
            onTap: () => onSelect?.call(skill.skillId),
          ),
      ],
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
