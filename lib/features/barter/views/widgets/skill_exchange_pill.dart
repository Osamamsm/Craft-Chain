import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class SkillExchangePill extends StatelessWidget {
  const SkillExchangePill({super.key, 
    required this.label,
    required this.skill,
    required this.bgColor,
    required this.textColor,
    required this.icon,
  });
  final String label;
  final String skill;
  final Color bgColor;
  final Color textColor;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 12, color: textColor),
              const SizedBox(width: 4),
              Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  color: textColor,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            skill,
            style: AppTextStyles.bodySmall.copyWith(
              color: textColor,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
