import 'package:craft_chain/core/constants/app_skills.dart';
import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:craft_chain/core/widgets/skill_chip.dart';
import 'package:craft_chain/core/widgets/skill_selector.dart';
import 'package:craft_chain/core/widgets/user_avatar.dart';
import 'package:craft_chain/core/widgets/labeled_text_field.dart';
import 'package:craft_chain/features/auth/models/app_user.dart';
import 'package:craft_chain/features/profile/viewmodels/profile_cubit/profile_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key, required this.user});

  final AppUser user;

  static const String routePath = '/profile/edit';

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final String _name, _city, _bio;
  late Set<String> _canTeach;
  late Set<String> _wantsToLearn;

  final List<String> allSkills = AppSkills.flat;

  @override
  void initState() {
    super.initState();
    _name = widget.user.name;
    _city = widget.user.city;
    _bio = widget.user.bio;
    _canTeach = Set<String>.from(widget.user.canTeach);
    _wantsToLearn = Set<String>.from(widget.user.wantsToLearn);
  }

  Future<void> _onSave(BuildContext context) async {
    if (_name.trim().isEmpty || _city.trim().isEmpty) return;

    await context.read<ProfileCubit>().saveProfile(
      name: _name,
      city: _city,
      bio: _bio,
      canTeach: _canTeach.toList(),
      wantsToLearn: _wantsToLearn.toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileSuccess && state.isSaved) {
          // Pop after a successful save
          if (context.canPop()) context.pop();
        }
      },
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          final isSaving = state is ProfileSuccess && state.isSaving;

          return Scaffold(
            appBar: _buildAppBar(context, isSaving),
            body: _buildBody(context, isSaving),
          );
        },
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, bool isSaving) {
    final colors = context.colors;
    return AppBar(
      title: Text('profile.edit_profile'.tr()),
      actions: [
        isSaving
            ? const Padding(
                padding: EdgeInsets.only(right: 16),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2.5),
                ),
              )
            : TextButton(
                onPressed: () => _onSave(context),
                child: Text(
                  'profile.save'.tr(),
                  style: AppTextStyles.titleMedium.copyWith(
                    color: colors.primary,
                  ),
                ),
              ),
      ],
    );
  }

  Widget _buildBody(BuildContext context, bool isSaving) {
    final width = MediaQuery.sizeOf(context).width;
    final isWide = width >= 700;

    Widget content = AbsorbPointer(
      absorbing: isSaving,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isWide ? 40 : 20,
          vertical: 24,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _AvatarSection(user: widget.user),
                const SizedBox(height: 28),

                _GenderDisplay(gender: widget.user.gender),
                const SizedBox(height: 20),

                LabeledTextField(
                  initialValue: _name,
                  label: 'profile.full_name_label'.tr(),
                  onSaved: (value) {
                    _name = value!;
                  },
                  hintText: 'profile.full_name_hint'.tr(),
                ),
                const SizedBox(height: 20),

                LabeledTextField(
                  initialValue: _city,
                  label: 'profile.city_label'.tr(),
                  onSaved: (value) {
                    _city = value!;
                  },
                  hintText: 'profile.city_hint'.tr(),
                  prefixIcon: Icon(Icons.location_on_outlined),
                ),
                const SizedBox(height: 20),

                Text(
                  'profile.edit_teaches_label'.tr(),
                  style: AppTextStyles.labelUppercase.copyWith(
                    color: context.colors.secondaryText,
                  ),
                ),
                const SizedBox(height: 10),

                SkillSelector(
                  allSkills: allSkills,
                  selected: _canTeach,
                  type: SkillChipType.teach,
                  onToggle: (skill) => setState(() {
                    _canTeach.contains(skill)
                        ? _canTeach.remove(skill)
                        : _canTeach.add(skill);
                  }),
                ),
                const SizedBox(height: 20),

                Text(
                  'profile.edit_learn_label'.tr(),
                  style: AppTextStyles.labelUppercase.copyWith(
                    color: context.colors.secondaryText,
                  ),
                ),
                const SizedBox(height: 10),
                SkillSelector(
                  allSkills: allSkills,
                  selected: _wantsToLearn,
                  type: SkillChipType.learn,
                  onToggle: (skill) => setState(() {
                    _wantsToLearn.contains(skill)
                        ? _wantsToLearn.remove(skill)
                        : _wantsToLearn.add(skill);
                  }),
                ),
                const SizedBox(height: 20),

                LabeledTextField(
                  initialValue: _bio,
                  label: 'profile.bio_label'.tr(),
                  onSaved: (value) {
                    _bio = value!;
                  },
                  hintText: 'profile.bio_hint'.tr(),
                  minLines: 4,
                  maxLines: 8,
                  maxLength: 800,
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );

    return content;
  }
}

class _AvatarSection extends StatelessWidget {
  const _AvatarSection({required this.user});

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          UserAvatar(
            initials: user.initials,
            imageUrl: user.photoUrl,
            radius: 48,
            colorSeed: user.uid.hashCode,
            showCameraBadge: true,
            // TODO(task-02b): wire up image_picker for photo change
            onTap: () {},
          ),
          const SizedBox(height: 10),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.camera_alt_outlined, size: 16),
            label: Text('profile.change_photo'.tr()),
          ),
        ],
      ),
    );
  }
}

class _GenderDisplay extends StatelessWidget {
  const _GenderDisplay({required this.gender});

  final String gender;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final label = gender == 'male'
        ? 'profile.gender_male'.tr()
        : 'profile.gender_female'.tr();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: colors.surface2,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.inputBorder),
      ),
      child: Row(
        children: [
          Icon(Icons.person_outline_rounded, color: colors.secondaryText),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'profile.gender_label'.tr().toUpperCase(),
                  style: AppTextStyles.labelUppercase.copyWith(
                    color: colors.secondaryText,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: colors.onSurface,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.lock_outline_rounded,
            size: 16,
            color: colors.secondaryText,
          ),
          const SizedBox(width: 4),
          Text(
            'profile.gender_not_editable'.tr(),
            style: AppTextStyles.bodySmall.copyWith(
              color: colors.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}
