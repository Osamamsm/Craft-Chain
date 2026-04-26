import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:craft_chain/features/explore/view_model/explore_cubit/explore_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({super.key, required this.colors});

  final AppColorPalette colors;

  @override
  State<SearchBar> createState() => SearchBarState();
}

class SearchBarState extends State<SearchBar> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = widget.colors;

    return TextField(
      controller: _controller,
      onChanged: context.read<ExploreCubit>().onQueryChanged,
      style: AppTextStyles.bodyMedium.copyWith(color: colors.onSurface),
      decoration: InputDecoration(
        hintText: 'explore.search_hint'.tr(),
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: colors.secondaryText,
        ),
        prefixIcon: Icon(
          Icons.search_rounded,
          color: colors.secondaryText,
          size: 20,
        ),
        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: _controller,
          builder: (context, value, _) {
            if (value.text.isEmpty) return const SizedBox.shrink();
            return IconButton(
              icon: Icon(
                Icons.close_rounded,
                color: colors.secondaryText,
                size: 18,
              ),
              onPressed: () {
                _controller.clear();
                context.read<ExploreCubit>().clear();
              },
              tooltip: 'explore.clear'.tr(),
            );
          },
        ),
        filled: true,
        fillColor: colors.surface2,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.inputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.primary, width: 1.5),
        ),
      ),
    );
  }
}
