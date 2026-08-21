import 'package:flutter/material.dart';
import 'package:estor_alihab/app_colors.dart';
import 'product_details_screen.dart';
import '../cart/cart_screen.dart';
import 'product_service.dart';

class ProductsScreen extends StatefulWidget {
  final bool isDarkMode;
  final String currentLocale;
  final String? initialCategory;

  const ProductsScreen({
    Key? key,
    this.isDarkMode = true,
    this.currentLocale = 'ar',
    this.initialCategory,
  }) : super(key: key);

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  late bool isDarkMode;
  late String currentLocale;
  int selectedCategoryIndex = 0;
  String searchQuery = "";
  late Future<List<Map<String, dynamic>>> productsFuture;

  final List<Map<String, String>> categories = [
    {"ar": "الكل", "en": "All"},
    {"ar": "الأجهزة", "en": "Devices"},
    {"ar": "أجهزة لوحية", "en": "Tablets"},
    {"ar": "ساعات ذكية", "en": "Smart Watches"},
    {"ar": "إكسسوار", "en": "Accessories"},
  ];

  @override
  void initState() {
    super.initState();
    isDarkMode = widget.isDarkMode;
    currentLocale = widget.currentLocale;
    productsFuture = ProductService.getProducts();

    if (widget.initialCategory != null) {
      final index = categories.indexWhere((cat) => cat["ar"] == widget.initialCategory || cat["en"] == widget.initialCategory);
      if (index != -1) {
        selectedCategoryIndex = index;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = currentLocale == 'ar';
    final backgroundColor = isDarkMode ? AppColors.darkBackground : AppColors.lightBackground;
    final cardColor = isDarkMode ? AppColors.darkBackgroundSecondary : AppColors.lightBackgroundSecondary;
    final textColor = isDarkMode ? AppColors.darkTextLight : AppColors.lightTextDark;
    final textMutedColor = isDarkMode ? AppColors.darkTextMuted : AppColors.lightTextMuted;

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: Icon(isArabic ? Icons.arrow_back_ios_new_rounded : Icons.arrow_forward_ios_rounded, color: textColor, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: Text(isArabic ? "قائمة المنتجات" : "Products List", style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
          actions: [
            IconButton(icon: const Icon(Icons.shopping_bag_outlined, color: AppColors.accentCyan), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CartScreen(isDarkMode: isDarkMode, currentLocale: currentLocale)))),
            IconButton(icon: Icon(isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded, color: isDarkMode ? AppColors.accentGold : AppColors.primaryBlue), onPressed: () => setState(() => isDarkMode = !isDarkMode)),
          ],
        ),
        body: Column(
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(20), border: Border.all(color: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.04))),
                child: TextField(
                  onChanged: (val) => setState(() => searchQuery = val),
                  style: TextStyle(color: textColor, fontFamily: 'Cairo', fontSize: 13),
                  decoration: InputDecoration(icon: Icon(Icons.search_rounded, color: textMutedColor, size: 22), hintText: isArabic ? "إبحث عن جهاز أو منتج..." : "Search product...", hintStyle: TextStyle(color: textMutedColor, fontFamily: 'Cairo', fontSize: 12), border: InputBorder.none),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final isSelected = selectedCategoryIndex == index;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: GestureDetector(
                      onTap: () => setState(() => selectedCategoryIndex = index),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                        decoration: BoxDecoration(color: isSelected ? AppColors.accentBlue : cardColor, borderRadius: BorderRadius.circular(20)),
                        child: Center(child: Text(isArabic ? categories[index]["ar"]! : categories[index]["en"]!, style: TextStyle(color: isSelected ? Colors.white : textMutedColor, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, fontSize: 12, fontFamily: 'Cairo'))),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: productsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: AppColors.accentBlue));
                  } else if (snapshot.hasError) {
                    return Center(child: Text(isArabic ? "حدث خطأ في تحميل البيانات" : "Error loading data", style: TextStyle(color: textColor)));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text(isArabic ? "لا توجد منتجات" : "No products found", style: TextStyle(color: textMutedColor)));
                  }

                  final allProducts = snapshot.data!;
                  final filteredProducts = allProducts.where((product) {
                    final productCategory = (product["category"] ?? product["type"] ?? "")?.toString().trim().toLowerCase() ?? "";

                    final selectedAr = categories[selectedCategoryIndex]["ar"]!.trim().toLowerCase();
                    final selectedEn = categories[selectedCategoryIndex]["en"]!.trim().toLowerCase();

                    final matchesCategory = selectedCategoryIndex == 0 ||
                        productCategory.contains(selectedAr) ||
                        productCategory.contains(selectedEn) ||
                        selectedAr.contains(productCategory);

                    final titleVal = (product["title"] ?? product["name"] ?? product["productName"])?.toString().toLowerCase() ?? "";
                    final matchesSearch = searchQuery.isEmpty || titleVal.contains(searchQuery.toLowerCase());

                    return matchesCategory && matchesSearch;
                  }).toList();

                  if (filteredProducts.isEmpty) {
                    return Center(child: Text(isArabic ? "لا توجد نتائج مطابقة" : "No results match", style: TextStyle(color: textMutedColor)));
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.72, crossAxisSpacing: 14, mainAxisSpacing: 14),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return _buildProductCard(product: product, cardBg: cardColor, textColor: textColor, textMutedColor: textMutedColor, isArabic: isArabic);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard({required Map<String, dynamic> product, required Color cardBg, required Color textColor, required Color textMutedColor, required bool isArabic}) {
    final productId = product["id"]?.toString() ?? 'unknown';
    final imageUrl = (product["imageUrl"] ?? product["image"])?.toString() ?? '';
    final title = (product["title"] ?? product["name"] ?? product["productName"])?.toString() ?? (isArabic ? "منتج بدون اسم" : "Unnamed Product");
    final rating = product["rating"]?.toString() ?? '0.0';
    final price = product["price"]?.toString() ?? '0';

    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailsScreen(product: product, isDarkMode: isDarkMode, currentLocale: currentLocale))),
      child: Container(
        decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(24), border: Border.all(color: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.04))),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Center(
                      child: Hero(
                        tag: 'product_$productId',
                        child: imageUrl.isNotEmpty
                            ? Image.network(
                          imageUrl,
                          fit: BoxFit.contain,
                          errorBuilder: (c, o, s) => const Icon(Icons.broken_image, color: Colors.grey),
                        )
                            : const Icon(Icons.image_not_supported_rounded, color: Colors.grey, size: 40),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(title, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 12.5, fontFamily: 'Cairo'), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Row(children: [const Icon(Icons.star_rounded, color: AppColors.accentGold, size: 14), const SizedBox(width: 4), Text(rating, style: TextStyle(color: textMutedColor, fontSize: 10, fontWeight: FontWeight.bold))]),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(price, style: const TextStyle(color: AppColors.accentCyan, fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'Cairo'))]),
                      InkWell(
                        onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(isArabic ? "تم الإضافة للسلة" : "Added to cart", style: const TextStyle(fontFamily: 'Cairo')), backgroundColor: AppColors.accentGreen, duration: const Duration(seconds: 1))),
                        child: Container(padding: const EdgeInsets.all(7), decoration: BoxDecoration(color: AppColors.accentBlue, borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.add_shopping_cart_rounded, color: Colors.white, size: 15)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}