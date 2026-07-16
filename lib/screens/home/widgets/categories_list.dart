import 'package:flutter/material.dart';
import 'package:estor_alihab/app_colors.dart';

class CategoriesList extends StatelessWidget {
  final Color cardBg;
  final Color textMain;
  final Color textSub;
  final String currentLocale;

  const CategoriesList({
    Key? key,
    required this.cardBg,
    required this.textMain,
    required this.textSub,
    required this.currentLocale,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isArabic = currentLocale == 'ar';

    final List<Map<String, dynamic>> categories = [
      {
        "titleAr": "الأجهزة",
        "titleEn": "Devices",
        "icon": Icons.phone_android_rounded,
        "color": AppColors.accentCyan
      },
      {
        "titleAr": " اجهزة لوحية",
        "titleEn": "Tablets",
        "icon": Icons.tablet_mac_rounded,
        "color": AppColors.accentBlue
      },
      {
        "titleAr": "ساعات ذكية",
        "titleEn": "Smart Watches",
        "icon": Icons.watch_rounded,
        "color": AppColors.accentGold
      },
      {
        "titleAr": "إكسسوار",
        "titleEn": "Accessories",
        "icon": Icons.headphones_rounded,
        "color": AppColors.accentPink
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isArabic ? "تصفح حسب الفئات" : "Browse by Categories",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Cairo', color: textMain),
              ),
              Text(
                isArabic ? "عرض الكل" : "See All",
                style: TextStyle(fontSize: 12, color: textSub, fontFamily: 'Cairo', fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 105,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            itemBuilder: (context, index) {
              final cat = categories[index];
              final Color itemColor = cat["color"];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    Container(
                      width: 62,
                      height: 62,
                      decoration: BoxDecoration(
                        color: cardBg,
                        shape: BoxShape.circle,
                        border: Border.all(color: itemColor.withOpacity(0.15), width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: itemColor.withOpacity(0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Icon(cat["icon"], color: itemColor, size: 26),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isArabic ? cat["titleAr"] : cat["titleEn"],
                      style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, fontFamily: 'Cairo', color: textMain),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}