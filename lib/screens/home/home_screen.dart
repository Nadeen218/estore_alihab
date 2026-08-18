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
import '../track/track_order_screen.dart';

class HomeScreen extends StatefulWidget {
  final bool? isDarkMode;
  final String? currentLocale;
  final bool? isLoggedIn;

  const HomeScreen({
    Key? key,
    this.isDarkMode,
    this.currentLocale,
    this.isLoggedIn,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late bool isDarkMode;
  late String currentLocale;
  late bool _isLoggedIn;

  @override
  void initState() {
    super.initState();
    isDarkMode = widget.isDarkMode ?? true;
    currentLocale = widget.currentLocale ?? 'ar';
    _isLoggedIn = widget.isLoggedIn ?? false;
  }

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

                HomeHeader(
                  isDarkMode: isDarkMode,
                  cardBg: cardColor,
                  textMain: textColor,
                  textSub: textMutedColor,
                  isLoggedIn: _isLoggedIn,
                  currentLocale: currentLocale,
                  onLoginStatusChanged: (status) {
                    setState(() {
                      _isLoggedIn = status;
                    });
                  },
                  onThemeToggle: () {
                    setState(() {
                      isDarkMode = !isDarkMode;
                    });
                  },
                ),
                const SizedBox(height: 20),

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

                PromoBanner(
                  startColor: gradientStart,
                  endColor: gradientEnd,
                  currentLocale: currentLocale,
                ),
                const SizedBox(height: 28),

                CategoriesList(
                  isDarkMode: isDarkMode,
                  cardBg: cardColor,
                  textMain: textColor,
                  textSub: textMutedColor,
                  currentLocale: currentLocale,
                ),
                const SizedBox(height: 28),

                ServicesSection(
                  isDarkMode: isDarkMode,
                  cardBg: cardColor,
                  textMain: textColor,
                  textSub: textMutedColor,
                  currentLocale: currentLocale,
                ),
                const SizedBox(height: 20),

                TrackOrderCard(
                  cardBg: cardColor,
                  textMain: textColor,
                  textSub: textMutedColor,
                  currentLocale: currentLocale,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TrackOrderScreen(
                          isDarkMode: isDarkMode,
                          currentLocale: currentLocale,
                          isLoggedIn: _isLoggedIn,
                        ),
                      ),
                    ).then((result) {
                      if (result != null && result is Map<String, dynamic>) {
                        setState(() {
                          if (result.containsKey('isDarkMode')) {
                            isDarkMode = result['isDarkMode'];
                          }
                          if (result.containsKey('currentLocale')) {
                            currentLocale = result['currentLocale'];
                          }
                          if (result.containsKey('isLoggedIn')) {
                            _isLoggedIn = result['isLoggedIn'];
                          }
                        });
                      }
                    });
                  },
                ),
                const SizedBox(height: 28),

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
              ).then((result) {
                if (result != null && result is Map<String, dynamic>) {
                  setState(() {
                    _currentIndex = 0;
                    if (result.containsKey('isDarkMode')) {
                      isDarkMode = result['isDarkMode'];
                    }
                    if (result.containsKey('currentLocale')) {
                      currentLocale = result['currentLocale'];
                    }
                  });
                } else {
                  setState(() {
                    _currentIndex = 0;
                  });
                }
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