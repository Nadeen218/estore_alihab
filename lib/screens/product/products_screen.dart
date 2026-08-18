import 'package:flutter/material.dart';
import 'package:estor_alihab/app_colors.dart';
import 'product_details_screen.dart';
import '../cart/cart_screen.dart';

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

  final List<Map<String, String>> categories = [
    {"ar": "الكل", "en": "All"},
    {"ar": "الأجهزة", "en": "Devices"},
    {"ar": "أجهزة لوحية", "en": "Tablets"},
    {"ar": "ساعات ذكية", "en": "Smart Watches"},
    {"ar": "إكسسوار", "en": "Accessories"},
  ];

  final List<Map<String, dynamic>> allProducts = [
    {
      "id": "1",
      "title": "iPhone 15 Pro Max",
      "category": "الأجهزة",
      "categoryEn": "Devices",
      "price": "4,500 ₪",
      "oldPrice": "4,800 ₪",
      "rating": 5.0,
      "image": "https://img.icons8.com/plasticine/200/iphone-x.png",
      "isNew": true,
    },
    {
      "id": "2",
      "title": "Samsung S24 Ultra",
      "category": "الأجهزة",
      "categoryEn": "Devices",
      "price": "3,800 ₪",
      "oldPrice": "4,100 ₪",
      "rating": 4.8,
      "image": "https://img.icons8.com/plasticine/200/android-os.png",
      "isNew": false,
    },
    {
      "id": "3",
      "title": "iPad Pro 12.9 M2",
      "category": "أجهزة لوحية",
      "categoryEn": "Tablets",
      "price": "3,900 ₪",
      "oldPrice": null,
      "rating": 4.9,
      "image": "https://img.icons8.com/plasticine/200/ipad.png",
      "isNew": true,
    },
    {
      "id": "4",
      "title": "Apple Watch Ultra 2",
      "category": "ساعات ذكية",
      "categoryEn": "Watches",
      "price": "2,600 ₪",
      "oldPrice": "2,850 ₪",
      "rating": 4.7,
      "image": "https://img.icons8.com/plasticine/200/apple-watch.png",
      "isNew": false,
    },
    {
      "id": "5",
      "title": "AirPods Pro 2",
      "category": "إكسسوار",
      "categoryEn": "Accessories",
      "price": "850 ₪",
      "oldPrice": "950 ₪",
      "rating": 4.9,
      "image": "https://img.icons8.com/plasticine/200/headphones.png",
      "isNew": false,
    },
    {
      "id": "6",
      "title": "MacBook Pro M3",
      "category": "الأجهزة",
      "categoryEn": "Devices",
      "price": "6,200 ₪",
      "oldPrice": null,
      "rating": 5.0,
      "image": "https://img.icons8.com/plasticine/200/macbook.png",
      "isNew": true,
    },
  ];

  @override
  void initState() {
    super.initState();
    isDarkMode = widget.isDarkMode;
    currentLocale = widget.currentLocale;

    if (widget.initialCategory != null) {
      final index = categories.indexWhere((cat) => cat["ar"] == widget.initialCategory);
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

    final filteredProducts = allProducts.where((product) {
      final matchesCategory = selectedCategoryIndex == 0 ||
          product["category"] == categories[selectedCategoryIndex]["ar"];
      final matchesSearch = searchQuery.isEmpty ||
          product["title"].toString().toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

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
              isArabic ? Icons.arrow_back_ios_new_rounded : Icons.arrow_forward_ios_rounded,
              color: textColor,
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: Text(
            isArabic ? "قائمة المنتجات" : "Products List",
            style: TextStyle(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.shopping_bag_outlined, color: AppColors.accentCyan),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartScreen(
                      isDarkMode: isDarkMode,
                      currentLocale: currentLocale,
                    ),
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(
                isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                color: isDarkMode ? AppColors.accentGold : AppColors.primaryBlue,
              ),
              onPressed: () {
                setState(() {
                  isDarkMode = !isDarkMode;
                });
              },
            ),
          ],
        ),
        body: Column(
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.04),
                  ),
                ),
                child: TextField(
                  onChanged: (val) {
                    setState(() {
                      searchQuery = val;
                    });
                  },
                  style: TextStyle(color: textColor, fontFamily: 'Cairo', fontSize: 13),
                  decoration: InputDecoration(
                    icon: Icon(Icons.search_rounded, color: textMutedColor, size: 22),
                    hintText: isArabic ? "إبحث عن جهاز أو منتج..." : "Search product...",
                    hintStyle: TextStyle(color: textMutedColor, fontFamily: 'Cairo', fontSize: 12),
                    border: InputBorder.none,
                  ),
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
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final isSelected = selectedCategoryIndex == index;
                  final categoryTitle = isArabic
                      ? categories[index]["ar"]!
                      : categories[index]["en"]!;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategoryIndex = index;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.accentBlue : cardColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.accentBlue
                                : (isDarkMode ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.04)),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            categoryTitle,
                            style: TextStyle(
                              color: isSelected ? Colors.white : textMutedColor,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              fontSize: 12,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: filteredProducts.isEmpty
                  ? Center(
                child: Text(
                  isArabic ? "لا توجد منتجات مطابقة" : "No products found",
                  style: TextStyle(color: textMutedColor, fontFamily: 'Cairo', fontSize: 14),
                ),
              )
                  : GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.72,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                ),
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  return _buildProductCard(
                    product: product,
                    cardBg: cardColor,
                    textColor: textColor,
                    textMutedColor: textMutedColor,
                    isArabic: isArabic,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard({
    required Map<String, dynamic> product,
    required Color cardBg,
    required Color textColor,
    required Color textMutedColor,
    required bool isArabic,
  }) {
    return GestureDetector(
      onTap: () {
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
      },
      child: Container(
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.04),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDarkMode ? 0.2 : 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
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
                        tag: 'product_${product["id"]}',
                        child: Image.network(
                          product["image"],
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product["title"],
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.5,
                      fontFamily: 'Cairo',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: AppColors.accentGold, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        "${product["rating"]}",
                        style: TextStyle(
                          color: textMutedColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product["price"],
                            style: const TextStyle(
                              color: AppColors.accentCyan,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              fontFamily: 'Cairo',
                            ),
                          ),
                          if (product["oldPrice"] != null)
                            Text(
                              product["oldPrice"],
                              style: TextStyle(
                                color: textMutedColor,
                                fontSize: 9.5,
                                decoration: TextDecoration.lineThrough,
                                fontFamily: 'Cairo',
                              ),
                            ),
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                isArabic ? "تم إضافة المنتج إلى السلة بنجاح!" : "Added to cart successfully!",
                                style: const TextStyle(fontFamily: 'Cairo'),
                              ),
                              backgroundColor: AppColors.accentGreen,
                              duration: const Duration(seconds: 1),
                            ),
                          );

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CartScreen(
                                isDarkMode: isDarkMode,
                                currentLocale: currentLocale,
                              ),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: AppColors.accentBlue,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.add_shopping_cart_rounded,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (product["isNew"] == true)
              Positioned(
                top: 10,
                right: isArabic ? 10 : null,
                left: isArabic ? null : 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.accentGreen,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    isArabic ? "جديد" : "NEW",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}