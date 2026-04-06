import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class RequestSkeletonList extends StatelessWidget {
  const RequestSkeletonList({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Skeletonizer(
      enabled: true,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 3,
        itemBuilder: (ctx, idx) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.inputBorder),
          ),
          child: Column(
            children: [
              Row(children: [
                const CircleAvatar(radius: 22),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 14, width: 100, color: colors.surface2),
                    const SizedBox(height: 5),
                    Container(height: 11, width: 120, color: colors.surface2),
                  ],
                ),
              ]),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(
                  child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: colors.surface2,
                        borderRadius: BorderRadius.circular(10),
                      )),
                ),
                const SizedBox(width: 8),
                Container(
                    width: 18,
                    height: 18,
                    color: colors.surface2),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: colors.surface2,
                        borderRadius: BorderRadius.circular(10),
                      )),
                ),
              ]),
              const SizedBox(height: 12),
              Container(
                  height: 44,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: colors.surface2,
                    borderRadius: BorderRadius.circular(10),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}