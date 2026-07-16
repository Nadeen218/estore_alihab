import 'package:flutter/material.dart';
import 'package:estor_alihab/app_colors.dart';

class HomeHeader extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onThemeToggle;
  final Color cardBg;
  final Color textMain;
  final Color textSub;

  const HomeHeader({
    Key? key,
    required this.isDarkMode,
    required this.onThemeToggle,
    required this.cardBg,
    required this.textMain,
    required this.textSub,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          // الحساب الشخصي
          Container(
            padding: const EdgeInsets.all(2.5),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [AppColors.accentBlue, AppColors.accentCyan],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: cardBg,
              child: Icon(Icons.person_outline, color: textMain, size: 22),
            ),
          ),
          const Spacer(),
          // شعار المتجر
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "الايهاب",
                style: TextStyle(
                  color: isDarkMode ? AppColors.darkTextLight : AppColors.primaryBlue,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "لخدمات الاتصال",
                style: TextStyle(
                  color: textSub,
                  fontSize: 15.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const Spacer(),
          // زر تبديل الوضع
          GestureDetector(
            onTap: onThemeToggle,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: cardBg,
                shape: BoxShape.circle,
                border: Border.all(color: textMain.withOpacity(0.08), width: 1),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
                child: Icon(
                  isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_round_outlined,
                  key: ValueKey<bool>(isDarkMode),
                  color: isDarkMode ? AppColors.accentGold : AppColors.primaryBlue,
                  size: 20,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // سلة التسوق
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: cardBg,
                  shape: BoxShape.circle,
                  border: Border.all(color: textMain.withOpacity(0.08), width: 1),
                ),
                child: Icon(Icons.shopping_bag_outlined, color: textMain, size: 20),
              ),
              Positioned(
                top: -1,
                left: -1,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    color: AppColors.accentGreen,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                  child: const Center(
                    child: Text(
                      "2",
                      style: TextStyle(color: Colors.white, fontSize: 8.5, fontWeight: FontWeight.bold, height: 1),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}