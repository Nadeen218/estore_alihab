import 'package:flutter/material.dart';
import 'package:estor_alihab/app_colors.dart';
import 'package:estor_alihab/services/service_api.dart';

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

  List<dynamic> plans = [];
  bool isLoadingPlans = true;
  bool isCheckingNumber = false;
  Map<String, dynamic>? selectedSimPlan;

  @override
  void initState() {
    super.initState();
    _fetchSimPackages();
  }

  Future<void> _fetchSimPackages() async {
    try {
      final data = await ServicesApi.getPackages('sim');
      setState(() {
        plans = data;
        isLoadingPlans = false;
      });
    } catch (e) {
      setState(() {
        isLoadingPlans = false;
      });
    }
  }

  Future<void> _checkNumber() async {
    final enteredNumber = numberController.text.trim();
    final isArabic = widget.currentLocale == 'ar';

    if (enteredNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isArabic ? "الرجاء إدخال رقم الجوال أولاً!" : "Please enter the mobile number first!",
            style: const TextStyle(fontFamily: 'Cairo'),
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => isCheckingNumber = true);

    try {
      final result = await ServicesApi.checkNumber(enteredNumber);
      final isAvailable = result['available'] == true;

      setState(() => isCheckingNumber = false);

      if (!mounted) return;

      if (isAvailable) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(isArabic ? "الرقم متاح" : "Number Available", style: const TextStyle(fontFamily: 'Cairo')),
            content: Text(
              isArabic
                  ? "الرقم ($enteredNumber) متاح للحجز. هل تريد حجزه الآن؟"
                  : "Number ($enteredNumber) is available. Reserve it now?",
              style: const TextStyle(fontFamily: 'Cairo'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(isArabic ? "إلغاء" : "Cancel", style: const TextStyle(fontFamily: 'Cairo')),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                onPressed: () async {
                  Navigator.pop(context);
                  await _reserveNumber(enteredNumber, isArabic);
                },
                child: Text(isArabic ? "احجز الآن" : "Reserve Now", style: const TextStyle(color: Colors.white, fontFamily: 'Cairo')),
              ),
            ],
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isArabic ? "عذراً، هذا الرقم محجوز مسبقاً" : "Sorry, this number is already reserved",
              style: const TextStyle(fontFamily: 'Cairo'),
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } catch (e) {
      setState(() => isCheckingNumber = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isArabic ? "حدث خطأ أثناء التحقق" : "Error while checking", style: const TextStyle(fontFamily: 'Cairo')),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _reserveNumber(String number, bool isArabic) async {
    setState(() => isCheckingNumber = true);

    final success = await ServicesApi.reserveNumber(number);

    setState(() => isCheckingNumber = false);

    if (!mounted) return;

    if (success) {
      numberController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isArabic ? "تم حجز الرقم ($number) بنجاح" : "Number ($number) reserved successfully",
            style: const TextStyle(fontFamily: 'Cairo'),
          ),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isArabic ? "فشل الحجز. تأكد أنك سجّلت الدخول" : "Reservation failed. Make sure you're logged in",
            style: const TextStyle(fontFamily: 'Cairo'),
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

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
                      onPressed: isCheckingNumber ? null : _checkNumber,
                      child: isCheckingNumber
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : Text(isArabic ? "تحقق / احجز الرقم" : "Check / Reserve", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Cairo', fontSize: 14)),
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

            isLoadingPlans
                ? const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()))
                : plans.isEmpty
                ? Center(child: Text(isArabic ? "لا توجد باقات متاحة حالياً" : "No packages available", style: TextStyle(color: textMuted, fontFamily: 'Cairo')))
                : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: plans.length,
              itemBuilder: (context, index) {
                final plan = plans[index];
                final title = plan['name'] ?? plan['title'] ?? 'باقة';
                final details = plan['details'] ?? plan['speed'] ?? '';
                final price = "${plan['price'] ?? 0} شيكل / شهر";
                final isPopular = plan['isPopular'] ?? false;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _buildSimPlanCard(
                    planData: plan,
                    title: title,
                    details: details,
                    price: price,
                    isPopular: isPopular,
                    cardColor: cardColor,
                    textColor: textColor,
                    textMuted: textMuted,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimPlanCard({
    required Map<String, dynamic> planData,
    required String title,
    required String details,
    required String price,
    bool isPopular = false,
    required Color cardColor,
    required Color textColor,
    required Color textMuted,
  }) {
    final bool isSelected = selectedSimPlan != null && selectedSimPlan!['id'] == planData['id'];

    return InkWell(
      onTap: () {
        setState(() {
          selectedSimPlan = planData;
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