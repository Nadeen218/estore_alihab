import 'package:flutter/material.dart';
import 'package:estor_alihab/app_colors.dart';

class ServicesSection extends StatelessWidget {
  final bool isDarkMode;
  final Color cardBg;
  final Color textMain;
  final Color textSub;
  final String currentLocale;
  final VoidCallback? onSimTap;
  final VoidCallback? onFiberTap;

  const ServicesSection({
    Key? key,
    required this.isDarkMode,
    required this.cardBg,
    required this.textMain,
    required this.textSub,
    required this.currentLocale,
    this.onSimTap,
    this.onFiberTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isArabic = currentLocale == 'ar';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isArabic ? "خدماتنا الرقمية" : "Our Digital Services",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Cairo', color: textMain),
              ),
              Text(
                isArabic ? "المزيد" : "More",
                style: TextStyle(fontSize: 12, color: textSub, fontFamily: 'Cairo', fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onSimTap,
                  child: _buildServiceItem(
                    isArabic ? "شرائح الاتصال" : "SIM Cards",
                    isArabic ? "احصل على شريحتك فوراً" : "Get your SIM card now",
                    Icons.sim_card_outlined,
                    AppColors.accentGold,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: GestureDetector(
                  onTap: onFiberTap,
                  child: _buildServiceItem(
                    isArabic ? "جوال فايبر" : "Jawwal Fiber",
                    isArabic ? "سرعة إنترنت مذهلة" : "Super fast internet",
                    Icons.bolt_rounded,
                    AppColors.accentBlue,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildServiceItem(String title, String subtitle, IconData icon, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: textMain.withOpacity(0.04), width: 1.5),
        boxShadow: isDarkMode
            ? []
            : [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: TextStyle(color: textMain, fontWeight: FontWeight.bold, fontSize: 13.5, fontFamily: 'Cairo'),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(color: textSub.withOpacity(0.8), fontSize: 10, fontFamily: 'Cairo'),
          ),
        ],
      ),
    );
  }
}