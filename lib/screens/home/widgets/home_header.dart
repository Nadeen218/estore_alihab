import 'package:flutter/material.dart';
import 'package:estor_alihab/app_colors.dart';
import '../../cart/cart_screen.dart';
import '../../auth/login_screen.dart';
import '../../auth/register_screen.dart';
import '../../auth/profile_screen.dart';

class HomeHeader extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onThemeToggle;
  final Color cardBg;
  final Color textMain;
  final Color textSub;
  final bool isLoggedIn;
  final ValueChanged<bool> onLoginStatusChanged;
  final String currentLocale;
  final VoidCallback onLogout;
  final int cartItemCount;

  const HomeHeader({
    Key? key,
    required this.isDarkMode,
    required this.onThemeToggle,
    required this.cardBg,
    required this.textMain,
    required this.textSub,
    required this.isLoggedIn,
    required this.onLoginStatusChanged,
    required this.onLogout,
    this.currentLocale = 'ar',
    this.cartItemCount = 0,
  }) : super(key: key);

  void _navigateToCart(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartScreen(
          isDarkMode: isDarkMode,
          currentLocale: currentLocale,
        ),
      ),
    );
  }

  void _navigateToProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileScreen(
          isDarkMode: isDarkMode,
          currentLocale: currentLocale,
          onLogout: () {
            onLoginStatusChanged(false);
            onLogout();
          },
        ),
      ),
    );
  }

  void _handleCartClick(BuildContext context) {
    if (isLoggedIn) {
      _navigateToCart(context);
    } else {
      _showAuthRequiredDialog(
        context,
        onSuccess: (ctx) => _navigateToCart(ctx),
        customMessage: currentLocale == 'ar'
            ? "للوصول إلى سلة التسوق وإتمام عملية الشراء، يرجى تسجيل الدخول أو إنشاء حساب جديد."
            : "To access the cart and complete your purchase, please log in or create a new account.",
      );
    }
  }

  void _handleProfileClick(BuildContext context) {
    if (isLoggedIn) {
      _navigateToProfile(context);
    } else {
      _showAuthRequiredDialog(
        context,
        onSuccess: (ctx) => _navigateToProfile(ctx),
        customMessage: currentLocale == 'ar'
            ? "للوصول إلى صفحة حسابك الشخصي، يرجى تسجيل الدخول أو إنشاء حساب جديد."
            : "To access your profile, please log in or create a new account.",
      );
    }
  }

  void _showAuthRequiredDialog(
      BuildContext parentContext, {
        required void Function(BuildContext) onSuccess,
        required String customMessage,
      }) {
    final isArabic = currentLocale == 'ar';

    showDialog(
      context: parentContext,
      builder: (dialogContext) => Directionality(
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: AlertDialog(
          backgroundColor: isDarkMode
              ? AppColors.darkBackgroundSecondary
              : AppColors.lightBackgroundSecondary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.accentBlue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lock_outline_rounded,
                  size: 36,
                  color: AppColors.accentBlue,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                isArabic ? "تسجيل الدخول مطلوب" : "Login Required",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDarkMode ? AppColors.darkTextLight : AppColors.lightTextDark,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          content: Text(
            customMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDarkMode ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              fontFamily: 'Cairo',
              fontSize: 13,
              height: 1.5,
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          actions: [
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.accentBlue),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    onPressed: () async {
                      Navigator.of(dialogContext).pop();

                      final result = await Navigator.of(parentContext).push<bool>(
                        MaterialPageRoute(
                          builder: (context) => RegisterScreen(
                            isDarkMode: isDarkMode,
                            currentLocale: currentLocale,
                          ),
                        ),
                      );

                      if (result == true) {
                        onLoginStatusChanged(true);
                        onSuccess(parentContext);
                      }
                    },
                    child: Text(
                      isArabic ? "حساب جديد" : "Sign Up",
                      style: const TextStyle(
                        color: AppColors.accentBlue,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentBlue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      elevation: 0,
                    ),
                    onPressed: () async {
                      Navigator.of(dialogContext).pop();

                      final result = await Navigator.of(parentContext).push<bool>(
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(
                            isDarkMode: isDarkMode,
                            currentLocale: currentLocale,
                          ),
                        ),
                      );

                      if (result == true) {
                        onLoginStatusChanged(true);
                        onSuccess(parentContext);
                      }
                    },
                    child: Text(
                      isArabic ? "تسجيل الدخول" : "Login",
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _handleProfileClick(context),
            child: Container(
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
          ),
          const Spacer(),
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
          GestureDetector(
            onTap: () => _handleCartClick(context),
            child: Stack(
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
                if (cartItemCount > 0)
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
                      child: Center(
                        child: Text(
                          cartItemCount > 9 ? '9+' : '$cartItemCount',
                          style: const TextStyle(color: Colors.white, fontSize: 8.5, fontWeight: FontWeight.bold, height: 1),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}