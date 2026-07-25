import 'package:flutter/material.dart';
import 'package:estor_alihab/app_colors.dart';
import 'widgets/home_header.dart';
import 'widgets/search_bar_widget.dart';
import 'widgets/promo_banner.dart';
import 'widgets/categories_list.dart';
import 'widgets/services_section.dart';
import 'widgets/track_order_card.dart';
import 'widgets/featured_products.dart';
import '../product/products_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  bool isDarkMode = true;
  String currentLocale = 'ar'; // اللغة العربية تلقائياً

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isDarkMode ? AppColors.darkBackground : AppColors.lightBackground;
    final cardColor = isDarkMode ? AppColors.darkBackgroundSecondary : AppColors.lightBackgroundSecondary;
    final textColor = isDarkMode ? AppColors.darkTextLight : AppColors.lightTextDark;
    final textMutedColor = isDarkMode ? AppColors.darkTextMuted : AppColors.lightTextMuted;
    final gradientStart = isDarkMode ? AppColors.darkCardGradientStart : AppColors.lightCardGradientStart;
    final gradientEnd = isDarkMode ? AppColors.darkCardGradientEnd : AppColors.lightCardGradientEnd;

    final isArabic = currentLocale == 'ar';

    return Directionality(
      // يقوم بعكس اتجاه التطبيق كلياً عند تغيير اللغة!
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: backgroundColor,
        floatingActionButtonLocation: isArabic
            ? FloatingActionButtonLocation.startFloat
            : FloatingActionButtonLocation.endFloat,

        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                // 1. الهيدر (العنوان والتنبيهات)
                HomeHeader(
                  isDarkMode: isDarkMode,
                  cardBg: cardColor,
                  textMain: textColor,
                  textSub: textMutedColor,
                  onThemeToggle: () {
                    setState(() {
                      isDarkMode = !isDarkMode;
                    });
                  },
                ),
                const SizedBox(height: 20),

                // 2. شريط البحث وتعديل اللغة التفاعلي
                SearchBarWidget(
                  isDarkMode: isDarkMode,
                  cardBg: cardColor,
                  textMain: textColor,
                  textSub: textMutedColor,
                  currentLocale: currentLocale,
                  onLanguageToggle: () {
                    setState(() {
                      currentLocale = currentLocale == 'ar' ? 'en' : 'ar';
                    });
                  },
                ),
                const SizedBox(height: 24),

                // 3. البانر الإعلاني
                PromoBanner(
                  startColor: gradientStart,
                  endColor: gradientEnd,
                  currentLocale: currentLocale,
                ),
                const SizedBox(height: 28),

                // 4. التصنيفات
                CategoriesList(
                  isDarkMode: isDarkMode,
                  cardBg: cardColor,
                  textMain: textColor,
                  textSub: textMutedColor,
                  currentLocale: currentLocale,
                ),
                const SizedBox(height: 28),

                // 5. قسم الخدمات الرقمية
                ServicesSection(
                  isDarkMode: isDarkMode,
                  cardBg: cardColor,
                  textMain: textColor,
                  textSub: textMutedColor,
                  currentLocale: currentLocale,
                ),
                const SizedBox(height: 20),

                // 6. كرت تتبع الشحنات والطلب
                TrackOrderCard(
                  cardBg: cardColor,
                  textMain: textColor,
                  textSub: textMutedColor,
                  currentLocale: currentLocale,
                ),
                const SizedBox(height: 28),

                // 7. المنتجات الأكثر مبيعاً
                FeaturedProducts(
                  isDarkMode: isDarkMode,
                  cardBg: cardColor,
                  textMain: textColor,
                  currentLocale: currentLocale,
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),

        // 8. شريط التنقل السفلي العائم والمترجم
        bottomNavigationBar: _buildBottomNavigationBar(cardColor, textMutedColor, isArabic),
      ),
    );
  }

  Widget _buildBottomNavigationBar(Color cardBg, Color textSub, bool isArabic) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      decoration: BoxDecoration(
        color: cardBg.withOpacity(0.95),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: isDarkMode ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.04), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.25 : 0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            if (index == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductsScreen(
                    isDarkMode: isDarkMode,
                    currentLocale: currentLocale,
                  ),
                ),
              ).then((_) {
                setState(() {
                  _currentIndex = 0;
                });
              });
            } else {
              setState(() {
                _currentIndex = index;
              });
            }
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: AppColors.accentBlue,
          unselectedItemColor: textSub,
          selectedLabelStyle: const TextStyle(fontFamily: 'Cairo', fontSize: 11, fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontFamily: 'Cairo', fontSize: 11),
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              activeIcon: const Icon(Icons.home_rounded),
              label: isArabic ? "الرئيسية" : "Home",
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.bolt_outlined),
              activeIcon: const Icon(Icons.bolt_rounded),
              label: isArabic ? "الخدمات" : "Services",
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.storefront_outlined),
              activeIcon: const Icon(Icons.storefront_rounded),
              label: isArabic ? "المتجر" : "Store",
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_outline),
              activeIcon: const Icon(Icons.person_rounded),
              label: isArabic ? "حسابي" : "Profile",
            ),
          ],
        ),
      ),
    );
  }
}