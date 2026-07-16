import 'package:flutter/material.dart';
import 'package:estor_alihab/app_colors.dart';

class TrackOrderCard extends StatelessWidget {
  final Color cardBg;
  final Color textMain;
  final Color textSub;
  final String currentLocale;

  const TrackOrderCard({
    Key? key,
    required this.cardBg,
    required this.textMain,
    required this.textSub,
    required this.currentLocale,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isArabic = currentLocale == 'ar';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.accentCyan.withOpacity(0.15), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: AppColors.accentCyan.withOpacity(0.04),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.accentCyan.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.local_shipping_rounded, color: AppColors.accentCyan, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isArabic ? "تتبع حالة طلبك الآن" : "Track your order status",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, fontFamily: 'Cairo', color: textMain),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isArabic ? "بضغطة واحدة اعرف أين وصلت شحنتك" : "One click to know where your shipment is",
                    style: TextStyle(fontSize: 10, fontFamily: 'Cairo', color: textSub),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: textMain.withOpacity(0.04),
                shape: BoxShape.circle,
              ),
              child: Icon(
                  isArabic ? Icons.arrow_back_ios_new_rounded : Icons.arrow_forward_ios_rounded,
                  color: AppColors.accentCyan,
                  size: 12
              ),
            ),
          ],
        ),
      ),
    );
  }
}