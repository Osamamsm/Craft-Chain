import 'dart:io';

import 'package:craft_chain/core/constants/app_skills.dart';
import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:craft_chain/core/widgets/labeled_text_field.dart';
import 'package:craft_chain/features/profile/domain/entities/profile_skill_entity.dart';
import 'package:craft_chain/features/profile/domain/entities/skill_update_entity.dart';
import 'package:craft_chain/features/profile/domain/entities/update_profile_params.dart';
import 'package:craft_chain/features/profile/domain/entities/user_profile_entity.dart';
import 'package:craft_chain/features/profile/presentation/widgets/edit_profile_avatar_section.dart';
import 'package:craft_chain/features/profile/presentation/widgets/edit_profile_gender_display.dart';
import 'package:craft_chain/features/profile/presentation/widgets/edit_profile_skills_section.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_ui/material_ui.dart';

class EditProfileForm extends StatefulWidget {
  const EditProfileForm({
    super.key,
    required this.user,
    required this.isSaving,
    required this.onSave,
  });

  final UserProfileEntity user;
  final bool isSaving;
  final ValueChanged<UpdateProfileParams> onSave;

  @override
  State<EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  static const int _maxSkills = 20;

  late final TextEditingController _nameController;
  late final TextEditingController _cityController;
  late final TextEditingController _bioController;

  late String _initialName;
  late String _initialCity;
  late String _initialBio;

  late Set<String> _initialCanTeach;
  late Set<String> _initialWantsToLearn;

  late Set<String> _canTeach;
  late Set<String> _wantsToLearn;

  XFile? _pickedPhoto;

  final _formKey = GlobalKey<FormState>();

  final List<Skill> _allSkills = AppSkills.flat;

  @override
  void initState() {
    super.initState();
    _initializeFromUser(widget.user);
  }

  void _initializeFromUser(UserProfileEntity user) {
    _initialName = user.fullName.trim();
    _initialCity = user.city.trim();
    _initialBio = user.bio.trim();

    _initialCanTeach = _skillNames(user.teaches);
    _initialWantsToLearn = _skillNames(user.wantsToLearn);

    _nameController = TextEditingController(text: _initialName);

    _cityController = TextEditingController(text: _initialCity);

    _bioController = TextEditingController(text: _initialBio);

    _canTeach = Set<String>.from(_initialCanTeach);
    _wantsToLearn = Set<String>.from(_initialWantsToLearn);
  }

  Set<String> _skillNames(List<ProfileSkillEntity> skills) {
    return skills.map((skill) => skill.name).toSet();
  }

  bool get _hasChanges {
    return _pickedPhoto != null ||
        _nameController.text.trim() != _initialName ||
        _cityController.text.trim() != _initialCity ||
        _bioController.text.trim() != _initialBio ||
        !_setsEqual(_canTeach, _initialCanTeach) ||
        !_setsEqual(_wantsToLearn, _initialWantsToLearn);
  }

  bool _setsEqual(Set<String> first, Set<String> second) {
    return first.length == second.length && first.containsAll(second);
  }

  UpdateProfileParams? _buildUpdateParams() {
    final name = _nameController.text.trim();
    final city = _cityController.text.trim();
    final bio = _bioController.text.trim();

    if (name.isEmpty) {
      return null;
    }

    final changedName = name != _initialName ? name : null;

    final changedCity = city != _initialCity ? city : null;

    final changedBio = bio != _initialBio && bio.isNotEmpty ? bio : null;

    final teachingChanged = !_setsEqual(_canTeach, _initialCanTeach);

    final learningChanged = !_setsEqual(_wantsToLearn, _initialWantsToLearn);

    List<SkillUpdateEntity>? teachingSkills;
    List<SkillUpdateEntity>? learningSkills;

    if (teachingChanged || learningChanged) {
      teachingSkills = _toSkillEntities(_canTeach);
      learningSkills = _toSkillEntities(_wantsToLearn);
    }

    final photo = _pickedPhoto != null ? File(_pickedPhoto!.path) : null;

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
      final skill = _allSkills.firstWhere((skill) => skill.name == name);

      return SkillUpdateEntity(skillId: skill.id);
    }).toList();
  }

  Future<void> _pickPhoto() async {
    try {
      final picker = ImagePicker();

      final file = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (file == null) return;

      final bytes = await file.readAsBytes();

      if (bytes.length > 5 * 1024 * 1024) {
        if (mounted) {
          _showSnackbar('profile.photo_too_large'.tr(), isError: true);
        }

        return;
      }

      if (mounted) {
        setState(() {
          _pickedPhoto = file;
        });
      }
    } catch (_) {
      if (mounted) {
        _showSnackbar('profile.photo_picker_error'.tr(), isError: true);
      }
    }
  }

  void _toggleTeach(String skillName) {
    setState(() {
      if (_canTeach.contains(skillName)) {
        _canTeach.remove(skillName);
        return;
      }

      if (_canTeach.length >= _maxSkills) {
        return;
      }

      _wantsToLearn.remove(skillName);
      _canTeach.add(skillName);
    });
  }

  void _toggleLearn(String skillName) {
    setState(() {
      if (_wantsToLearn.contains(skillName)) {
        _wantsToLearn.remove(skillName);
        return;
      }

      if (_wantsToLearn.length >= _maxSkills) {
        return;
      }

      _canTeach.remove(skillName);
      _wantsToLearn.add(skillName);
    });
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final params = _buildUpdateParams();

    if (params == null) {
      return;
    }

    widget.onSave(params);
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

  @override
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    _bioController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        _nameController,
        _cityController,
        _bioController,
      ]),
      builder: (context, _) {
        final hasChanges = _hasChanges;

        return Scaffold(
          appBar: _buildAppBar(context, hasChanges),
          body: _buildBody(context),
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context, bool hasChanges) {
    final colors = context.colors;

    return AppBar(
      title: Text('profile.edit_profile'.tr()),
      actions: [
        if (widget.isSaving)
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
            onPressed: hasChanges ? _onSave : null,
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

  Widget _buildBody(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isWide = width >= 700;

    return AbsorbPointer(
      absorbing: widget.isSaving,
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
                  EditProfileAvatarSection(
                    user: widget.user,
                    pickedPhoto: _pickedPhoto,
                    onPickPhoto: _pickPhoto,
                  ),

                  const SizedBox(height: 28),

                  EditProfileGenderDisplay(gender: widget.user.gender),

                  const SizedBox(height: 20),

                  LabeledTextField(
                    controller: _nameController,
                    label: 'profile.full_name_label'.tr(),
                    hintText: 'profile.full_name_hint'.tr(),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'profile.full_name_required'.tr();
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  LabeledTextField(
                    controller: _cityController,
                    label: 'profile.city_label'.tr(),
                    hintText: 'profile.city_hint'.tr(),
                    prefixIcon: const Icon(Icons.location_on_outlined),
                  ),

                  const SizedBox(height: 20),

                  EditProfileSkillsSection(
                    allSkills: _allSkills,
                    teachingSkills: _canTeach,
                    learningSkills: _wantsToLearn,
                    onToggleTeach: _toggleTeach,
                    onToggleLearn: _toggleLearn,
                  ),

                  const SizedBox(height: 20),

                  LabeledTextField(
                    controller: _bioController,
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
