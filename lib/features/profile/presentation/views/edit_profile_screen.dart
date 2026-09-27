import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/features/profile/domain/entities/user_profile_entity.dart';
import 'package:craft_chain/features/profile/presentation/logic/profile_cubit/profile_cubit.dart';
import 'package:craft_chain/features/profile/presentation/widgets/edit_profile_form.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key, required this.user});

  final UserProfileEntity user;

  static const String routePath = '/profile/edit';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listenWhen: (previous, current) {
        if (current is! ProfileSuccess) return false;

        if (previous is ProfileSuccess) {
          return (previous.isSaving && !current.isSaving) ||
              previous.saveError != current.saveError;
        }

        return current.isSaved || current.saveError != null;
      },
      listener: (context, state) {
        if (state is! ProfileSuccess) return;

        if (state.isSaved) {
          _showSnackbar(context, 'profile.save_success'.tr());

          if (context.canPop()) {
            context.pop();
          }
        }

        if (state.saveError != null) {
          _showSnackbar(context, state.saveError!, isError: true);
        }
      },
      builder: (context, state) {
        final isSaving = state is ProfileSuccess && state.isSaving;

        return EditProfileForm(
          user: user,
          isSaving: isSaving,
          onSave: (params) {
            context.read<ProfileCubit>().updateProfile(params: params);
          },
        );
      },
    );
  }

  void _showSnackbar(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    final colors = context.colors;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? colors.error : colors.greenAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
