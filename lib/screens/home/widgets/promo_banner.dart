import 'package:flutter/material.dart';
import 'package:estor_alihab/app_colors.dart';

class PromoBanner extends StatelessWidget {
  final Color startColor;
  final Color endColor;
  final String currentLocale;
  final VoidCallback? onTap;

  const PromoBanner({
    Key? key,
    required this.startColor,
    required this.endColor,
    required this.currentLocale,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isArabic = currentLocale == 'ar';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 185,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
              colors: [startColor, endColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: startColor.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Stack(
              children: [
                // خلفية دائرية خفيفة (اختياري، ممكن تشيلها إذا الصورة رح تغطيها)
                Positioned(
                  right: -30,
                  top: -30,
                  child: CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.white.withOpacity(0.05),
                  ),
                ),

                Row(
                  children: [
                    // ===== النص =====
                    Expanded(
                      flex: 11,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18.0, vertical: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                isArabic ? "عروض حصرية" : "Exclusive Offers",
                                style: const TextStyle(
                                    color: AppColors.accentGold,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Cairo'),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              isArabic
                                  ? "أحدث الأجهزة\nبأفضل الأسعار المنافسة"
                                  : "Latest Devices\nwith Best Prices",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Cairo',
                                  height: 1.3),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 8),
                              decoration: BoxDecoration(
                                  color: AppColors.accentGreen,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.accentGreen
                                          .withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    )
                                  ]),
                              child: Text(
                                isArabic ? "تسوق الآن" : "Shop Now",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    fontFamily: 'Cairo'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ===== الصورة: بدون padding وبحجم أكبر بحيث تغطي الجزء الثاني بالكامل =====
                    Expanded(
                      flex: 10,
                      child: SizedBox(
                        height: 185,
                        child: Hero(
                          tag: 'promo_iphone',
                          child: Image.asset(
                            'assets/images/bann.jpg',
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.phone_iphone,
                                  color: Colors.white24, size: 60);
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}