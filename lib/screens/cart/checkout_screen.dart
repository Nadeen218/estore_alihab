// lib/cart/checkout_screen.dart

import 'package:flutter/material.dart';
import 'package:estor_alihab/app_colors.dart';

class CheckoutScreen extends StatefulWidget {
  final bool isDarkMode;
  final String currentLocale;
  final double subtotal;
  final double deliveryFee;

  const CheckoutScreen({
    Key? key,
    required this.isDarkMode,
    required this.currentLocale,
    required this.subtotal,
    required this.deliveryFee,
  }) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int selectedPaymentIndex = 0; // 0: الدفع عند الاستلام, 1: بطاقة ائتمان

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  double get totalPrice => widget.subtotal + widget.deliveryFee;

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    cityController.dispose();
    addressController.dispose();
    super.dispose();
  }

  void _showSuccessDialog(bool isArabic) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        final cardColor = widget.isDarkMode
            ? AppColors.darkBackgroundSecondary
            : AppColors.lightBackgroundSecondary;
        final textColor = widget.isDarkMode
            ? AppColors.darkTextLight
            : AppColors.lightTextDark;

        return AlertDialog(
          backgroundColor: cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: const BoxDecoration(
                    color: AppColors.accentGreen,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  isArabic ? "تم تأكيد طلبك بنجاح!" : "Order Confirmed!",
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  isArabic
                      ? "شكراً لتسوقك من 'إيهاب ستور'. سنتواصل معك قريباً لتأكيد التوصيل."
                      : "Thank you for shopping at 'Ehab Store'. We will contact you soon for delivery.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: widget.isDarkMode
                        ? AppColors.darkTextMuted
                        : AppColors.lightTextMuted,
                    fontSize: 12.5,
                    fontFamily: 'Cairo',
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentBlue,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.pop(dialogContext); // إغلاق النافذة
                      Navigator.pop(context); // العودة من الشيك أوت
                    },
                    child: Text(
                      isArabic ? "العودة للرئيسية" : "Back to Home",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = widget.currentLocale == 'ar';
    final backgroundColor = widget.isDarkMode
        ? AppColors.darkBackground
        : AppColors.lightBackground;
    final cardColor = widget.isDarkMode
        ? AppColors.darkBackgroundSecondary
        : AppColors.lightBackgroundSecondary;
    final textColor = widget.isDarkMode
        ? AppColors.darkTextLight
        : AppColors.lightTextDark;
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
            isArabic ? "إتمام الطلب" : "Checkout",
            style: TextStyle(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. قسم عنوان ورقم التوصيل
                    Text(
                      isArabic ? "معلومات التوصيل" : "Delivery Information",
                      style: TextStyle(
                        color: textColor,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: widget.isDarkMode
                              ? Colors.white.withOpacity(0.05)
                              : Colors.black.withOpacity(0.04),
                        ),
                      ),
                      child: Column(
                        children: [
                          _buildTextField(
                            controller: nameController,
                            hint: isArabic ? "الاسم الكامل" : "Full Name",
                            icon: Icons.person_outline_rounded,
                            textColor: textColor,
                            textMutedColor: textMutedColor,
                          ),
                          const SizedBox(height: 12),
                          _buildTextField(
                            controller: phoneController,
                            hint: isArabic ? "رقم الهاتف" : "Phone Number",
                            icon: Icons.phone_android_outlined,
                            keyboardType: TextInputType.phone,
                            textColor: textColor,
                            textMutedColor: textMutedColor,
                          ),
                          const SizedBox(height: 12),
                          _buildTextField(
                            controller: cityController,
                            hint: isArabic ? "المدينة" : "City",
                            icon: Icons.location_city_outlined,
                            textColor: textColor,
                            textMutedColor: textMutedColor,
                          ),
                          const SizedBox(height: 12),
                          _buildTextField(
                            controller: addressController,
                            hint: isArabic
                                ? "العنوان التفصيلي (الشارع، البناية)"
                                : "Detailed Address",
                            icon: Icons.location_on_outlined,
                            textColor: textColor,
                            textMutedColor: textMutedColor,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // 2. قسم طريقة الدفع
                    Text(
                      isArabic ? "طريقة الدفع" : "Payment Method",
                      style: TextStyle(
                        color: textColor,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    const SizedBox(height: 12),

                    _buildPaymentOption(
                      index: 0,
                      title: isArabic
                          ? "الدفع عند الاستلام (Cash on Delivery)"
                          : "Cash on Delivery",
                      subtitle: isArabic
                          ? "ادفع نقداً عند وصول طلبك"
                          : "Pay in cash upon arrival",
                      icon: Icons.payments_outlined,
                      cardColor: cardColor,
                      textColor: textColor,
                      textMutedColor: textMutedColor,
                    ),

                    const SizedBox(height: 10),

                    _buildPaymentOption(
                      index: 1,
                      title: isArabic
                          ? "بطاقة ائتمان / فيزا"
                          : "Credit Card / Visa",
                      subtitle: isArabic
                          ? "الدفع المباشر والآمن عبر البطاقة"
                          : "Direct and secure online payment",
                      icon: Icons.credit_card_rounded,
                      cardColor: cardColor,
                      textColor: textColor,
                      textMutedColor: textMutedColor,
                    ),

                    const SizedBox(height: 24),

                    // 3. ملخص المبالغ
                    Text(
                      isArabic ? "ملخص الفاتورة" : "Order Summary",
                      style: TextStyle(
                        color: textColor,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: widget.isDarkMode
                              ? Colors.white.withOpacity(0.05)
                              : Colors.black.withOpacity(0.04),
                        ),
                      ),
                      child: Column(
                        children: [
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
                                "${widget.subtotal} ₪",
                                style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
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
                                "${widget.deliveryFee} ₪",
                                style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            color: textMutedColor.withOpacity(0.2),
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                isArabic ? "الإجمالي الكلي" : "Total",
                                style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                              Text(
                                "$totalPrice ₪",
                                style: const TextStyle(
                                  color: AppColors.accentCyan,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // زر إتمام وتأكيد الطلب
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(28)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                child: SizedBox(
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
                      _showSuccessDialog(isArabic);
                    },
                    child: Text(
                      isArabic ? "تأكيد وإرسال الطلب" : "Confirm Order",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ودجت الحقول الإدخال
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required Color textColor,
    required Color textMutedColor,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: widget.isDarkMode
            ? AppColors.darkBackground
            : AppColors.lightBackground,
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(color: textColor, fontFamily: 'Cairo', fontSize: 13),
        decoration: InputDecoration(
          icon: Icon(icon, color: textMutedColor, size: 20),
          hintText: hint,
          hintStyle: TextStyle(
              color: textMutedColor, fontFamily: 'Cairo', fontSize: 12),
          border: InputBorder.none,
        ),
      ),
    );
  }

  // ودجت اختيار طريقة الدفع
  Widget _buildPaymentOption({
    required int index,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color cardColor,
    required Color textColor,
    required Color textMutedColor,
  }) {
    final isSelected = selectedPaymentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPaymentIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected
                ? AppColors.accentBlue
                : (widget.isDarkMode
                ? Colors.white.withOpacity(0.05)
                : Colors.black.withOpacity(0.04)),
            width: isSelected ? 1.8 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.accentBlue.withOpacity(0.15)
                    : widget.isDarkMode
                    ? AppColors.darkBackground
                    : AppColors.lightBackground,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? AppColors.accentBlue : textMutedColor,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: textMutedColor,
                      fontSize: 11,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ],
              ),
            ),
            Radio<int>(
              value: index,
              groupValue: selectedPaymentIndex,
              activeColor: AppColors.accentBlue,
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    selectedPaymentIndex = val;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}