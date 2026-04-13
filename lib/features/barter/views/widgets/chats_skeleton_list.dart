import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ChatsSkeletonList extends StatelessWidget {
  const ChatsSkeletonList({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Skeletonizer(
      enabled: true,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: 4,
        separatorBuilder: (ctx, idx) =>
            Divider(height: 1, indent: 76, color: colors.inputBorder),
        itemBuilder: (ctx, idx) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              const CircleAvatar(radius: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 14, width: 120, color: colors.surface2),
                    const SizedBox(height: 6),
                    Container(height: 11, width: 90, color: colors.surface2),
                    const SizedBox(height: 5),
                    Container(height: 11, width: 200, color: colors.surface2),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
