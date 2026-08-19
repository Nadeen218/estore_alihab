import 'package:flutter/material.dart';
import 'package:estor_alihab/app_colors.dart';

class SimScreen extends StatefulWidget {
  final bool isDarkMode;
  final String currentLocale;

  const SimScreen({
    Key? key,
    required this.isDarkMode,
    required this.currentLocale,
  }) : super(key: key);

  @override
  State<SimScreen> createState() => _SimScreenState();
}

class _SimScreenState extends State<SimScreen> {
  final TextEditingController numberController = TextEditingController();
  String? selectedSimPlan;

  @override
  void dispose() {
    numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = widget.currentLocale == 'ar';
    final backgroundColor = widget.isDarkMode ? AppColors.darkBackground : AppColors.lightBackground;
    final cardColor = widget.isDarkMode ? AppColors.darkBackgroundSecondary : AppColors.lightBackgroundSecondary;
    final textColor = widget.isDarkMode ? AppColors.darkTextLight : AppColors.lightTextDark;
    final textMuted = widget.isDarkMode ? AppColors.darkTextMuted : AppColors.lightTextMuted;

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: Icon(isArabic ? Icons.arrow_forward_ios_rounded : Icons.arrow_back_ios_new_rounded, color: textColor, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: Text(
            isArabic ? "خطوط وشرائح SIM" : "SIM Lines",
            style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.sim_card_rounded, color: Colors.amberAccent, size: 16),
                            const SizedBox(width: 6),
                            Text(
                              isArabic ? "عروض الخطوط" : "SIM Offers",
                              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isArabic ? "اختر خطك الجديد بكل سهولة" : "Choose your new line easily",
                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isArabic ? "دقائق، إنترنت، ومميزات لا تنتهي" : "Minutes, internet, and endless features",
                    style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12, fontFamily: 'Cairo'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.grey.withOpacity(0.15)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.phone_iphone_rounded, color: Colors.purple, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        isArabic ? "التحقق من رقم أو حجز رقم" : "Check or Reserve Number",
                        style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 15, fontFamily: 'Cairo'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: numberController,
                    keyboardType: TextInputType.phone,
                    style: TextStyle(color: textColor, fontFamily: 'Cairo', fontSize: 13),
                    decoration: InputDecoration(
                      hintText: isArabic ? "أدخل رقم الجوال..." : "Enter mobile number...",
                      hintStyle: TextStyle(color: textMuted, fontFamily: 'Cairo', fontSize: 13),
                      prefixIcon: Icon(Icons.numbers, color: textMuted),
                      filled: true,
                      fillColor: backgroundColor,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        if (numberController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                isArabic ? "الرجاء إدخال رقم الجوال أولاً!" : "Please enter the mobile number first!",
                                style: const TextStyle(fontFamily: 'Cairo'),
                              ),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        } else {
                          final enteredNumber = numberController.text.trim();
                          numberController.clear();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                isArabic
                                    ? "جاري البحث أو التحقق من الرقم ($enteredNumber)..."
                                    : "Checking number ($enteredNumber)...",
                                style: const TextStyle(fontFamily: 'Cairo'),
                              ),
                              backgroundColor: Colors.purple,
                            ),
                          );
                        }
                      },
                      child: Text(isArabic ? "تحقق / احجز الرقم" : "Check / Reserve", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Cairo', fontSize: 14)),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Text(
              isArabic ? "باقات الخطوط المتاحة (انقر للاختيار)" : "Available SIM Plans (Tap to select)",
              style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'Cairo'),
            ),
            const SizedBox(height: 12),

            _buildSimPlanCard(
              title: isArabic ? "باقة بلس 30" : "Plus 30 Plan",
              details: isArabic ? "5 جيجابايت + 500 دقيقة" : "5 GB + 500 Mins",
              price: "30 شيكل / شهر",
              cardColor: cardColor,
              textColor: textColor,
              textMuted: textMuted,
            ),
            const SizedBox(height: 10),
            _buildSimPlanCard(
              title: isArabic ? "باقة الملكية 50" : "Royal 50 Plan",
              details: isArabic ? "15 جيجابايت + دقائق غير محدودة" : "15 GB + Unlimited Mins",
              price: "50 شيكل / شهر",
              isPopular: true,
              cardColor: cardColor,
              textColor: textColor,
              textMuted: textMuted,
            ),
            const SizedBox(height: 10),
            _buildSimPlanCard(
              title: isArabic ? "باقة الانفينيتي 80" : "Infinity 80 Plan",
              details: isArabic ? "إنترنت بلا حدود + دقائق محلي ودولي" : "Unlimited Internet + Local/Intl Mins",
              price: "80 شيكل / شهر",
              cardColor: cardColor,
              textColor: textColor,
              textMuted: textMuted,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimPlanCard({
    required String title,
    required String details,
    required String price,
    bool isPopular = false,
    required Color cardColor,
    required Color textColor,
    required Color textMuted,
  }) {
    final bool isSelected = selectedSimPlan == title;

    return InkWell(
      onTap: () {
        setState(() {
          selectedSimPlan = title;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.currentLocale == 'ar'
                  ? "تم اختيار باقة الخط: $title"
                  : "Selected SIM plan: $title",
              style: const TextStyle(fontFamily: 'Cairo'),
            ),
            backgroundColor: Colors.purple,
            duration: const Duration(seconds: 2),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.purple.withOpacity(0.1) : cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.purple : (isPopular ? Colors.amber : Colors.transparent),
            width: isSelected ? 2 : 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(title, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 15, fontFamily: 'Cairo')),
                    if (isPopular) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: Colors.amber.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                        child: const Text("مميز", style: TextStyle(color: Colors.amber, fontSize: 10, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                      ),
                    ]
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.data_usage_rounded, color: Colors.purpleAccent, size: 16),
                    const SizedBox(width: 4),
                    Text(details, style: TextStyle(color: textMuted, fontSize: 12, fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Text(price, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 14, fontFamily: 'Cairo')),
                const SizedBox(width: 12),
                Icon(
                  isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                  color: isSelected ? Colors.purple : textMuted,
                  size: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}