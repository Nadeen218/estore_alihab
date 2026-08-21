import 'package:flutter/material.dart';
import 'package:estor_alihab/app_colors.dart';
import '../../product/product_details_screen.dart';
import '../../product/products_screen.dart';
import '../../product/product_service.dart';

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isArabic
                    ? "المنتجات الأكثر مبيعاً"
                    : "Best Selling Products",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                  color: textMain,
                ),
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
                  style: TextStyle(
                    fontSize: 12,
                    color: isDarkMode
                        ? AppColors.darkTextMuted
                        : AppColors.lightTextMuted,
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        SizedBox(
          height: 200,
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: ProductService.getProducts(),
            builder: (context, snapshot) {

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.accentBlue,
                  ),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    isArabic
                        ? "حدث خطأ في تحميل المنتجات"
                        : "Error loading products",
                    style: TextStyle(
                      color: textMain,
                      fontFamily: 'Cairo',
                    ),
                  ),
                );
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    isArabic
                        ? "لا توجد منتجات"
                        : "No products found",
                    style: TextStyle(
                      color: textMain,
                      fontFamily: 'Cairo',
                    ),
                  ),
                );
              }

              final products = List<Map<String, dynamic>>.from(
                snapshot.data!,
              );

              // ترتيب المنتجات حسب عدد المبيعات
              products.sort((a, b) {
                final salesA =
                    int.tryParse(
                      a["salesCount"]?.toString() ?? "0",
                    ) ??
                        0;

                final salesB =
                    int.tryParse(
                      b["salesCount"]?.toString() ?? "0",
                    ) ??
                        0;

                return salesB.compareTo(salesA);
              });

              // عرض أول 5 منتجات فقط
              final bestSellingProducts =
              products.take(5).toList();

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: bestSellingProducts.length,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 14),

                itemBuilder: (context, index) {
                  final prod = bestSellingProducts[index];

                  final image =
                  (prod["imageUrl"] ?? prod["image"] ?? "")
                      .toString();

                  final title =
                  (prod["title"] ??
                      prod["name"] ??
                      prod["productName"] ??
                      "")
                      .toString();

                  final price =
                      prod["price"]?.toString() ?? "0";

                  final rating =
                      double.tryParse(
                        prod["rating"]?.toString() ?? "0",
                      ) ??
                          0;

                  return GestureDetector(
                    onTap: () {
                      onCheckLogin(() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductDetailsScreen(
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
                      margin: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 4,
                      ),

                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: textMain.withOpacity(0.04),
                          width: 1.2,
                        ),
                        boxShadow: isDarkMode
                            ? []
                            : [
                          BoxShadow(
                            color: Colors.black
                                .withOpacity(0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),

                      child: Padding(
                        padding: const EdgeInsets.all(12.0),

                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,

                          children: [
                            Expanded(
                              child: Center(
                                child: image.isNotEmpty
                                    ? Image.network(
                                  image,
                                  fit: BoxFit.contain,
                                  errorBuilder:
                                      (context, error, stack) {
                                    return const Icon(
                                      Icons
                                          .broken_image,
                                      color:
                                      Colors.grey,
                                    );
                                  },
                                )
                                    : const Icon(
                                  Icons
                                      .image_not_supported,
                                  color: Colors.grey,
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            Text(
                              title,
                              style: TextStyle(
                                fontWeight:
                                FontWeight.bold,
                                fontSize: 12,
                                fontFamily: 'Cairo',
                                color: textMain,
                              ),
                              maxLines: 1,
                              overflow:
                              TextOverflow.ellipsis,
                            ),

                            const SizedBox(height: 2),

                            Row(
                              children: List.generate(
                                5,
                                    (i) => Icon(
                                  Icons.star_rounded,
                                  color: i < rating
                                      ? AppColors.accentGold
                                      : Colors.grey.shade300,
                                  size: 11,
                                ),
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              price,
                              style: const TextStyle(
                                color:
                                AppColors.accentCyan,
                                fontWeight:
                                FontWeight.bold,
                                fontSize: 12.5,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}