import 'package:flutter/material.dart';
import 'package:mini_chat/core/theme/app_colors.dart';
import 'package:mini_chat/core/theme/app_typography.dart';

class LanguageOption extends StatelessWidget {
  final String? title;
  final String? flag;
  final bool? isSelected;
  final VoidCallback? onTap;
  const LanguageOption({
    super.key,
    this.title,
    this.flag,
    this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: h * 0.06,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          width: double.infinity,
          decoration: BoxDecoration(
            color: (isSelected ?? false)
                ? AppColors.primary
                : AppColors.primary,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (flag != null) ...[
                    Image.asset(flag!, width: 24, height: 24),
                    const SizedBox(width: 12),
                  ],
                  Text(
                    title ?? "",
                    style: AppTypography.bodyMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              _switch(isSelected ?? false),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _switch(bool isSelected) {
  return Container(
    width: 24,
    height: 24,
    decoration: BoxDecoration(
      color: isSelected ? Colors.white : Colors.transparent,
      shape: BoxShape.circle,
      border: Border.all(
        color: isSelected ? Colors.white : Colors.grey.shade400,
        width: 2,
      ),
    ),
    child: isSelected
        ? const Icon(Icons.check, color: Colors.green, size: 16)
        : null,
  );
}
