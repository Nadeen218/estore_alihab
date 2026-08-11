import 'package:flutter/material.dart';
import 'package:estor_alihab/app_colors.dart';
import 'checkout_screen.dart';

class CartScreen extends StatefulWidget {
  final bool isDarkMode;
  final String currentLocale;

  const CartScreen({
    Key? key,
    required this.isDarkMode,
    required this.currentLocale,
  }) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // قائمة تجريبية لمنتجات السلة
  List<Map<String, dynamic>> cartItems = [
    {
      "id": "1",
      "title": "iPhone 15 Pro Max",
      "price": 4500,
      "color": "تيتانيوم طبيعي",
      "storage": "256 GB",
      "quantity": 1,
      "image": "https://img.icons8.com/plasticine/200/iphone-x.png",
    },
    {
      "id": "2",
      "title": "Samsung S24 Ultra",
      "price": 3800,
      "color": "أسود",
      "storage": "512 GB",
      "quantity": 1,
      "image": "https://img.icons8.com/plasticine/200/android-os.png",
    },
  ];

  double deliveryFee = 20.0; // رسوم التوصيل

  double get subtotal {
    return cartItems.fold(
        0.0, (sum, item) => sum + (item["price"] * item["quantity"]));
  }

  double get totalPrice => subtotal + (cartItems.isEmpty ? 0 : deliveryFee);

  @override
  Widget build(BuildContext context) {
    final isArabic = widget.currentLocale == 'ar';
    final backgroundColor =
    widget.isDarkMode ? AppColors.darkBackground : AppColors.lightBackground;
    final cardColor = widget.isDarkMode
        ? AppColors.darkBackgroundSecondary
        : AppColors.lightBackgroundSecondary;
    final textColor =
    widget.isDarkMode ? AppColors.darkTextLight : AppColors.lightTextDark;
    final textMutedColor = widget.isDarkMode
        ? AppColors.darkTextMuted
        : AppColors.lightTextMuted;

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
              isArabic
                  ? Icons.arrow_back_ios_new_rounded
                  : Icons.arrow_forward_ios_rounded,
              color: textColor,
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: Text(
            isArabic ? "سلة الشراء" : "My Cart",
            style: TextStyle(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
          ),
        ),
        body: cartItems.isEmpty
            ? _buildEmptyCart(isArabic, textColor, textMutedColor)
            : Column(
          children: [
            // قائمة عناصر السلة
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 10),
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return _buildCartItem(
                    item: item,
                    index: index,
                    cardColor: cardColor,
                    textColor: textColor,
                    textMutedColor: textMutedColor,
                    isArabic: isArabic,
                  );
                },
              ),
            ),

            // ملخص الفاتورة وزر الدفع
            _buildCheckoutSection(
              cardColor: cardColor,
              textColor: textColor,
              textMutedColor: textMutedColor,
              isArabic: isArabic,
            ),
          ],
        ),
      ),
    );
  }

  // ودجت حالة السلة الفارغة
  Widget _buildEmptyCart(
      bool isArabic, Color textColor, Color textMutedColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 90,
            color: textMutedColor.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            isArabic ? "السلة فارغة حالياً" : "Your cart is empty",
            style: TextStyle(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isArabic
                ? "قم بإضافة بعض المنتجات لتظهر هنا"
                : "Add some products to see them here",
            style: TextStyle(
              color: textMutedColor,
              fontSize: 13,
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
  }

  // ودجت كرت المنتج داخل السلة
  Widget _buildCartItem({
    required Map<String, dynamic> item,
    required int index,
    required Color cardColor,
    required Color textColor,
    required Color textMutedColor,
    required bool isArabic,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: widget.isDarkMode
              ? Colors.white.withOpacity(0.05)
              : Colors.black.withOpacity(0.04),
        ),
      ),
      child: Row(
        children: [
          // صورة المنتج
          Container(
            width: 75,
            height: 75,
            decoration: BoxDecoration(
              color: widget.isDarkMode
                  ? AppColors.darkBackground
                  : AppColors.lightBackground,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Image.network(
              item["image"],
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 12),

          // تفاصيل المنتج (العنوان، المواصفات، السعر)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item["title"],
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          fontFamily: 'Cairo',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded,
                          color: Colors.redAccent, size: 20),
                      onPressed: () {
                        setState(() {
                          cartItems.removeAt(index);
                        });
                      },
                    ),
                  ],
                ),
                Text(
                  "${item['storage']} | ${item['color']}",
                  style: TextStyle(
                    color: textMutedColor,
                    fontSize: 11,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${item['price'] * item['quantity']} ₪",
                      style: const TextStyle(
                        color: AppColors.accentCyan,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        fontFamily: 'Cairo',
                      ),
                    ),

                    // أزرار التحكم بالكمية
                    Container(
                      height: 32,
                      decoration: BoxDecoration(
                        color: widget.isDarkMode
                            ? AppColors.darkBackground
                            : AppColors.lightBackground,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              if (item["quantity"] > 1) {
                                setState(() {
                                  item["quantity"]--;
                                });
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Icon(Icons.remove,
                                  color: textColor, size: 16),
                            ),
                          ),
                          Text(
                            "${item['quantity']}",
                            style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                item["quantity"]++;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child:
                              Icon(Icons.add, color: textColor, size: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // قسم الملخص المالي وزر الدفع
  Widget _buildCheckoutSection({
    required Color cardColor,
    required Color textColor,
    required Color textMutedColor,
    required bool isArabic,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            // المجموع الفرعي
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isArabic ? "المجموع الفرعي" : "Subtotal",
                  style: TextStyle(
                    color: textMutedColor,
                    fontSize: 13,
                    fontFamily: 'Cairo',
                  ),
                ),
                Text(
                  "$subtotal ₪",
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // التوصيل
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isArabic ? "رسوم التوصيل" : "Delivery Fee",
                  style: TextStyle(
                    color: textMutedColor,
                    fontSize: 13,
                    fontFamily: 'Cairo',
                  ),
                ),
                Text(
                  "$deliveryFee ₪",
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Divider(color: textMutedColor.withOpacity(0.2)),
            const SizedBox(height: 12),

            // الإجمالي النهائي
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isArabic ? "الإجمالي الكلي" : "Total Price",
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: 'Cairo',
                  ),
                ),
                Text(
                  "$totalPrice ₪",
                  style: const TextStyle(
                    color: AppColors.accentCyan,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // زر المتابعة للشراء
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentBlue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CheckoutScreen(
                        isDarkMode: widget.isDarkMode,
                        currentLocale: widget.currentLocale,
                        subtotal: subtotal,
                        deliveryFee: deliveryFee,
                      ),
                    ),
                  );
                },
                child: Text(
                  isArabic ? "المتابعة لإتمام الطلب" : "Proceed to Checkout",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
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