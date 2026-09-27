import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/widgets/user_avatar.dart';
import 'package:craft_chain/features/profile/domain/entities/user_profile_entity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_ui/material_ui.dart';

class EditProfileAvatarSection extends StatelessWidget {
  const EditProfileAvatarSection({
    super.key,
    required this.user,
    required this.pickedPhoto,
    required this.onPickPhoto,
  });

  final UserProfileEntity user;
  final XFile? pickedPhoto;
  final VoidCallback onPickPhoto;

  @override
  Widget build(BuildContext context) {
    final Widget avatar = pickedPhoto != null
        ? _LocalPhotoAvatar(file: pickedPhoto!, radius: 48, onTap: onPickPhoto)
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
  void didUpdateWidget(covariant _LocalPhotoAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.file.path != oldWidget.file.path) {
      _bytesFuture = widget.file.readAsBytes();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final radius = widget.radius;

    return FutureBuilder<List<int>>(
      future: _bytesFuture,
      builder: (context, snapshot) {
        return GestureDetector(
          onTap: widget.onTap,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: radius,
                backgroundColor: Colors.transparent,
                child: ClipOval(
                  child: snapshot.hasData
                      ? UserAvatar(
                          imageBytes: snapshot.data!,
                          radius: radius,
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
