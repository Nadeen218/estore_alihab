import 'package:flutter/material.dart';
import 'package:estor_alihab/app_colors.dart';
import 'maintenance_screen.dart';
import 'fiber_screen.dart';
class ServicesHubScreen extends StatelessWidget {
  final bool isDarkMode;
  final String currentLocale;

  const ServicesHubScreen({
    Key? key,
    required this.isDarkMode,
    required this.currentLocale,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isArabic = currentLocale == 'ar';
    final backgroundColor = isDarkMode ? AppColors.darkBackground : AppColors.lightBackground;
    final cardColor = isDarkMode ? AppColors.darkBackgroundSecondary : AppColors.lightBackgroundSecondary;
    final textColor = isDarkMode ? AppColors.darkTextLight : AppColors.lightTextDark;
    final textMuted = isDarkMode ? AppColors.darkTextMuted : AppColors.lightTextMuted;

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
              isArabic ? Icons.arrow_forward_ios_rounded : Icons.arrow_back_ios_new_rounded,
              color: textColor,
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: Text(
            isArabic ? "الخدمات المتخصصة" : "Specialized Services",
            style: TextStyle(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildServiceCard(
              context: context,
              icon: Icons.wifi_rounded,
              iconColor: Colors.blueAccent,
              title: isArabic ? "جوال فايبر (Fiber)" : "Jawwal Fiber",
              subtitle: isArabic ? "إنترنت منزلي فائق السرعة وباقات مميزة" : "High-speed home internet & bundles",
              cardColor: cardColor,
              textColor: textColor,
              textMuted: textMuted,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FiberScreen(
                      isDarkMode: isDarkMode,
                      currentLocale: currentLocale,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 14),
            _buildServiceCard(
              context: context,
              icon: Icons.sim_card_rounded,
              iconColor: Colors.orangeAccent,
              title: isArabic ? "شرائح الاتصال (SIM)" : "SIM Cards",
              subtitle: isArabic ? "طلب وتفعيل شرائح جديدة وباقات الخطوط" : "Order & activate new lines and bundles",
              cardColor: cardColor,
              textColor: textColor,
              textMuted: textMuted,
              onTap: () {},
            ),
            const SizedBox(height: 14),
            _buildServiceCard(
              context: context,
              icon: Icons.build_rounded,
              iconColor: Colors.greenAccent,
              title: isArabic ? "صيانة الأجهزة" : "Device Maintenance",
              subtitle: isArabic ? "إصلاح الأعطال، الشاشات، والبطاريات" : "Repair broken screens, batteries & issues",
              cardColor: cardColor,
              textColor: textColor,
              textMuted: textMuted,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MaintenanceScreen(
                      isDarkMode: isDarkMode,
                      currentLocale: currentLocale,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required Color cardColor,
    required Color textColor,
    required Color textMuted,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 24),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 15,
            fontFamily: 'Cairo',
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            subtitle,
            style: TextStyle(
              color: textMuted,
              fontSize: 12,
              fontFamily: 'Cairo',
            ),
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
          color: textMuted,
        ),
        onTap: onTap,
      ),
    );
  }
}