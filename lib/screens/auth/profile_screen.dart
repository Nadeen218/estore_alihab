import 'package:flutter/material.dart';
import 'package:estor_alihab/app_colors.dart';
import 'package:estor_alihab/services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  final bool isDarkMode;
  final String currentLocale;
  final VoidCallback onLogout;
  final int ordersCount;
  final int reviewsCount;
  final List<Map<String, dynamic>> orderHistory;
  final String userAddressAr;
  final String userAddressEn;

  const ProfileScreen({
    Key? key,
    required this.isDarkMode,
    required this.currentLocale,
    required this.onLogout,
    this.ordersCount = 0,
    this.reviewsCount = 0,
    this.orderHistory = const [],
    this.userAddressAr = "لم يتم تحديد عنوان",
    this.userAddressEn = "No address specified",
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = "";
  String userEmail = "";
  bool _isLoadingUser = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final data = await AuthService.getUserData();
      if (!mounted) return;
      setState(() {
        userName = data?['name'] ?? '';
        userEmail = data?['email'] ?? '';
        _isLoadingUser = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoadingUser = false;
      });
    }
  }

  void _showAddressesSheet(bool isArabic) {
    showModalBottomSheet(
      context: context,
      backgroundColor: widget.isDarkMode
          ? AppColors.darkBackgroundSecondary
          : AppColors.lightBackgroundSecondary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isArabic ? "عناوين التوصيل المسجلة" : "Saved Delivery Addresses",
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: widget.isDarkMode
                    ? AppColors.darkTextLight
                    : AppColors.lightTextDark,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.location_pin, color: Colors.purple),
              title: Text(
                isArabic ? widget.userAddressAr : widget.userAddressEn,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: widget.isDarkMode
                      ? AppColors.darkTextLight
                      : AppColors.lightTextDark,
                ),
              ),
              subtitle: Text(
                isArabic ? "العنوان الرئيسي" : "Default Address",
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 12,
                  color: widget.isDarkMode
                      ? AppColors.darkTextMuted
                      : AppColors.lightTextMuted,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showOrderHistorySheet(bool isArabic) {
    showModalBottomSheet(
      context: context,
      backgroundColor: widget.isDarkMode
          ? AppColors.darkBackgroundSecondary
          : AppColors.lightBackgroundSecondary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isArabic ? "تفاصيل سجل الطلبات" : "Order History Details",
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: widget.isDarkMode
                    ? AppColors.darkTextLight
                    : AppColors.lightTextDark,
              ),
            ),
            const SizedBox(height: 16),
            widget.orderHistory.isEmpty
                ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  isArabic ? "لا توجد طلبات سابقة" : "No previous orders",
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: widget.isDarkMode
                        ? AppColors.darkTextMuted
                        : AppColors.lightTextMuted,
                  ),
                ),
              ),
            )
                : Column(
              children: widget.orderHistory.map((order) => ListTile(
                leading: const Icon(Icons.inventory_2_outlined, color: Colors.amber),
                title: Text(
                  isArabic ? (order["nameAr"] ?? '') : (order["nameEn"] ?? ''),
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                    color: widget.isDarkMode
                        ? AppColors.darkTextLight
                        : AppColors.lightTextDark,
                  ),
                ),
                trailing: Text(
                  "${isArabic ? 'عدد المرات:' : 'Count:'} ${order["count"] ?? 0}",
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    color: AppColors.accentBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )).toList(),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = widget.currentLocale == 'ar';
    final backgroundColor = widget.isDarkMode
        ? AppColors.darkBackground
        : AppColors.lightBackground;
    final cardColor = widget.isDarkMode
        ? AppColors.darkBackgroundSecondary
        : AppColors.lightBackgroundSecondary;
    final textColor = widget.isDarkMode
        ? AppColors.darkTextLight
        : AppColors.lightTextDark;

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: Icon(
              isArabic
                  ? Icons.arrow_forward_ios_rounded
                  : Icons.arrow_back_ios_new_rounded,
              color: textColor,
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: Text(
            isArabic ? "الملف الشخصي" : "Profile",
            style: TextStyle(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                decoration: const BoxDecoration(
                  color: AppColors.accentBlue,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(38), // البديل الآمن الحديث لـ withOpacity
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person_outline_rounded,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _isLoadingUser
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                        : Text(
                      userName.isNotEmpty ? userName : (isArabic ? "مستخدم" : "User"),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (!_isLoadingUser)
                      Text(
                        userEmail,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatItem(
                          isArabic ? "طلبات" : "Orders",
                          widget.ordersCount.toString(),
                        ),
                        _buildStatItem(
                          isArabic ? "مراجعات" : "Reviews",
                          widget.reviewsCount.toString(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildProfileOption(
                      icon: Icons.location_on_outlined,
                      iconColor: Colors.purple,
                      iconBg: Colors.purple.withAlpha(25),
                      title: isArabic ? "عناوينّي" : "My Addresses",
                      cardColor: cardColor,
                      textColor: textColor,
                      isArabic: isArabic,
                      onTap: () => _showAddressesSheet(isArabic),
                    ),
                    _buildProfileOption(
                      icon: Icons.inventory_2_outlined,
                      iconColor: Colors.amber,
                      iconBg: Colors.amber.withAlpha(25),
                      title: isArabic ? "سجل طلباتي" : "Order History",
                      cardColor: cardColor,
                      textColor: textColor,
                      isArabic: isArabic,
                      onTap: () => _showOrderHistorySheet(isArabic),
                    ),
                    const SizedBox(height: 10),
                    _buildProfileOption(
                      icon: Icons.logout_rounded,
                      iconColor: Colors.redAccent,
                      iconBg: Colors.redAccent.withAlpha(25),
                      title: isArabic ? "تسجيل الخروج" : "Log Out",
                      cardColor: cardColor,
                      textColor: Colors.redAccent,
                      isLogout: true,
                      isArabic: isArabic,
                      onTap: () async {
                        await AuthService.logout();
                        widget.onLogout();
                        if (mounted) Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Cairo',
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
            fontFamily: 'Cairo',
          ),
        ),
      ],
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required Color cardColor,
    required Color textColor,
    required VoidCallback onTap,
    required bool isArabic,
    bool isLogout = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconBg,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontFamily: 'Cairo',
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        trailing: isLogout
            ? null
            : Icon(
          isArabic
              ? Icons.chevron_left_rounded
              : Icons.chevron_right_rounded,
          color: textColor.withAlpha(100),
        ),
        onTap: onTap,
      ),
    );
  }
}