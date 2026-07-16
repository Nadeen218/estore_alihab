import 'package:flutter/material.dart';
import 'package:estor_alihab/app_colors.dart';

class PromoBanner extends StatelessWidget {
  final Color startColor;
  final Color endColor;
  final String currentLocale;

  const PromoBanner({
    Key? key,
    required this.startColor,
    required this.endColor,
    required this.currentLocale,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isArabic = currentLocale == 'ar';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        height: 170,
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
              Positioned(
                left: -30,
                bottom: -30,
                child: CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.white.withOpacity(0.04),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 13,
                    child: Padding(
                      padding: const EdgeInsets.all(22.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              isArabic ? "عروض حصرية" : "Exclusive Offers",
                              style: const TextStyle(color: AppColors.accentGold, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            isArabic
                                ? "أحدث الأجهزة\nبأفضل الأسعار المنافسة"
                                : "Latest Devices\nwith Best Prices",
                            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Cairo', height: 1.3),
                          ),
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                            decoration: BoxDecoration(
                                color: AppColors.accentGreen,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.accentGreen.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  )
                                ]
                            ),
                            child: Text(
                              isArabic ? "تسوق الآن" : "Shop Now",
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11, fontFamily: 'Cairo'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 9,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 16.0),
                      child: Hero(
                        tag: 'promo_iphone',
                        child: Image.network(
                          'https://img.icons8.com/plasticine/200/iphone-x.png',
                          fit: BoxFit.contain,
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
    );
  }
}