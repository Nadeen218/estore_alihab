// lib/auth/login_screen.dart

import 'package:flutter/material.dart';
import 'package:estor_alihab/app_colors.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  final bool isDarkMode;
  final String currentLocale;

  const LoginScreen({
    Key? key,
    this.isDarkMode = true,
    this.currentLocale = 'ar',
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = widget.isDarkMode;
    final isArabic = widget.currentLocale == 'ar';

    final backgroundColor = isDarkMode ? AppColors.darkBackground : AppColors.lightBackground;
    final cardColor = isDarkMode ? AppColors.darkBackgroundSecondary : AppColors.lightBackgroundSecondary;
    final textColor = isDarkMode ? AppColors.darkTextLight : AppColors.lightTextDark;
    final textMutedColor = isDarkMode ? AppColors.darkTextMuted : AppColors.lightTextMuted;

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
              isArabic ? Icons.arrow_back_ios_new_rounded : Icons.arrow_forward_ios_rounded,
              color: textColor,
              size: 20,
            ),
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
                  Center(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.accentBlue.withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.lock_person_outlined,
                            size: 48,
                            color: AppColors.accentBlue,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          isArabic ? "أهلاً بك مجدداً! " : "Welcome Back! ",
                          style: TextStyle(
                            color: textColor,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          isArabic
                              ? "قم بتسجيل الدخول لمتابعة التسوق ومتابعة الطلبات"
                              : "Log in to continue shopping and tracking your orders",
                          style: TextStyle(
                            color: textMutedColor,
                            fontSize: 13,
                            fontFamily: 'Cairo',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 36),

                  Text(
                    isArabic ? "البريد الإلكتروني / رقم الهاتف" : "Email / Phone Number",
                    style: TextStyle(
                      color: textColor,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _emailController,
                    style: TextStyle(color: textColor, fontFamily: 'Cairo', fontSize: 14),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return isArabic
                            ? "يرجى إدخال البريد الإلكتروني أو رقم الهاتف"
                            : "Please enter email or phone number";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "example@gmail.com",
                      hintStyle: TextStyle(color: textMutedColor.withOpacity(0.6), fontSize: 13),
                      prefixIcon: Icon(Icons.email_outlined, color: textMutedColor, size: 20),
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
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    isArabic ? "كلمة المرور" : "Password",
                    style: TextStyle(
                      color: textColor,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    style: TextStyle(color: textColor, fontFamily: 'Cairo', fontSize: 14),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return isArabic ? "يرجى إدخال كلمة المرور" : "Please enter password";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "••••••••",
                      hintStyle: TextStyle(color: textMutedColor.withOpacity(0.6), fontSize: 13),
                      prefixIcon: Icon(Icons.lock_outline, color: textMutedColor, size: 20),
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
                    ),
                  ),

                  Align(
                    alignment: isArabic ? Alignment.centerLeft : Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        isArabic ? "نسيت كلمة المرور؟" : "Forgot Password?",
                        style: const TextStyle(
                          color: AppColors.accentCyan,
                          fontSize: 12,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

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
                            SnackBar(
                              content: Text(
                                isArabic ? "تم تسجيل الدخول بنجاح!" : "Logged in successfully!",
                                style: const TextStyle(fontFamily: 'Cairo'),
                              ),
                              backgroundColor: AppColors.accentGreen,
                            ),
                          );
                          Navigator.pop(context, true);
                        }
                      },
                      child: Text(
                        isArabic ? "تسجيل الدخول" : "Login",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isArabic ? "ليس لديك حساب؟" : "Don't have an account?",
                        style: TextStyle(color: textMutedColor, fontFamily: 'Cairo', fontSize: 13),
                      ),
                      GestureDetector(
                        onTap: () async {
                          final result = await Navigator.push<bool>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterScreen(
                                isDarkMode: isDarkMode,
                                currentLocale: widget.currentLocale,
                              ),
                            ),
                          );

                          if (result == true && mounted) {
                            Navigator.pop(context, true);
                          }
                        },
                        child: Text(
                          isArabic ? " إنشاء حساب جديد" : " Sign Up",
                          style: const TextStyle(
                            color: AppColors.accentBlue,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}