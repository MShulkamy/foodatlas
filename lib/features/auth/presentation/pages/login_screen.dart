import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/labeled_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../widgets/social_login_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.screenPadding,
            vertical: AppSizes.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ===== اللوجو + اسم البراند =====
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.emoji_food_beverage_outlined, color: AppColors.primary, size: 22),
                  const SizedBox(width: 8),
                  Text(AppStrings.brandName, style: AppTextStyles.brandTitle),
                ],
              ),
              const SizedBox(height: AppSizes.xl),

              // ===== العنوان والوصف =====
              Text(AppStrings.welcomeBack, style: AppTextStyles.h2),
              const SizedBox(height: AppSizes.sm),
              Text(
                AppStrings.welcomeSubtitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: AppSizes.xl),

              // ===== كارت الفورم =====
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSizes.lg),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                  border: Border.all(color: AppColors.border),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 20,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Email field
                    LabeledTextField(
                      label: AppStrings.emailLabel,
                      hint: AppStrings.emailHint,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(Icons.mail_outline, size: 20, color: AppColors.textHint),
                    ),
                    const SizedBox(height: AppSizes.md),

                    // Password field
                    LabeledTextField(
                      label: AppStrings.passwordLabel,
                      hint: '••••••••',
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      labelTrailing: GestureDetector(
                        onTap: () {
                          // TODO: تنفيذ منطق "نسيت كلمة السر"
                        },
                        child: Text(AppStrings.forgot, style: AppTextStyles.link),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          size: 20,
                          color: AppColors.textHint,
                        ),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    const SizedBox(height: AppSizes.lg),

                    // Sign in button
                    PrimaryButton(
                      label: AppStrings.signIn,
                      trailingIcon: const Icon(Icons.arrow_forward, size: 18, color: Colors.white),
                      onPressed: () {
                        // TODO: ربط منطق تسجيل الدخول
                      },
                    ),
                    const SizedBox(height: AppSizes.lg),

                    // Divider
                    Row(
                      children: [
                        const Expanded(child: Divider(color: AppColors.divider)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm),
                          child: Text(AppStrings.orContinueWith, style: AppTextStyles.bodySmall),
                        ),
                        const Expanded(child: Divider(color: AppColors.divider)),
                      ],
                    ),
                    const SizedBox(height: AppSizes.lg),

                    // Social buttons
                    Row(
                      children: [
                        Expanded(
                          child: SocialLoginButton(
                            label: AppStrings.google,
                            icon: const _GoogleIcon(),
                            onPressed: () {},
                          ),
                        ),
                        const SizedBox(width: AppSizes.md),
                        Expanded(
                          child: SocialLoginButton(
                            label: AppStrings.apple,
                            icon: const Icon(Icons.apple, size: 20, color: Colors.black),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.lg),

              // ===== رابط تسجيل حساب جديد =====
              RichText(
                text: TextSpan(
                  style: AppTextStyles.bodySmall,
                  children: [
                    const TextSpan(text: AppStrings.noAccount),
                    TextSpan(
                      text: AppStrings.signUp,
                      style: AppTextStyles.link,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// أيقونة G بسيطة بألوان جوجل (بدون الاعتماد على أصول خارجية)
class _GoogleIcon extends StatelessWidget {
  const _GoogleIcon();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'G',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Color(0xFF4285F4),
      ),
    );
  }
}
