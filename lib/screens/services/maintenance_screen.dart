import 'package:flutter/material.dart';
import 'package:estor_alihab/app_colors.dart';
import 'package:estor_alihab/services/service_api.dart';

class MaintenanceScreen extends StatefulWidget {
  final bool isDarkMode;
  final String currentLocale;

  const MaintenanceScreen({
    Key? key,
    required this.isDarkMode,
    required this.currentLocale,
  }) : super(key: key);

  @override
  State<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen> {
  final TextEditingController deviceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String? selectedIssue;
  bool isSubmitting = false;

  final List<String> issuesAr = ["شاشة مكسورة", "مشكلة في البطارية", "مشكلة برمجية", "توقف عن العمل"];
  final List<String> issuesEn = ["Broken Screen", "Battery Issue", "Software Bug", "Device Not Working"];

  @override
  void dispose() {
    deviceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitMaintenanceRequest() async {
    final device = deviceController.text.trim();
    final description = descriptionController.text.trim();
    final isArabic = widget.currentLocale == 'ar';

    if (device.isEmpty || selectedIssue == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isArabic ? "الرجاء إدخال نوع الجهاز واختيار العطل!" : "Please enter device type and select issue!",
            style: const TextStyle(fontFamily: 'Cairo'),
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => isSubmitting = true);

    final success = await ServicesApi.submitMaintenance({
      'device': device,
      'issue': selectedIssue,
      'description': description,
    });

    setState(() => isSubmitting = false);

    if (!mounted) return;

    if (success) {
      deviceController.clear();
      descriptionController.clear();
      setState(() => selectedIssue = null);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isArabic ? "تم إرسال طلب الصيانة بنجاح!" : "Maintenance request submitted successfully!",
            style: const TextStyle(fontFamily: 'Cairo'),
          ),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isArabic
                ? "فشل إرسال الطلب. تأكد أنك سجّلت الدخول وحاول مرة أخرى"
                : "Failed to submit request. Make sure you're logged in and try again",
            style: const TextStyle(fontFamily: 'Cairo'),
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = widget.currentLocale == 'ar';
    final backgroundColor = widget.isDarkMode ? AppColors.darkBackground : AppColors.lightBackground;
    final cardColor = widget.isDarkMode ? AppColors.darkBackgroundSecondary : AppColors.lightBackgroundSecondary;
    final textColor = widget.isDarkMode ? AppColors.darkTextLight : AppColors.lightTextDark;

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          elevation: 0,
          title: Text(
            isArabic ? "طلب صيانة" : "Maintenance Request",
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
          ),
          leading: IconButton(
            icon: Icon(isArabic ? Icons.arrow_forward_ios_rounded : Icons.arrow_back_ios_new_rounded, color: textColor),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel(isArabic ? "نوع الجهاز" : "Device Type", textColor),
              _buildTextField(deviceController, isArabic ? "مثلاً: iPhone 15" : "e.g., iPhone 15", Icons.phone_iphone_rounded, cardColor, textColor),

              const SizedBox(height: 20),

              _buildLabel(isArabic ? "طبيعة العطل" : "Issue Type", textColor),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(14)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    hint: Text(isArabic ? "اختر العطل" : "Select Issue", style: TextStyle(fontFamily: 'Cairo', color: Colors.grey)),
                    value: selectedIssue,
                    isExpanded: true,
                    dropdownColor: cardColor,
                    items: (isArabic ? issuesAr : issuesEn).map((val) => DropdownMenuItem(value: val, child: Text(val, style: TextStyle(fontFamily: 'Cairo', color: textColor)))).toList(),
                    onChanged: (val) => setState(() => selectedIssue = val),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              _buildLabel(isArabic ? "وصف المشكلة" : "Description", textColor),
              _buildTextField(descriptionController, isArabic ? "اشرح المشكلة بالتفصيل..." : "Explain the issue in detail...", Icons.description_outlined, cardColor, textColor, maxLines: 4),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentBlue, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                  onPressed: isSubmitting ? null : _submitMaintenanceRequest,
                  child: isSubmitting
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : Text(isArabic ? "إرسال طلب الصيانة" : "Submit Request", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Cairo', fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, Color color) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(text, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
  );

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon, Color bg, Color textColor, {int maxLines = 1}) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14),
    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(14)),
    child: TextField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(color: textColor, fontFamily: 'Cairo'),
      decoration: InputDecoration(icon: Icon(icon, color: Colors.grey), hintText: hint, hintStyle: const TextStyle(fontFamily: 'Cairo', color: Colors.grey), border: InputBorder.none),
    ),
  );
}