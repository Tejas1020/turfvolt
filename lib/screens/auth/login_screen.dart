import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/app_colors.dart';
import '../../core/app_logger.dart';
import '../../core/app_text_styles.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_toast.dart';
import '../../widgets/glass_panel.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  bool _isLoading = false;
  bool _obscure = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  bool _isValidEmail(String v) {
    final s = v.trim();
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(s);
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isLoading = true);
    try {
      await context.read<AuthProvider>().login(
            _emailCtrl.text.trim(),
            _passCtrl.text,
          );
      if (!mounted) return;
      showToast(context, 'Logged in');
      context.go('/home');
    } catch (e) {
      AppLogger.e('Login error: $e');
      if (!mounted) return;
      showToast(context, e.toString(), isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBg,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            Text(
              'TURFVOLT',
              style: AppTextStyles.appLogo.copyWith(
                fontSize: 36,
                letterSpacing: 3,
                color: AppColors.lime,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Welcome back',
              style: GoogleFonts.dmSans(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Log in to continue your journey',
              style: GoogleFonts.dmSans(
                fontSize: 14,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 40),
            GlassPanel(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              borderRadius: 20,
              blurSigma: 10,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Email address',
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: AppColors.textDim,
                        size: 18,
                      ),
                    ),
                    validator: (v) {
                      final s = (v ?? '').trim();
                      if (s.isEmpty) return 'Email is required';
                      if (!_isValidEmail(s)) return 'Enter a valid email';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passCtrl,
                    obscureText: _obscure,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: AppColors.textDim,
                        size: 18,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () => setState(() => _obscure = !_obscure),
                        icon: Icon(
                          _obscure ? Icons.visibility : Icons.visibility_off,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                    validator: (v) {
                      final s = (v ?? '');
                      if (s.isEmpty) return 'Password is required';
                      if (s.length < 8) return 'Minimum 8 characters';
                      return null;
                    },
                    onFieldSubmitted: (_) => _submit(),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Password reset coming soon'),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.lime,
                        ),
                        child: Text(
                          'Forgot password?',
                          style: GoogleFonts.dmSans(fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.lime,
                          foregroundColor: AppColors.appBg,
                          minimumSize: const Size(double.infinity, 52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.appBg,
                              ),
                            )
                          : Text(
                              'Log In',
                              style: GoogleFonts.dmSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                const Expanded(child: Divider(color: AppColors.borderDefault)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'or',
                    style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.textMuted),
                  ),
                ),
                const Expanded(child: Divider(color: AppColors.borderDefault)),
              ],
            ),
            const SizedBox(height: 24),
            Center(
              child: RichText(
                text: TextSpan(
                  style: GoogleFonts.dmSans(fontSize: 14),
                  children: [
                    TextSpan(
                      text: "Don't have an account? ",
                      style: TextStyle(color: AppColors.textMuted),
                    ),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.baseline,
                      baseline: TextBaseline.alphabetic,
                      child: GestureDetector(
                        onTap: () => context.go('/register'),
                        child: Text(
                          'Sign up',
                          style: GoogleFonts.dmSans(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.lime,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Tip: Make sure Appwrite project IDs are set in constants.dart',
              style: AppTextStyles.micro,
            ),
          ],
        ),
      ),
    );
  }
}

