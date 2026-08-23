import 'package:flutter/material.dart';
import 'package:estor_alihab/app_colors.dart';
import '../../product/product_details_screen.dart';
import '../../product/product_service.dart';

class SearchResults extends StatelessWidget {
  final bool isDarkMode;
  final Color cardBg;
  final Color textMain;
  final Color textSub;
  final String currentLocale;
  final String searchQuery;
  final Function(VoidCallback) onCheckLogin;

  const SearchResults({
    Key? key,
    required this.isDarkMode,
    required this.cardBg,
    required this.textMain,
    required this.textSub,
    required this.currentLocale,
    required this.searchQuery,
    required this.onCheckLogin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isArabic = currentLocale == 'ar';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isArabic ? "نتائج البحث" : "Search Results",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
              color: textMain,
            ),
          ),
          const SizedBox(height: 16),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: ProductService.getProducts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 60),
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.accentBlue),
                  ),
                );
              }

              if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: Text(
                      isArabic ? "حدث خطأ في تحميل المنتجات" : "Error loading products",
                      style: TextStyle(color: textMain, fontFamily: 'Cairo'),
                    ),
                  ),
                );
              }

              final allProducts = snapshot.data ?? [];
              final query = searchQuery.trim().toLowerCase();

              final results = allProducts.where((product) {
                final title = (product["title"] ?? product["name"] ?? product["productName"] ?? "")
                    .toString()
                    .toLowerCase();
                return title.contains(query);
              }).toList();

              if (results.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: Text(
                      isArabic ? "لا توجد نتائج مطابقة" : "No matching results",
                      style: TextStyle(color: textSub, fontFamily: 'Cairo'),
                    ),
                  ),
                );
              }

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.72,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                ),
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final product = results[index];
                  return _buildCard(context, product, isArabic);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, Map<String, dynamic> product, bool isArabic) {
    final image = (product["imageUrl"] ?? product["image"] ?? "").toString();
    final title = (product["title"] ?? product["name"] ?? product["productName"] ?? "").toString();
    final price = product["price"]?.toString() ?? "0";
    final rating = double.tryParse(product["rating"]?.toString() ?? "0") ?? 0;

    return GestureDetector(
      onTap: () {
        onCheckLogin(() {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailsScreen(
                product: product,
                isDarkMode: isDarkMode,
                currentLocale: currentLocale,
              ),
            ),
          );
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: textMain.withOpacity(0.05)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Center(
                  child: image.isNotEmpty
                      ? Image.network(
                    image,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stack) =>
                    const Icon(Icons.broken_image, color: Colors.grey),
                  )
                      : const Icon(Icons.image_not_supported_rounded, color: Colors.grey, size: 40),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(color: textMain, fontWeight: FontWeight.bold, fontSize: 12.5, fontFamily: 'Cairo'),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                children: List.generate(
                  5,
                      (i) => Icon(
                    Icons.star_rounded,
                    color: i < rating ? AppColors.accentGold : Colors.grey.shade300,
                    size: 11,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                price,
                style: const TextStyle(color: AppColors.accentCyan, fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'Cairo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}