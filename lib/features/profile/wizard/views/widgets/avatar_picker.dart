import 'dart:typed_data';
import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class AvatarPicker extends StatefulWidget {
  const AvatarPicker({
    required this.photoFile,
    required this.onTap,
    this.radius = 44,
    this.showLabel = false,
    super.key,
  });
  final XFile? photoFile;
  final VoidCallback onTap;
  final double radius;
  final bool showLabel;

  @override
  State<AvatarPicker> createState() => _AvatarPickerState();
}

class _AvatarPickerState extends State<AvatarPicker> {
  Uint8List? _bytes;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(AvatarPicker old) {
    super.didUpdateWidget(old);
    if (widget.photoFile?.path != old.photoFile?.path) _load();
  }

  Future<void> _load() async {
    if (widget.photoFile == null) {
      if (mounted) setState(() => _bytes = null);
      return;
    }
    final b = await widget.photoFile!.readAsBytes();
    if (mounted) setState(() => _bytes = b);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final hasPhoto = _bytes != null;
    final r = widget.radius;

    return Column(
      children: [
        GestureDetector(
          onTap: widget.onTap,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: r * 2,
                height: r * 2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: hasPhoto ? Colors.transparent : colors.surface2,
                  border: Border.all(
                    color: hasPhoto ? colors.primary : colors.inputBorder,
                    width: 2.5,
                  ),
                ),
                child: ClipOval(
                  child: hasPhoto
                      ? Image.memory(_bytes!, fit: BoxFit.cover)
                      : Icon(
                          Icons.person_outline_rounded,
                          size: r * 0.75,
                          color: colors.secondaryText,
                        ),
                ),
              ),
              Positioned(
                bottom: -2,
                right: -2,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: colors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: colors.surface, width: 2.5),
                  ),
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    size: 13,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (widget.showLabel) ...[
          const SizedBox(height: 10),
          GestureDetector(
            onTap: widget.onTap,
            child: Text(
              'profile.change_photo'.tr(),
              style: AppTextStyles.bodySmall.copyWith(
                color: colors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
