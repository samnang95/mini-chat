import 'package:flutter/widgets.dart';
import 'package:mini_chat/core/theme/app_colors.dart';

class NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final double height;
  final VoidCallback onTap;
  final int? badgeCount;

  const NavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.height,
    required this.onTap,
    this.badgeCount,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.primaryDark : AppColors.textSecondary;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          height: height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(icon, color: color),
                  if (badgeCount != null && badgeCount! > 0)
                    Positioned(
                      right: -8,
                      top: -6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          badgeCount! > 99 ? '99+' : badgeCount.toString(),
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(label, style: TextStyle(color: color, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}
