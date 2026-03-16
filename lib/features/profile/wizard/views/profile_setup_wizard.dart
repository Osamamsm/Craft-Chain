import 'package:craft_chain/features/profile/wizard/views/widgets/step5_bio.dart';
import 'package:craft_chain/features/profile/wizard/views/widgets/step4_learn_skills.dart';
import 'package:craft_chain/features/profile/wizard/views/widgets/step3_teach_skills.dart';
import 'package:craft_chain/features/profile/wizard/views/widgets/step2_photo_city.dart';
import 'package:craft_chain/features/profile/wizard/views/widgets/step1_name_gender.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/features/profile/wizard/viewmodels/profile_setup_cubit/profile_setup_cubit.dart';
import 'package:craft_chain/features/profile/wizard/viewmodels/profile_setup_cubit/profile_setup_state.dart';
import 'package:craft_chain/features/profile/wizard/views/widgets/mobile_progress_bar.dart';
import 'package:craft_chain/features/profile/wizard/views/widgets/wizard_web_sidebar.dart';

const double _kWebBreakpoint = 700.0;

class ProfileSetupWizardScreen extends StatefulWidget {
  const ProfileSetupWizardScreen({super.key});

  static const routePath = '/profile-wizard';

  @override
  State<ProfileSetupWizardScreen> createState() =>
      _ProfileSetupWizardScreenState();
}

class _ProfileSetupWizardScreenState extends State<ProfileSetupWizardScreen> {
  final _pageController = PageController();
  final _nameController = TextEditingController();
  final _cityController = TextEditingController();
  final _bioController = TextEditingController();
  final _teachSearchController = TextEditingController();
  final _learnSearchController = TextEditingController();
  final _nameFocusNode = FocusNode();
  final _cityFocusNode = FocusNode();

  String _teachSearch = '';
  String _learnSearch = '';

  @override
  void initState() {
    super.initState();
    _teachSearchController.addListener(
      () => setState(() => _teachSearch = _teachSearchController.text),
    );
    _learnSearchController.addListener(
      () => setState(() => _learnSearch = _learnSearchController.text),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _cityController.dispose();
    _bioController.dispose();
    _teachSearchController.dispose();
    _learnSearchController.dispose();
    _nameFocusNode.dispose();
    _cityFocusNode.dispose();
    super.dispose();
  }

  void _animateToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _pickPhoto(BuildContext context) async {
    final picker = ImagePicker();
    final file = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    if (file != null && context.mounted) {
      context.read<ProfileSetupCubit>().updatePhoto(file);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileSetupCubit, ProfileSetupState>(
      listener: (context, state) {
        _animateToPage(state.stepIndex);

        if (state.isComplete) {
          context.go('/home');
        }

        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: context.colors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: context.colors.background,
          body: LayoutBuilder(
            builder: (ctx, constraints) {
              final isWeb = constraints.maxWidth >= _kWebBreakpoint;
              final pageView = _buildPageView(context, state, isWeb);
              if (isWeb) {
                return Row(
                  children: [
                    WizardWebSidebar(
                      stepIndex: state.stepIndex,
                      totalSteps: state.totalSteps,
                      progress: state.progress,
                    ),
                    Expanded(child: pageView),
                  ],
                );
              }
              return SafeArea(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: Column(
                      children: [
                        MobileProgressBar(
                          stepIndex: state.stepIndex,
                          totalSteps: state.totalSteps,
                          progress: state.progress,
                        ),
                        Expanded(child: pageView),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildPageView(
    BuildContext context,
    ProfileSetupState state,
    bool isWeb,
  ) {
    return PageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Step1NameGender(
          state: state,
          nameController: _nameController,
          nameFocusNode: _nameFocusNode,
          isWeb: isWeb,
        ),
        Step2PhotoCity(
          state: state,
          cityController: _cityController,
          cityFocusNode: _cityFocusNode,
          onPickPhoto: () => _pickPhoto(context),
          isWeb: isWeb,
        ),
        Step3TeachSkills(
          state: state,
          searchController: _teachSearchController,
          searchQuery: _teachSearch,
          isWeb: isWeb,
        ),
        Step4LearnSkills(
          state: state,
          searchController: _learnSearchController,
          searchQuery: _learnSearch,
          isWeb: isWeb,
        ),
        Step5Bio(state: state, bioController: _bioController, isWeb: isWeb),
      ],
    );
  }
}
