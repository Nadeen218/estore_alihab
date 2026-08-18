import 'package:flutter/material.dart';
import 'package:estor_alihab/app_colors.dart';
import '../../product/product_details_screen.dart';
import '../../product/products_screen.dart';

class FeaturedProducts extends StatelessWidget {
  final bool isDarkMode;
  final Color cardBg;
  final Color textMain;
  final String currentLocale;
  final Function(VoidCallback) onCheckLogin;

  const FeaturedProducts({
    Key? key,
    required this.isDarkMode,
    required this.cardBg,
    required this.textMain,
    required this.currentLocale,
    required this.onCheckLogin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isArabic = currentLocale == 'ar';

    final List<Map<String, dynamic>> products = [
      {
        "id": "1",
        "title": "iPhone 15 Pro Max",
        "price": "4,500 ₪",
        "rating": 5.0,
        "image": "https://img.icons8.com/plasticine/200/iphone-x.png",
      },
      {
        "id": "2",
        "title": "Samsung Galaxy S24 Ultra",
        "price": "3,800 ₪",
        "rating": 4.0,
        "image": "https://img.icons8.com/plasticine/200/android-os.png",
      },
      {
        "id": "3",
        "title": "MacBook Pro M3",
        "price": "6,200 ₪",
        "rating": 5.0,
        "image": "https://img.icons8.com/plasticine/200/macbook.png",
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
                isArabic ? "المنتجات الأكثر مبيعاً" : "Best Selling Products",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Cairo', color: textMain),
              ),
              GestureDetector(
                onTap: () {
                  onCheckLogin(() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductsScreen(
                          isDarkMode: isDarkMode,
                          currentLocale: currentLocale,
                        ),
                      ),
                    );
                  });
                },
                child: Text(
                  isArabic ? "عرض الكل" : "See All",
                  style: TextStyle(fontSize: 12, color: isDarkMode ? AppColors.darkTextMuted : AppColors.lightTextMuted, fontFamily: 'Cairo', fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            itemBuilder: (context, index) {
              final prod = products[index];
              return GestureDetector(
                onTap: () {
                  onCheckLogin(() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailsScreen(
                          product: prod,
                          isDarkMode: isDarkMode,
                          currentLocale: currentLocale,
                        ),
                      ),
                    );
                  });
                },
                child: Container(
                  width: 155,
                  margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: textMain.withOpacity(0.04), width: 1.2),
                    boxShadow: isDarkMode
                        ? []
                        : [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Center(
                            child: Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.03),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    )
                                  ]
                              ),
                              child: Image.network(prod["image"], fit: BoxFit.contain),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          prod["title"],
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, fontFamily: 'Cairo', color: textMain),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: List.generate(
                            5,
                                (i) => Icon(
                                Icons.star_rounded,
                                color: i < prod["rating"] ? AppColors.accentGold : Colors.grey.shade300,
                                size: 11
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          prod["price"],
                          style: const TextStyle(color: AppColors.accentCyan, fontWeight: FontWeight.bold, fontSize: 12.5, fontFamily: 'Cairo'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}