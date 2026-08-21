// lib/product/product_details_screen.dart

import 'package:flutter/material.dart';
import 'package:estor_alihab/app_colors.dart';
import '../cart/cart_screen.dart';
import '../cart/cart_service.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> product;
  final bool isDarkMode;
  final String currentLocale;

  const ProductDetailsScreen({
    Key? key,
    required this.product,
    this.isDarkMode = true,
    this.currentLocale = 'ar',
  }) : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late bool isDarkMode;
  late String currentLocale;

  int selectedStorageIndex = 0;
  int selectedColorIndex = 0;
  int quantity = 1;

  final List<String> storageOptions = ["128 GB", "256 GB", "512 GB", "1 TB"];
  final List<Color> colorOptions = [
    const Color(0xFF333333),
    const Color(0xFFE0E0E0),
    const Color(0xFF4A5568),
    const Color(0xFFD4AF37),
  ];

  @override
  void initState() {
    super.initState();
    isDarkMode = widget.isDarkMode;
    currentLocale = widget.currentLocale;
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = currentLocale == 'ar';
    final backgroundColor = isDarkMode ? AppColors.darkBackground : AppColors.lightBackground;
    final cardColor = isDarkMode ? AppColors.darkBackgroundSecondary : AppColors.lightBackgroundSecondary;
    final textColor = isDarkMode ? AppColors.darkTextLight : AppColors.lightTextDark;
    final textMutedColor = isDarkMode ? AppColors.darkTextMuted : AppColors.lightTextMuted;

    final String title = (widget.product["title"] ?? widget.product["name"] ?? "اسم المنتج").toString();
    final String price = (widget.product["price"] ?? "0").toString();
    final String? oldPrice = widget.product["oldPrice"]?.toString();

    final double rating = double.tryParse((widget.product["rating"] ?? "5.0").toString()) ?? 5.0;
    final String image = (widget.product["imageUrl"] ?? widget.product["image"] ?? "").toString();
    final String productId = (widget.product["id"] ?? widget.product["_id"] ?? 'unknown').toString();
    final String description = (widget.product["description"] ?? "").toString();

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
            isArabic ? "تفاصيل المنتج" : "Product Details",
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
              icon: const Icon(Icons.favorite_border_rounded, color: Colors.redAccent),
              onPressed: () {},
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 250,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.04),
                        ),
                      ),
                      child: Center(
                        child: Hero(
                          tag: 'product_$productId',
                          child: image.isNotEmpty
                              ? Image.network(
                            image,
                            height: 180,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image, size: 80, color: Colors.grey),
                          )
                              : const Icon(Icons.phone_android, size: 80, color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.accentGold.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star_rounded, color: AppColors.accentGold, size: 18),
                              const SizedBox(width: 4),
                              Text(
                                "$rating",
                                style: const TextStyle(
                                  color: AppColors.accentGold,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          "$price \$",
                          style: const TextStyle(
                            color: AppColors.accentCyan,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        if (oldPrice != null) ...[
                          const SizedBox(width: 12),
                          Text(
                            "$oldPrice \$",
                            style: TextStyle(
                              color: textMutedColor,
                              fontSize: 14,
                              decoration: TextDecoration.lineThrough,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 20),
                    Divider(color: textMutedColor.withOpacity(0.2)),
                    const SizedBox(height: 16),
                    Text(
                      isArabic ? "السعة التخزينية:" : "Storage Capacity:",
                      style: TextStyle(
                        color: textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: List.generate(storageOptions.length, (index) {
                        final isSelected = selectedStorageIndex == index;
                        return Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedStorageIndex = index;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.accentBlue : cardColor,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.accentBlue
                                      : (isDarkMode ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.05)),
                                ),
                              ),
                              child: Text(
                                storageOptions[index],
                                style: TextStyle(
                                  color: isSelected ? Colors.white : textMutedColor,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  fontSize: 12,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      isArabic ? "اختر اللون:" : "Select Color:",
                      style: TextStyle(
                        color: textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: List.generate(colorOptions.length, (index) {
                        final isSelected = selectedColorIndex == index;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedColorIndex = index;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected ? AppColors.accentBlue : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 14,
                              backgroundColor: colorOptions[index],
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      isArabic ? "الوصف والمواصفات:" : "Description & Specs:",
                      style: TextStyle(
                        color: textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description.isNotEmpty
                          ? description
                          : (isArabic
                          ? "جهاز ممتاز بمواصفات عالية، كفالة رسمية من الوكيل المعتمد 'الإيهاب لخدمات الاتصال'."
                          : "High performance device with official warranty."),
                      style: TextStyle(
                        color: textMutedColor,
                        fontSize: 13,
                        height: 1.6,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                border: Border.all(
                  color: isDarkMode ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.04),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove, color: textColor, size: 18),
                            onPressed: () {
                              if (quantity > 1) {
                                setState(() {
                                  quantity--;
                                });
                              }
                            },
                          ),
                          Text(
                            "$quantity",
                            style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.add, color: textColor, size: 18),
                            onPressed: () {
                              setState(() {
                                quantity++;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accentBlue,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          CartService.addToCart(
                            widget.product,
                            quantity: quantity,
                            selectedStorage: storageOptions[selectedStorageIndex],
                          );

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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              isArabic ? "أضف إلى السلة" : "Add To Cart",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}