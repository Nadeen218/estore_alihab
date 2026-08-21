import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:estor_alihab/app_colors.dart';
import '../home/home_screen.dart';

class TrackOrderScreen extends StatefulWidget {
  final bool isDarkMode;
  final String currentLocale;
  final bool isLoggedIn;
  final String? initialOrderId;
  final String? initialPhoneNumber;

  const TrackOrderScreen({
    Key? key,
    this.isDarkMode = false,
    this.currentLocale = 'ar',
    this.isLoggedIn = true,
    this.initialOrderId,
    this.initialPhoneNumber,
  }) : super(key: key);

  @override
  State<TrackOrderScreen> createState() => _TrackOrderScreenState();
}

class _TrackOrderScreenState extends State<TrackOrderScreen> {
  late TextEditingController _orderIdController;
  late TextEditingController _phoneController;
  late bool _isLoggedIn;

  bool _hasSearched = false;
  bool _isLoading = false;
  Map<String, dynamic>? _orderDetails;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _isLoggedIn = widget.isLoggedIn;
    _orderIdController = TextEditingController(text: widget.initialOrderId ?? '');
    _phoneController = TextEditingController(text: widget.initialPhoneNumber ?? '');

    if (_orderIdController.text.isNotEmpty && _phoneController.text.isNotEmpty) {
      _handleSearch();
    }
  }

  @override
  void dispose() {
    _orderIdController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _navigateToHome() {
    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(
          isDarkMode: widget.isDarkMode,
          currentLocale: widget.currentLocale,
          isLoggedIn: _isLoggedIn,
        ),
      ),
          (route) => false,
    );
  }

  Future<void> _handleSearch() async {
    FocusScope.of(context).unfocus();

    final orderId = _orderIdController.text.trim();
    final phone = _phoneController.text.trim();
    final isArabic = widget.currentLocale == 'ar';

    if (orderId.isEmpty || phone.isEmpty) {
      setState(() {
        _hasSearched = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isArabic
                ? "يرجى إدخال رقم الطلب ورقم الهاتف للمتابعة"
                : "Please enter Order ID and Phone Number to proceed",
            style: const TextStyle(fontFamily: 'Cairo'),
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    setState(() {
      _hasSearched = true;
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await http.get(
        Uri.parse('http://localhost:5000/api/orders/track?orderId=$orderId&phone=$phone'),
      );

      if (response.statusCode == 200) {
        setState(() {
          _orderDetails = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = isArabic ? "لم يتم العثور على الطلب" : "Order not found";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = isArabic ? "خطأ في الاتصال بالخادم" : "Server connection error";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = widget.currentLocale == 'ar';
    final backgroundColor = widget.isDarkMode ? AppColors.darkBackground : const Color(0xFFF2F5F9);
    final cardColor = widget.isDarkMode ? AppColors.darkBackgroundSecondary : Colors.white;
    final textColor = widget.isDarkMode ? AppColors.darkTextLight : const Color(0xFF0F172A);
    final mutedTextColor = widget.isDarkMode ? AppColors.darkTextMuted : const Color(0xFF8E9BAE);
    final primaryBlue = const Color(0xFF0052CC);

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        _navigateToHome();
      },
      child: Directionality(
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
                  onPressed: _navigateToHome,
                ),
              ),
            ),
            centerTitle: true,
            title: Text(
              isArabic ? "تتبع طلبك" : "Track Your Order",
              style: TextStyle(
                color: textColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo',
              ),
            ),
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.local_shipping_outlined,
                        size: 60,
                        color: primaryBlue,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isArabic ? "تتبع شحنتك بسهولة" : "Track your shipment easily",
                        style: TextStyle(
                          color: primaryBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isArabic ? "البحث عن الطلب" : "Search Order",
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      const SizedBox(height: 14),

                      _buildInputField(
                        controller: _orderIdController,
                        hint: isArabic ? "رقم الطلب" : "Order ID",
                        icon: Icons.inventory_2_outlined,
                        isDarkMode: widget.isDarkMode,
                        textColor: textColor,
                        mutedTextColor: mutedTextColor,
                      ),

                      const SizedBox(height: 12),

                      _buildInputField(
                        controller: _phoneController,
                        hint: isArabic ? "رقم الهاتف" : "Phone Number",
                        icon: Icons.phone_android_outlined,
                        keyboardType: TextInputType.phone,
                        isDarkMode: widget.isDarkMode,
                        textColor: textColor,
                        mutedTextColor: mutedTextColor,
                      ),

                      const SizedBox(height: 16),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryBlue,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 0,
                          ),
                          onPressed: _handleSearch,
                          child: Text(
                            isArabic ? "بحث وتتبع" : "Search & Track",
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

                if (_hasSearched) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: _isLoading
                        ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                        : _errorMessage != null
                        ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                        : Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  isArabic ? "حالة الطلب " : "Order Status ",
                                  style: TextStyle(
                                    color: textColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                                Text(
                                  "#${_orderIdController.text.trim()}",
                                  style: TextStyle(
                                    color: textColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDCFCE7),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.local_shipping, size: 12, color: Color(0xFF15803D)),
                                  const SizedBox(width: 4),
                                  Text(
                                    _orderDetails?['status'] ?? (isArabic ? "في الطريق" : "On the way"),
                                    style: const TextStyle(
                                      color: Color(0xFF15803D),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                      fontFamily: 'Cairo',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        _buildTrackStep(
                          title: isArabic ? "تم استلام الطلب" : "Order Received",
                          subtitle: isArabic
                              ? "الطلب رقم #${_orderIdController.text.trim()} تم استلامه"
                              : "Order #${_orderIdController.text.trim()} received",
                          status: StepStatus.completed,
                          textColor: textColor,
                          mutedTextColor: mutedTextColor,
                          isArabic: isArabic,
                        ),
                        _buildTrackStep(
                          title: isArabic ? "قيد التجهيز" : "Processing",
                          subtitle: isArabic ? "يتم تجهيز طلبك الآن في المستودع" : "Being prepared in warehouse",
                          status: StepStatus.completed,
                          textColor: textColor,
                          mutedTextColor: mutedTextColor,
                          isArabic: isArabic,
                        ),
                        _buildTrackStep(
                          title: isArabic ? "مع المندوب" : "With Courier",
                          subtitle: isArabic ? "المندوب في الطريق إليك" : "Courier is on the way to you",
                          status: StepStatus.active,
                          textColor: textColor,
                          mutedTextColor: mutedTextColor,
                          isArabic: isArabic,
                        ),
                        _buildTrackStep(
                          title: isArabic ? "تم التسليم" : "Delivered",
                          subtitle: isArabic ? "في انتظار التسليم النهائي" : "Awaiting final delivery",
                          status: StepStatus.pending,
                          isLast: true,
                          textColor: textColor,
                          mutedTextColor: mutedTextColor,
                          isArabic: isArabic,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required bool isDarkMode,
    required Color textColor,
    required Color mutedTextColor,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkBackground : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(color: textColor, fontFamily: 'Cairo', fontSize: 13),
        decoration: InputDecoration(
          icon: Icon(icon, color: mutedTextColor, size: 18),
          hintText: hint,
          hintStyle: TextStyle(color: mutedTextColor, fontFamily: 'Cairo', fontSize: 13),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildTrackStep({
    required String title,
    required String subtitle,
    required StepStatus status,
    required Color textColor,
    required Color mutedTextColor,
    required bool isArabic,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            _buildStatusIcon(status),
            if (!isLast)
              Container(
                width: 2,
                height: 38,
                color: status == StepStatus.completed
                    ? const Color(0xFF22C55E)
                    : const Color(0xFFE2E8F0),
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 13.5,
                  fontFamily: 'Cairo',
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  color: mutedTextColor,
                  fontSize: 11,
                  fontFamily: 'Cairo',
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusIcon(StepStatus status) {
    switch (status) {
      case StepStatus.completed:
        return Container(
          width: 22,
          height: 22,
          decoration: const BoxDecoration(
            color: Color(0xFF22C55E),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, size: 14, color: Colors.white),
        );
      case StepStatus.active:
        return Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF0052CC), width: 6),
          ),
        );
      case StepStatus.pending:
      default:
        return Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFCBD5E1), width: 2),
          ),
        );
    }
  }
}

enum StepStatus { completed, active, pending }