import 'package:flutter/material.dart';
import 'package:estor_alihab/app_colors.dart';
import 'package:estor_alihab/services/service_api.dart';

class FiberScreen extends StatefulWidget {
  final bool isDarkMode;
  final String currentLocale;

  const FiberScreen({
    Key? key,
    required this.isDarkMode,
    required this.currentLocale,
  }) : super(key: key);

  @override
  State<FiberScreen> createState() => _FiberScreenState();
}

class _FiberScreenState extends State<FiberScreen> {
  final TextEditingController addressController = TextEditingController();

  List<dynamic> plans = [];
  bool isLoadingPlans = true;
  bool isCheckingCoverage = false;
  Map<String, dynamic>? selectedPlan;

  @override
  void initState() {
    super.initState();
    _fetchFiberPackages();
  }

  Future<void> _fetchFiberPackages() async {
    try {
      final data = await ServicesApi.getPackages('fiber');
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

  Future<void> _checkCoverage() async {
    final city = addressController.text.trim();
    if (city.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.currentLocale == 'ar' ? "الرجاء إدخال اسم المنطقة أولاً!" : "Please enter your area first!",
            style: const TextStyle(fontFamily: 'Cairo'),
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => isCheckingCoverage = true);

    try {
      final isAvailable = await ServicesApi.checkFiberCoverage(city);
      setState(() => isCheckingCoverage = false);

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(widget.currentLocale == 'ar' ? "نتيجة فحص التغطية" : "Coverage Result", style: const TextStyle(fontFamily: 'Cairo')),
          content: Text(
            isAvailable
                ? (widget.currentLocale == 'ar' ? "مبروك! الخدمة متوفرة في منطقة ($city)." : "Great! Service is available in ($city).")
                : (widget.currentLocale == 'ar' ? "عذراً، الخدمة غير متوفرة حالياً في منطقة ($city)." : "Sorry, service is not available in ($city) yet."),
            style: const TextStyle(fontFamily: 'Cairo'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(widget.currentLocale == 'ar' ? "حسناً" : "OK", style: const TextStyle(fontFamily: 'Cairo')),
            ),
          ],
        ),
      );
    } catch (e) {
      setState(() => isCheckingCoverage = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("حدث خطأ أثناء فحص التغطية", style: TextStyle(fontFamily: 'Cairo')), backgroundColor: Colors.red),
      );
    }
  }

  @override
  void dispose() {
    addressController.dispose();
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
            isArabic ? "جوال فايبر" : "Jawwal Fiber",
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
                  colors: [Color(0xFF0056D2), Color(0xFF0091FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.wifi_rounded, color: Colors.greenAccent, size: 16),
                            const SizedBox(width: 6),
                            Text(
                              isArabic ? "جوال فايبر" : "Jawwal Fiber",
                              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isArabic ? "إنترنت فائق السرعة" : "High-speed Internet",
                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isArabic ? "حتى 1 جيجابت في الثانية لكل منزلك" : "Up to 1 Gbps for your whole home",
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
                      const Icon(Icons.location_pin, color: Colors.blue, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        isArabic ? "فحص التغطية" : "Check Coverage",
                        style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 15, fontFamily: 'Cairo'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: addressController,
                    style: TextStyle(color: textColor, fontFamily: 'Cairo', fontSize: 13),
                    decoration: InputDecoration(
                      hintText: isArabic ? "أدخل منطقتك (مثل: رام الله)..." : "Enter your area...",
                      hintStyle: TextStyle(color: textMuted, fontFamily: 'Cairo', fontSize: 13),
                      prefixIcon: Icon(Icons.search, color: textMuted),
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
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: isCheckingCoverage ? null : _checkCoverage,
                      child: isCheckingCoverage
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : Text(isArabic ? "افحص التغطية" : "Check Coverage", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Cairo', fontSize: 14)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              isArabic ? "الباقات المتاحة (انقر للاختيار)" : "Available Plans (Tap to select)",
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
                final speed = plan['speed'] ?? '';
                final price = "${plan['price'] ?? 0} شيكل / شهر";
                final isPopular = plan['isPopular'] ?? false;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _buildFiberPlanCard(
                    planData: plan,
                    title: title,
                    speed: speed,
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

  Widget _buildFiberPlanCard({
    required Map<String, dynamic> planData,
    required String title,
    required String speed,
    required String price,
    bool isPopular = false,
    required Color cardColor,
    required Color textColor,
    required Color textMuted,
  }) {
    final bool isSelected = selectedPlan != null && selectedPlan!['id'] == planData['id'];

    return InkWell(
      onTap: () {
        setState(() {
          selectedPlan = planData;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.currentLocale == 'ar' ? "تم اختيار باقة: $title ($speed)" : "Selected plan: $title ($speed)",
              style: const TextStyle(fontFamily: 'Cairo'),
            ),
            backgroundColor: Colors.blueAccent,
            duration: const Duration(seconds: 2),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.1) : cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.blue : (isPopular ? Colors.green : Colors.transparent),
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
                        decoration: BoxDecoration(color: Colors.green.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                        child: const Text("الأشهر", style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                      ),
                    ]
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.bolt, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(speed, style: TextStyle(color: textMuted, fontSize: 13, fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
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
                  color: isSelected ? Colors.blue : textMuted,
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