import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:estor_alihab/app_colors.dart';

class OrderHistoryScreen extends StatefulWidget {
  final bool isDarkMode;
  final String currentLocale;
  final String token;

  const OrderHistoryScreen({
    Key? key,
    required this.isDarkMode,
    required this.currentLocale,
    required this.token,
  }) : super(key: key);

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  static const String baseUrl = 'http://10.0.2.2:5000/api';
  String selectedFilter = 'all';
  List<Map<String, dynamic>> orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOrdersFromApi();
  }

  Future<void> _fetchOrdersFromApi() async {
    if (widget.token.isEmpty) {
      if (mounted) setState(() => isLoading = false);
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/orders/my-orders'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        List<Map<String, dynamic>> loadedOrders = data.map((order) {
          String formattedDate = '';
          var rawDate = order['createdAt'];
          if (rawDate != null) {
            formattedDate = rawDate.toString().length >= 10
                ? rawDate.toString().substring(0, 10)
                : rawDate.toString();
          }

          return {
            'id': order['id'] ?? '',
            'status': order['status'] ?? 'pending',
            'price': order['totalAmount'] ?? 0,
            'date': formattedDate,
            'items': order['items'] ?? [],
            'deliveryMethod': order['shippingAddress'] ?? '',
          };
        }).toList();

        if (mounted) {
          setState(() {
            orders = loadedOrders;
            isLoading = false;
          });
        }
      } else {
        if (mounted) setState(() => isLoading = false);
      }
    } catch (e) {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = widget.currentLocale == 'ar';
    final backgroundColor = widget.isDarkMode ? AppColors.darkBackground : AppColors.lightBackground;
    final cardColor = widget.isDarkMode ? AppColors.darkBackgroundSecondary : AppColors.lightBackgroundSecondary;
    final textColor = widget.isDarkMode ? AppColors.darkTextLight : AppColors.lightTextDark;
    final textMuted = widget.isDarkMode ? AppColors.darkTextMuted : AppColors.lightTextMuted;

    final filteredOrders = selectedFilter == 'all'
        ? orders
        : orders.where((o) => o['status'] == selectedFilter).toList();

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
            isArabic ? "سجل طلباتي" : "Order History",
            style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
          ),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.withOpacity(0.15)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem("${orders.length}", isArabic ? "إجمالي الطلبات" : "Total", Colors.blue, textColor, textMuted),
                  _buildStatItem("${orders.where((o) => o['status'] == 'pending').length}", isArabic ? "قيد الانتظار" : "Pending", Colors.amber, textColor, textMuted),
                  _buildStatItem("${orders.where((o) => o['status'] == 'shipped' || o['status'] == 'shipping').length}", isArabic ? "تم الشحن" : "Shipped", Colors.blueAccent, textColor, textMuted),
                  _buildStatItem("${orders.where((o) => o['status'] == 'delivered').length}", isArabic ? "تم التسليم" : "Delivered", Colors.green, textColor, textMuted),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildFilterTab('all', isArabic ? "الكل" : "All"),
                  const SizedBox(width: 8),
                  _buildFilterTab('pending', isArabic ? "قيد الانتظار" : "Pending"),
                  const SizedBox(width: 8),
                  _buildFilterTab('shipped', isArabic ? "تم الشحن" : "Shipped"),
                  const SizedBox(width: 8),
                  _buildFilterTab('delivered', isArabic ? "تم التسليم" : "Delivered"),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: filteredOrders.isEmpty
                  ? Center(child: Text(isArabic ? "لا توجد طلبات" : "No orders found", style: TextStyle(color: textMuted, fontFamily: 'Cairo')))
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filteredOrders.length,
                itemBuilder: (context, index) {
                  final order = filteredOrders[index];
                  return _buildOrderCard(order, cardColor, textColor, textMuted, isArabic);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String count, String label, Color color, Color textColor, Color textMuted) {
    return Column(
      children: [
        Text(count, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(color: textMuted, fontSize: 11, fontFamily: 'Cairo')),
      ],
    );
  }

  Widget _buildFilterTab(String key, String title) {
    final bool isSelected = selectedFilter == key;
    return ChoiceChip(
      label: Text(title, style: TextStyle(fontFamily: 'Cairo', fontSize: 12, color: isSelected ? Colors.white : Colors.grey[700])),
      selected: isSelected,
      selectedColor: Colors.blue,
      backgroundColor: Colors.grey.withOpacity(0.1),
      onSelected: (bool selected) {
        setState(() {
          selectedFilter = key;
        });
      },
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order, Color cardColor, Color textColor, Color textMuted, bool isArabic) {
    final status = order['status'] ?? 'pending';
    Color statusColor = Colors.amber;
    String statusTextAr = 'قيد الانتظار';
    String statusTextEn = 'Pending';

    if (status == 'shipped' || status == 'shipping') {
      statusColor = Colors.blue;
      statusTextAr = 'تم الشحن';
      statusTextEn = 'Shipped';
    } else if (status == 'delivered') {
      statusColor = Colors.green;
      statusTextAr = 'تم التسليم';
      statusTextEn = 'Delivered';
    }

    final items = order['items'] ?? [];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.15)),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              order['id'].toString().length >= 6
                  ? "#${order['id'].toString().substring(0, 6)}"
                  : "#${order['id']}",
              style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 14, fontFamily: 'Cairo'),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(Icons.circle, size: 8, color: statusColor),
                  const SizedBox(width: 6),
                  Text(
                    isArabic ? statusTextAr : statusTextEn,
                    style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                  ),
                ],
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${order['price']} ₪", style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'Cairo')),
              Text(order['date'], style: TextStyle(color: textMuted, fontSize: 11, fontFamily: 'Cairo')),
            ],
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                const SizedBox(height: 8),
                Text(isArabic ? "المنتجات:" : "Items:", style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 12, fontFamily: 'Cairo')),
                const SizedBox(height: 6),
                ...((items as List).map((item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${item['quantity']}x ${item['name'] ?? item['title'] ?? ''}", style: TextStyle(color: textMuted, fontSize: 12, fontFamily: 'Cairo')),
                      Text("${item['price']} ₪", style: TextStyle(color: textColor, fontSize: 12, fontFamily: 'Cairo')),
                    ],
                  ),
                ))),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(isArabic ? "عنوان التوصيل:" : "Delivery Address:", style: TextStyle(color: textMuted, fontSize: 12, fontFamily: 'Cairo')),
                    Expanded(
                      child: Text(
                        order['deliveryMethod'].toString(),
                        textAlign: TextAlign.end,
                        style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 12, fontFamily: 'Cairo'),
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
}