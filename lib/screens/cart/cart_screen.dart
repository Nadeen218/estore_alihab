import 'package:flutter/material.dart';
import 'package:estor_alihab/app_colors.dart';
import 'checkout_screen.dart';
import 'cart_service.dart';

class CartScreen extends StatefulWidget {
  final bool isDarkMode;
  final String currentLocale;

  const CartScreen({
    Key? key,
    this.isDarkMode = false,
    this.currentLocale = 'ar',
  }) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _promoController = TextEditingController();

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = widget.currentLocale == 'ar';
    final backgroundColor = widget.isDarkMode ? AppColors.darkBackground : const Color(0xFFF2F5F9);
    final cardColor = widget.isDarkMode ? AppColors.darkBackgroundSecondary : Colors.white;
    final textColor = widget.isDarkMode ? AppColors.darkTextLight : const Color(0xFF0F172A);
    final mutedTextColor = widget.isDarkMode ? AppColors.darkTextMuted : const Color(0xFF8E9BAE);
    final primaryBlue = const Color(0xFF0052CC);

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: widget.isDarkMode ? cardColor : const Color(0xFFEBEFEF),
              child: IconButton(
                icon: Icon(
                  isArabic ? Icons.arrow_back_ios_new_rounded : Icons.arrow_forward_ios_rounded,
                  color: textColor,
                  size: 16,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          centerTitle: true,
          title: Text(
            isArabic ? "سلة المشتريات" : "Shopping Cart",
            style: TextStyle(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
          ),
        ),
        // الاستماع التفاعلي لتحديثات السلة
        body: ValueListenableBuilder<List<CartItem>>(
          valueListenable: CartService.cartItemsNotifier,
          builder: (context, cartItems, child) {
            if (cartItems.isEmpty) {
              return Center(
                child: Text(
                  isArabic ? "السلة فارغة حالياً" : "Your cart is empty",
                  style: TextStyle(
                    color: mutedTextColor,
                    fontFamily: 'Cairo',
                    fontSize: 15,
                  ),
                ),
              );
            }

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  // قائمة منتجات السلة
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cartItems.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return _buildCartItemCard(
                        item: item,
                        index: index,
                        cardBg: cardColor,
                        textColor: textColor,
                        mutedTextColor: mutedTextColor,
                        primaryBlue: primaryBlue,
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  // كود الخصم
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              color: widget.isDarkMode
                                  ? AppColors.darkBackground
                                  : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: TextField(
                              controller: _promoController,
                              style: TextStyle(color: textColor, fontFamily: 'Cairo', fontSize: 13),
                              decoration: InputDecoration(
                                icon: Icon(Icons.local_offer_outlined, color: mutedTextColor, size: 18),
                                hintText: isArabic ? "رمز الخصم" : "Promo Code",
                                hintStyle: TextStyle(color: mutedTextColor, fontFamily: 'Cairo', fontSize: 13),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryBlue,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () {},
                          child: Text(
                            isArabic ? "تطبيق" : "Apply",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cairo',
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ملخص الحساب والحسابات التلقائية
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isArabic ? "ملخص الطلب" : "Order Summary",
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildSummaryRow(
                          label: isArabic ? "المجموع الجزئي" : "Subtotal",
                          value: "${CartService.subtotal.toStringAsFixed(0)} ₪",
                          textColor: textColor,
                          labelColor: mutedTextColor,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              isArabic ? "الشحن" : "Shipping",
                              style: TextStyle(
                                color: mutedTextColor,
                                fontSize: 13.5,
                                fontFamily: 'Cairo',
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  isArabic ? "مجاني" : "Free",
                                  style: TextStyle(
                                    color: textColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Text("🎁", style: TextStyle(fontSize: 14)),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildSummaryRow(
                          label: isArabic ? "الضريبة (16%)" : "Tax (16%)",
                          value: "${CartService.tax.toStringAsFixed(0)} ₪",
                          textColor: textColor,
                          labelColor: mutedTextColor,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Divider(color: mutedTextColor.withOpacity(0.15)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              isArabic ? "الإجمالي" : "Total",
                              style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                fontFamily: 'Cairo',
                              ),
                            ),
                            Text(
                              "${CartService.total.toStringAsFixed(0)} ₪",
                              style: TextStyle(
                                color: primaryBlue,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
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
                              subtotal: CartService.subtotal,
                              deliveryFee: 0.0,
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
            );
          },
        ),
      ),
    );
  }

  Widget _buildCartItemCard({
    required CartItem item,
    required int index,
    required Color cardBg,
    required Color textColor,
    required Color mutedTextColor,
    required Color primaryBlue,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 13.5,
                  fontFamily: 'Cairo',
                ),
              ),
              const SizedBox(height: 2),
              Text(
                item.subtitle,
                style: TextStyle(
                  color: mutedTextColor,
                  fontSize: 11,
                  fontFamily: 'Cairo',
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "${(item.price * item.quantity).toInt()} ₪",
                style: const TextStyle(
                  color: Color(0xFF10B981),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  fontFamily: 'Cairo',
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: widget.isDarkMode
                          ? AppColors.darkBackground
                          : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            CartService.decrementQuantity(index);
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: Icon(Icons.remove, size: 14, color: mutedTextColor),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            "${item.quantity}",
                            style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            CartService.incrementQuantity(index);
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: primaryBlue,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.add, size: 12, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () {
                      CartService.removeItem(index);
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF1F2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.delete_outline_rounded,
                        color: Color(0xFFF43F5E),
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const Spacer(),

          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: 85,
              height: 85,
              color: widget.isDarkMode
                  ? AppColors.darkBackground
                  : const Color(0xFFF1F5F9),
              child: Image.network(
                item.image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.image_not_supported_outlined),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow({
    required String label,
    required String value,
    required Color textColor,
    required Color labelColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: labelColor,
            fontSize: 13.5,
            fontFamily: 'Cairo',
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 14,
            fontFamily: 'Cairo',
          ),
        ),
      ],
    );
  }
}