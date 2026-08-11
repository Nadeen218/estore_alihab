// lib/auth/register_screen.dart

import 'package:flutter/material.dart';
import 'package:estor_alihab/app_colors.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  final bool isDarkMode;

  const RegisterScreen({
    Key? key,
    this.isDarkMode = true,
  }) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = widget.isDarkMode;
    final backgroundColor = isDarkMode ? AppColors.darkBackground : AppColors.lightBackground;
    final cardColor = isDarkMode ? AppColors.darkBackgroundSecondary : AppColors.lightBackgroundSecondary;
    final textColor = isDarkMode ? AppColors.darkTextLight : AppColors.lightTextDark;
    final textMutedColor = isDarkMode ? AppColors.darkTextMuted : AppColors.lightTextMuted;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: textColor, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // الترويسة
                  Center(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.accentCyan.withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.person_add_alt_1_outlined,
                            size: 44,
                            color: AppColors.accentCyan,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "إنشاء حساب جديد ✨",
                          style: TextStyle(
                            color: textColor,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "انضم إلينا واستمتع بتجربة تسوق مميزة",
                          style: TextStyle(
                            color: textMutedColor,
                            fontSize: 13,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // الاسم الكامل
                  _buildInputLabel("الاسم الكامل", textColor),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _nameController,
                    style: TextStyle(color: textColor, fontFamily: 'Cairo', fontSize: 14),
                    validator: (v) => v == null || v.trim().isEmpty ? "يرجى إدخال الاسم" : null,
                    decoration: _buildInputDecoration("محمد أحمد", Icons.person_outline, cardColor, textMutedColor, isDarkMode),
                  ),

                  const SizedBox(height: 18),

                  // رقم الهاتف
                  _buildInputLabel("رقم الهاتف", textColor),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    style: TextStyle(color: textColor, fontFamily: 'Cairo', fontSize: 14),
                    validator: (v) => v == null || v.trim().isEmpty ? "يرجى إدخال رقم الهاتف" : null,
                    decoration: _buildInputDecoration("059XXXXXXX", Icons.phone_android_outlined, cardColor, textMutedColor, isDarkMode),
                  ),

                  const SizedBox(height: 18),

                  // البريد الإلكتروني
                  _buildInputLabel("البريد الإلكتروني", textColor),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(color: textColor, fontFamily: 'Cairo', fontSize: 14),
                    validator: (v) => v == null || !v.contains("@") ? "يرجى إدخال بريد إلكتروني صحيح" : null,
                    decoration: _buildInputDecoration("example@gmail.com", Icons.email_outlined, cardColor, textMutedColor, isDarkMode),
                  ),

                  const SizedBox(height: 18),

                  // كلمة المرور
                  _buildInputLabel("كلمة المرور", textColor),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    style: TextStyle(color: textColor, fontFamily: 'Cairo', fontSize: 14),
                    validator: (v) => v == null || v.length < 6 ? "كلمة المرور يجب أن تكون 6 خانات على الأقل" : null,
                    decoration: _buildInputDecoration("••••••••", Icons.lock_outline, cardColor, textMutedColor, isDarkMode).copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: textMutedColor,
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // زر إنشاء الحساب
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accentBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("تم إنشاء الحساب بنجاح!", style: TextStyle(fontFamily: 'Cairo')),
                              backgroundColor: AppColors.accentGreen,
                            ),
                          );
                          Navigator.pop(context, true);
                        }
                      },
                      child: const Text(
                        "إنشاء الحساب",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // العودة لتسجيل الدخول
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "لديك حساب بالفعل؟",
                        style: TextStyle(color: textMutedColor, fontFamily: 'Cairo', fontSize: 13),
                      ),
                      GestureDetector(
                        onTap: () async {
                          final result = await Navigator.push<bool>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(isDarkMode: isDarkMode),
                            ),
                          );

                          if (result == true && mounted) {
                            Navigator.pop(context, true);
                          }
                        },
                        child: const Text(
                          " تسجيل الدخول",
                          style: TextStyle(
                            color: AppColors.accentBlue,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputLabel(String title, Color textColor) {
    return Text(
      title,
      style: TextStyle(
        color: textColor,
        fontSize: 13,
        fontWeight: FontWeight.bold,
        fontFamily: 'Cairo',
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint, IconData icon, Color cardColor, Color textMutedColor, bool isDarkMode) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: textMutedColor.withOpacity(0.6), fontSize: 13),
      prefixIcon: Icon(icon, color: textMutedColor, size: 20),
      filled: true,
      fillColor: cardColor,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.accentBlue, width: 1.5),
      ),
    );
  }
}