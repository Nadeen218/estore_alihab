import 'package:flutter/material.dart';
import 'package:estor_alihab/app_colors.dart';

class SearchBarWidget extends StatefulWidget {
  final bool isDarkMode;
  final Color cardBg;
  final Color textMain;
  final Color textSub;
  final String currentLocale;
  final VoidCallback onLanguageToggle;
  final ValueChanged<String> onSearchChanged;

  const SearchBarWidget({
    Key? key,
    required this.isDarkMode,
    required this.cardBg,
    required this.textMain,
    required this.textSub,
    required this.currentLocale,
    required this.onLanguageToggle,
    required this.onSearchChanged,
  }) : super(key: key);

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _controller = TextEditingController();

  void _clearSearch() {
    _controller.clear();
    widget.onSearchChanged("");
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = widget.currentLocale == 'ar';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: widget.cardBg,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: widget.textMain.withOpacity(0.06), width: 1),
                boxShadow: widget.isDarkMode
                    ? []
                    : [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 5))],
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  Icon(Icons.search_rounded, color: widget.textSub, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      textAlign: isArabic ? TextAlign.right : TextAlign.left,
                      textInputAction: TextInputAction.search,
                      onChanged: widget.onSearchChanged,
                      style: TextStyle(color: widget.textMain, fontSize: 14, fontFamily: 'Cairo'),
                      decoration: InputDecoration(
                        hintText: isArabic ? "ابحث عن منتجك المفضل..." : "Search your favorite product...",
                        hintStyle: TextStyle(color: widget.textSub.withOpacity(0.8), fontSize: 13, fontFamily: 'Cairo'),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _controller,
                    builder: (context, value, _) {
                      if (value.text.isEmpty) return const SizedBox.shrink();
                      return IconButton(
                        onPressed: _clearSearch,
                        icon: Icon(Icons.close_rounded, color: widget.textSub, size: 18),
                      );
                    },
                  ),
                  const SizedBox(width: 4),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: widget.onLanguageToggle,
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.accentBlue,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accentBlue.withOpacity(0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                isArabic ? "EN" : "AR",
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}