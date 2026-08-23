import 'package:flutter/material.dart';
import 'package:estor_alihab/app_colors.dart';
import 'widgets/home_header.dart';
import 'widgets/search_bar_widget.dart';
import 'widgets/search_results.dart';
import 'widgets/promo_banner.dart';
import 'widgets/categories_list.dart';
import 'widgets/services_section.dart';
import 'widgets/track_order_card.dart';
import 'widgets/featured_products.dart';
import '../product/products_screen.dart';
import '../track/track_order_screen.dart';
import '../auth/login_screen.dart';
import '../auth/register_screen.dart';
import '../auth/profile_screen.dart';
import '../services/services_hub_screen.dart';
import '../services/sim_screen.dart';
import '../services/fiber_screen.dart';
import '../cart/cart_service.dart';

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
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    isDarkMode = widget.isDarkMode ?? true;
    currentLocale = widget.currentLocale ?? 'ar';
    _isLoggedIn = widget.isLoggedIn ?? false;
  }

  void _checkLoginAndExecute(VoidCallback onAuthenticated) {
    if (_isLoggedIn) {
      onAuthenticated();
    } else {
      _showAuthRequiredDialog(context);
    }
  }

  void _showAuthRequiredDialog(BuildContext parentContext) {
    final isArabic = currentLocale == 'ar';

    showDialog(
      context: parentContext,
      builder: (dialogContext) => Directionality(
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: AlertDialog(
          backgroundColor: isDarkMode ? AppColors.darkBackgroundSecondary : AppColors.lightBackgroundSecondary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppColors.accentBlue.withOpacity(0.1), shape: BoxShape.circle),
                child: const Icon(Icons.lock_outline_rounded, size: 36, color: AppColors.accentBlue),
              ),
              const SizedBox(height: 12),
              Text(
                isArabic ? "تسجيل الدخول مطلوب" : "Login Required",
                textAlign: TextAlign.center,
                style: TextStyle(color: isDarkMode ? AppColors.darkTextLight : AppColors.lightTextDark, fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
          content: Text(
            isArabic ? "للوصول إلى هذه الخدمة وإتمام الطلب، يرجى تسجيل الدخول أو إنشاء حساب جديد." : "To access this feature and complete your request, please log in or create a new account.",
            textAlign: TextAlign.center,
            style: TextStyle(color: isDarkMode ? AppColors.darkTextMuted : AppColors.lightTextMuted, fontFamily: 'Cairo', fontSize: 13, height: 1.5),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          actions: [
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.accentBlue), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), padding: const EdgeInsets.symmetric(vertical: 10)),
                    onPressed: () async {
                      Navigator.of(dialogContext).pop();
                      final result = await Navigator.of(parentContext).push<bool>(MaterialPageRoute(builder: (context) => RegisterScreen(isDarkMode: isDarkMode, currentLocale: currentLocale)));
                      if (result == true) setState(() => _isLoggedIn = true);
                    },
                    child: Text(isArabic ? "حساب جديد" : "Sign Up", style: const TextStyle(color: AppColors.accentBlue, fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentBlue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), padding: const EdgeInsets.symmetric(vertical: 10), elevation: 0),
                    onPressed: () async {
                      Navigator.of(dialogContext).pop();
                      final result = await Navigator.of(parentContext).push<bool>(MaterialPageRoute(builder: (context) => LoginScreen(isDarkMode: isDarkMode, currentLocale: currentLocale)));
                      if (result == true) setState(() => _isLoggedIn = true);
                    },
                    child: Text(isArabic ? "تسجيل الدخول" : "Login", style: const TextStyle(color: Colors.white, fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToCategory(String categoryName) {
    _checkLoginAndExecute(() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductsScreen(
            isDarkMode: isDarkMode,
            currentLocale: currentLocale,
            initialCategory: categoryName,
          ),
        ),
      );
    });
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
    final isSearching = _searchQuery.trim().isNotEmpty;

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                ValueListenableBuilder<List<CartItem>>(
                  valueListenable: CartService.cartItemsNotifier,
                  builder: (context, cartItems, _) {
                    final cartCount = cartItems.fold<int>(0, (sum, item) => sum + item.quantity);
                    return HomeHeader(
                      isDarkMode: isDarkMode,
                      cardBg: cardColor,
                      textMain: textColor,
                      textSub: textMutedColor,
                      isLoggedIn: _isLoggedIn,
                      currentLocale: currentLocale,
                      onLoginStatusChanged: (status) => setState(() => _isLoggedIn = status),
                      onThemeToggle: () => setState(() => isDarkMode = !isDarkMode),
                      onLogout: () => setState(() => _isLoggedIn = false),
                      cartItemCount: cartCount,
                    );
                  },
                ),
                const SizedBox(height: 20),
                SearchBarWidget(
                  isDarkMode: isDarkMode,
                  cardBg: cardColor,
                  textMain: textColor,
                  textSub: textMutedColor,
                  currentLocale: currentLocale,
                  onLanguageToggle: () => setState(() => currentLocale = currentLocale == 'ar' ? 'en' : 'ar'),
                  onSearchChanged: (val) => setState(() => _searchQuery = val),
                ),
                const SizedBox(height: 24),
                if (isSearching)
                  SearchResults(
                    isDarkMode: isDarkMode,
                    cardBg: cardColor,
                    textMain: textColor,
                    textSub: textMutedColor,
                    currentLocale: currentLocale,
                    searchQuery: _searchQuery,
                    onCheckLogin: (action) => _checkLoginAndExecute(action),
                  )
                else ...[
                  PromoBanner(
                    startColor: gradientStart,
                    endColor: gradientEnd,
                    currentLocale: currentLocale,
                    onTap: () => _navigateToCategory('الأجهزة'),
                  ),
                  const SizedBox(height: 28),
                  CategoriesList(
                    isDarkMode: isDarkMode,
                    cardBg: cardColor,
                    textMain: textColor,
                    textSub: textMutedColor,
                    currentLocale: currentLocale,
                    onCategorySelected: (categoryName) => _navigateToCategory(categoryName),
                  ),
                  const SizedBox(height: 28),
                  ServicesSection(
                    isDarkMode: isDarkMode,
                    cardBg: cardColor,
                    textMain: textColor,
                    textSub: textMutedColor,
                    currentLocale: currentLocale,
                    onSimTap: () {
                      _checkLoginAndExecute(() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SimScreen(
                              isDarkMode: isDarkMode,
                              currentLocale: currentLocale,
                            ),
                          ),
                        );
                      });
                    },
                    onFiberTap: () {
                      _checkLoginAndExecute(() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FiberScreen(
                              isDarkMode: isDarkMode,
                              currentLocale: currentLocale,
                            ),
                          ),
                        );
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  TrackOrderCard(
                    cardBg: cardColor,
                    textMain: textColor,
                    textSub: textMutedColor,
                    currentLocale: currentLocale,
                    onTap: () => _checkLoginAndExecute(() => Navigator.push(context, MaterialPageRoute(builder: (context) => TrackOrderScreen(isDarkMode: isDarkMode, currentLocale: currentLocale, isLoggedIn: _isLoggedIn)))),
                  ),
                  const SizedBox(height: 28),
                  FeaturedProducts(
                    isDarkMode: isDarkMode,
                    cardBg: cardColor,
                    textMain: textColor,
                    currentLocale: currentLocale,
                    onCheckLogin: (action) => _checkLoginAndExecute(action),
                  ),
                ],
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
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(isDarkMode ? 0.25 : 0.08), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            if (index == 0) {
              setState(() => _currentIndex = 0);
            } else if (index == 1) {
              _checkLoginAndExecute(() {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ServicesHubScreen(isDarkMode: isDarkMode, currentLocale: currentLocale)));
              });
            } else if (index == 2) {
              _checkLoginAndExecute(() => Navigator.push(context, MaterialPageRoute(builder: (context) => ProductsScreen(isDarkMode: isDarkMode, currentLocale: currentLocale))));
            } else if (index == 3) {
              _checkLoginAndExecute(() => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(isDarkMode: isDarkMode, currentLocale: currentLocale, onLogout: () => setState(() => _isLoggedIn = false)))));
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
            BottomNavigationBarItem(icon: const Icon(Icons.home_outlined), activeIcon: const Icon(Icons.home_rounded), label: isArabic ? "الرئيسية" : "Home"),
            BottomNavigationBarItem(icon: const Icon(Icons.bolt_outlined), activeIcon: const Icon(Icons.bolt_rounded), label: isArabic ? "الخدمات" : "Services"),
            BottomNavigationBarItem(icon: const Icon(Icons.storefront_outlined), activeIcon: const Icon(Icons.storefront_rounded), label: isArabic ? "المتجر" : "Store"),
            BottomNavigationBarItem(icon: const Icon(Icons.person_outline), activeIcon: const Icon(Icons.person_rounded), label: isArabic ? "حسابي" : "Profile"),
          ],
        ),
      ),
    );
  }
}