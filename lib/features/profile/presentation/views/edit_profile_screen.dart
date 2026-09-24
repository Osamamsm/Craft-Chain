import 'dart:io';

import 'package:craft_chain/core/constants/app_skills.dart';
import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:craft_chain/core/widgets/skill_chip.dart';
import 'package:craft_chain/core/widgets/skill_selector.dart';
import 'package:craft_chain/core/widgets/user_avatar.dart';
import 'package:craft_chain/core/widgets/labeled_text_field.dart';
import 'package:craft_chain/features/profile/domain/entities/profile_skill_entity.dart';
import 'package:craft_chain/features/profile/domain/entities/skill_update_entity.dart';
import 'package:craft_chain/features/profile/domain/entities/update_profile_params.dart';
import 'package:craft_chain/features/profile/domain/entities/user_profile_entity.dart';
import 'package:craft_chain/features/profile/presentation/logic/profile_cubit/profile_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key, required this.user});

  final UserProfileEntity user;

  static const String routePath = '/profile/edit';

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // ── Controllers ────────────────────────────────────────────────────────────
  late final TextEditingController _nameCtrl;
  late final TextEditingController _cityCtrl;
  late final TextEditingController _bioCtrl;

  // ── Initial (baseline) values ───────────────────────────────────────────────
  late String _initialName;
  late String _initialCity;
  late String _initialBio;
  late Set<String> _initialCanTeach;
  late Set<String> _initialWantsToLearn;

  // ── Current mutable state ───────────────────────────────────────────────────
  late Set<String> _canTeach;
  late Set<String> _wantsToLearn;
  XFile? _pickedPhoto; // non-null only when user picked a new photo this session

  final _formKey = GlobalKey<FormState>();
  final List<Skill> _allSkills = AppSkills.flat;

  // ── Validation limits ───────────────────────────────────────────────────────
  static const int _maxSkills = 20;

  @override
  void initState() {
    super.initState();
    _initFromUser(widget.user);
  }

  void _initFromUser(UserProfileEntity user) {
    _initialName = user.fullName.trim();
    _initialCity = user.city.trim();
    _initialBio = user.bio.trim();
    _initialCanTeach = _skillNames(user.teaches);
    _initialWantsToLearn = _skillNames(user.wantsToLearn);

    _nameCtrl = TextEditingController(text: _initialName);
    _cityCtrl = TextEditingController(text: _initialCity);
    _bioCtrl = TextEditingController(text: _initialBio);

    _canTeach = Set<String>.from(_initialCanTeach);
    _wantsToLearn = Set<String>.from(_initialWantsToLearn);
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  Set<String> _skillNames(List<ProfileSkillEntity> skills) =>
      skills.map((s) => s.name).toSet();

  /// Rebuild baseline from fresh ProfileSuccess state after a successful save.
  void _refreshBaseline(UserProfileEntity user) {
    setState(() {
      _initialName = user.fullName.trim();
      _initialCity = user.city.trim();
      _initialBio = user.bio.trim();
      _initialCanTeach = _skillNames(user.teaches);
      _initialWantsToLearn = _skillNames(user.wantsToLearn);
      _pickedPhoto = null;
    });
  }

  bool get _hasChanges {
    if (_pickedPhoto != null) return true;
    if (_nameCtrl.text.trim() != _initialName) return true;
    if (_cityCtrl.text.trim() != _initialCity) return true;
    if (_bioCtrl.text.trim() != _initialBio) return true;
    if (!_setsEqual(_canTeach, _initialCanTeach)) return true;
    if (!_setsEqual(_wantsToLearn, _initialWantsToLearn)) return true;
    return false;
  }

  bool _setsEqual(Set<String> a, Set<String> b) =>
      a.length == b.length && a.containsAll(b);

  /// Builds an [UpdateProfileParams] that only contains changed fields.
  ///
  /// Returns `null` if validation fails or nothing has changed.
  UpdateProfileParams? _buildUpdateParams() {
    final name = _nameCtrl.text.trim();
    final city = _cityCtrl.text.trim();
    final bio = _bioCtrl.text.trim();

    // Required field guard
    if (name.isEmpty) return null;

    final changedName = name != _initialName ? name : null;
    final changedCity = city != _initialCity ? city : null;
    // For optional fields cleared to empty, treat as unchanged (don't send "")
    final changedBio = (bio != _initialBio && bio.isNotEmpty) ? bio : null;

    // ── Skills ────────────────────────────────────────────────────────────────
    final teachChanged = !_setsEqual(_canTeach, _initialCanTeach);
    final learnChanged = !_setsEqual(_wantsToLearn, _initialWantsToLearn);
    final skillsChanged = teachChanged || learnChanged;

    List<SkillUpdateEntity>? teachingSkills;
    List<SkillUpdateEntity>? learningSkills;

    if (skillsChanged) {
      // Backend rule: if either list changed, send BOTH with at least 1 skill each.
      teachingSkills = _toSkillEntities(_canTeach);
      learningSkills = _toSkillEntities(_wantsToLearn);
    }

    // ── Photo ─────────────────────────────────────────────────────────────────
    final File? photo =
        _pickedPhoto != null ? File(_pickedPhoto!.path) : null;

    final params = UpdateProfileParams(
      fullName: changedName,
      city: changedCity,
      bio: changedBio,
      photo: photo,
      teachingSkills: teachingSkills,
      learningSkills: learningSkills,
    );

    return params.isEmpty ? null : params;
  }

  List<SkillUpdateEntity> _toSkillEntities(Set<String> names) {
    return names.map((name) {
      final skill = _allSkills.firstWhere((s) => s.name == name);
      return SkillUpdateEntity(skillId: skill.id);
    }).toList();
  }

  // ── Image picker ────────────────────────────────────────────────────────────

  Future<void> _pickPhoto() async {
    try {
      final picker = ImagePicker();
      final file = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (file == null) return; // user cancelled

      // Guard: 5 MB max
      final bytes = await file.readAsBytes();
      if (bytes.length > 5 * 1024 * 1024) {
        if (mounted) {
          _showSnackbar('profile.photo_too_large'.tr(), isError: true);
        }
        return;
      }

      if (mounted) {
        setState(() => _pickedPhoto = file);
      }
    } catch (_) {
      if (mounted) {
        _showSnackbar('profile.photo_picker_error'.tr(), isError: true);
      }
    }
  }

  // ── Save ────────────────────────────────────────────────────────────────────

  Future<void> _onSave(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    final params = _buildUpdateParams();
    if (params == null) return;
    await context.read<ProfileCubit>().updateProfile(params: params);
  }

  void _showSnackbar(String message, {bool isError = false}) {
    final colors = context.colors;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? colors.error : colors.greenAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ── Toggle helpers ──────────────────────────────────────────────────────────

  void _toggleTeach(String skillName) {
    setState(() {
      if (_canTeach.contains(skillName)) {
        _canTeach.remove(skillName);
      } else {
        if (_canTeach.length >= _maxSkills) return;
        // Prevent overlap: remove from wantsToLearn if present
        _wantsToLearn.remove(skillName);
        _canTeach.add(skillName);
      }
    });
  }

  void _toggleLearn(String skillName) {
    setState(() {
      if (_wantsToLearn.contains(skillName)) {
        _wantsToLearn.remove(skillName);
      } else {
        if (_wantsToLearn.length >= _maxSkills) return;
        // Prevent overlap: remove from canTeach if present
        _canTeach.remove(skillName);
        _wantsToLearn.add(skillName);
      }
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _cityCtrl.dispose();
    _bioCtrl.dispose();
    super.dispose();
  }

  // ── Build ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listenWhen: (prev, curr) {
        // Only react when transitioning from isSaving → not isSaving,
        // or when saveError changes.
        if (curr is! ProfileSuccess) return false;
        if (prev is ProfileSuccess) {
          return (prev.isSaving && !curr.isSaving) ||
              (prev.saveError != curr.saveError);
        }
        return curr.isSaved || curr.saveError != null;
      },
      listener: (context, state) {
        if (state is! ProfileSuccess) return;

        if (state.isSaved) {
          _refreshBaseline(state.user);
          _showSnackbar('profile.save_success'.tr());
          if (context.canPop()) context.pop();
        }

        if (state.saveError != null) {
          _showSnackbar(state.saveError!, isError: true);
        }
      },
      builder: (context, state) {
        final isSaving = state is ProfileSuccess && state.isSaving;

        return ListenableBuilder(
          listenable: Listenable.merge([_nameCtrl, _cityCtrl, _bioCtrl]),
          builder: (context, _) {
            final hasChanges = _hasChanges;

            return Scaffold(
              appBar: _buildAppBar(context, isSaving, hasChanges),
              body: _buildBody(context, isSaving),
            );
          },
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context, bool isSaving, bool hasChanges) {
    final colors = context.colors;
    return AppBar(
      title: Text('profile.edit_profile'.tr()),
      actions: [
        if (isSaving)
          const Padding(
            padding: EdgeInsets.only(right: 16),
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            ),
          )
        else
          TextButton(
            onPressed: hasChanges ? () => _onSave(context) : null,
            child: Text(
              'profile.save'.tr(),
              style: AppTextStyles.titleMedium.copyWith(
                color: hasChanges ? colors.primary : colors.secondaryText,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBody(BuildContext context, bool isSaving) {
    final width = MediaQuery.sizeOf(context).width;
    final isWide = width >= 700;

    return AbsorbPointer(
      absorbing: isSaving,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isWide ? 40 : 20,
          vertical: 24,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _AvatarSection(
                    user: widget.user,
                    pickedPhoto: _pickedPhoto,
                    onPickPhoto: _pickPhoto,
                  ),
                  const SizedBox(height: 28),

                  _GenderDisplay(gender: widget.user.gender),
                  const SizedBox(height: 20),

                  LabeledTextField(
                    controller: _nameCtrl,
                    label: 'profile.full_name_label'.tr(),
                    hintText: 'profile.full_name_hint'.tr(),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'profile.full_name_required'.tr();
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  LabeledTextField(
                    controller: _cityCtrl,
                    label: 'profile.city_label'.tr(),
                    hintText: 'profile.city_hint'.tr(),
                    prefixIcon: const Icon(Icons.location_on_outlined),
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
                    allSkills: _allSkills,
                    selected: _canTeach,
                    type: SkillChipType.teach,
                    onToggle: _toggleTeach,
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
                    allSkills: _allSkills,
                    selected: _wantsToLearn,
                    type: SkillChipType.learn,
                    onToggle: _toggleLearn,
                  ),
                  const SizedBox(height: 20),

                  LabeledTextField(
                    controller: _bioCtrl,
                    label: 'profile.bio_label'.tr(),
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
      ),
    );
  }
}

// ── _AvatarSection ─────────────────────────────────────────────────────────────

class _AvatarSection extends StatelessWidget {
  const _AvatarSection({
    required this.user,
    required this.pickedPhoto,
    required this.onPickPhoto,
  });

  final UserProfileEntity user;
  final XFile? pickedPhoto;
  final VoidCallback onPickPhoto;

  @override
  Widget build(BuildContext context) {
    // Show local preview if a new photo was picked, otherwise network photo.
    final Widget avatar = pickedPhoto != null
        ? _LocalPhotoAvatar(
            file: pickedPhoto!,
            radius: 48,
            onTap: onPickPhoto,
          )
        : UserAvatar(
            initials: user.initials,
            imageUrl: user.photoUrl,
            radius: 48,
            colorSeed: user.id.hashCode,
            showCameraBadge: true,
            onTap: onPickPhoto,
          );

    return Center(
      child: Column(
        children: [
          avatar,
          const SizedBox(height: 10),
          TextButton.icon(
            onPressed: onPickPhoto,
            icon: const Icon(Icons.camera_alt_outlined, size: 16),
            label: Text('profile.change_photo'.tr()),
          ),
        ],
      ),
    );
  }
}

/// Shows a local file as a circular avatar with camera badge.
class _LocalPhotoAvatar extends StatefulWidget {
  const _LocalPhotoAvatar({
    required this.file,
    required this.radius,
    required this.onTap,
  });

  final XFile file;
  final double radius;
  final VoidCallback onTap;

  @override
  State<_LocalPhotoAvatar> createState() => _LocalPhotoAvatarState();
}

class _LocalPhotoAvatarState extends State<_LocalPhotoAvatar> {
  late Future<List<int>> _bytesFuture;

  @override
  void initState() {
    super.initState();
    _bytesFuture = widget.file.readAsBytes();
  }

  @override
  void didUpdateWidget(_LocalPhotoAvatar old) {
    super.didUpdateWidget(old);
    if (widget.file.path != old.file.path) {
      _bytesFuture = widget.file.readAsBytes();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final r = widget.radius;

    return FutureBuilder<List<int>>(
      future: _bytesFuture,
      builder: (context, snap) {
        return GestureDetector(
          onTap: widget.onTap,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: r,
                backgroundColor: Colors.transparent,
                child: ClipOval(
                  child: snap.hasData
                      ? UserAvatar(
                          imageBytes: snap.data!,
                          radius: r,
                          colorSeed: 0,
                        )
                      : const CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
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
          ),
        );
      },
    );
  }
}

// ── _GenderDisplay ─────────────────────────────────────────────────────────────

class _GenderDisplay extends StatelessWidget {
  const _GenderDisplay({required this.gender});

  final Gender gender;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final label = gender == Gender.male
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
