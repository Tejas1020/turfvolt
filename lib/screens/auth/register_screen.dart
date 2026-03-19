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

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _isLoading = false;
  bool _obscurePass = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  bool _isValidEmail(String v) {
    final s = v.trim();
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(s);
  }

  int _strengthScore(String pass) {
    final p = pass;
    if (p.length < 8) return 1; // weak
    if (p.length <= 10) return 2; // fair
    final hasNum = RegExp(r'\d').hasMatch(p);
    final hasSpecial = RegExp(r'[^A-Za-z0-9]').hasMatch(p);
    return (hasNum || hasSpecial) ? 4 : 3;
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isLoading = true);
    try {
      await context.read<AuthProvider>().register(
            _nameCtrl.text.trim(),
            _emailCtrl.text.trim(),
            _passCtrl.text,
          );
      if (!mounted) return;
      showToast(context, 'Account created');
      context.go('/home');
    } catch (e) {
      AppLogger.e('Register error: $e');
      if (!mounted) return;
      showToast(context, e.toString(), isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final strength = _strengthScore(_passCtrl.text);
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
              'Create account',
              style: GoogleFonts.dmSans(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Start your fitness journey today',
              style: GoogleFonts.dmSans(fontSize: 14, color: AppColors.textMuted),
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
                      controller: _nameCtrl,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Full name',
                      prefixIcon: Icon(Icons.person_outline, color: AppColors.textDim, size: 18),
                    ),
                    validator: (v) {
                      final s = (v ?? '').trim();
                      if (s.isEmpty) return 'Name is required';
                      if (s.length < 2) return 'Enter at least 2 characters';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Email address',
                      prefixIcon: Icon(Icons.email_outlined, color: AppColors.textDim, size: 18),
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
                    obscureText: _obscurePass,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      helperText: 'Minimum 8 characters',
                      helperStyle: AppTextStyles.micro.copyWith(color: AppColors.textDim),
                      prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textDim, size: 18),
                      suffixIcon: IconButton(
                        onPressed: () => setState(() => _obscurePass = !_obscurePass),
                        icon: Icon(
                          _obscurePass ? Icons.visibility : Icons.visibility_off,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                    onChanged: (_) => setState(() {}),
                    validator: (v) {
                      final s = (v ?? '');
                      if (s.isEmpty) return 'Password is required';
                      if (s.length < 8) return 'Minimum 8 characters';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmCtrl,
                    obscureText: _obscureConfirm,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      labelText: 'Confirm password',
                      prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textDim, size: 18),
                      suffixIcon: IconButton(
                        onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                        icon: Icon(
                          _obscureConfirm ? Icons.visibility : Icons.visibility_off,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                    validator: (v) {
                      final s = (v ?? '');
                      if (s != _passCtrl.text) return 'Passwords do not match';
                      return null;
                    },
                    onFieldSubmitted: (_) => _submit(),
                  ),
                  const SizedBox(height: 8),
                  _PasswordStrength(strength: strength),
                  const SizedBox(height: 16),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.textMuted),
                        children: [
                          const TextSpan(text: 'By creating an account you agree to our '),
                          TextSpan(
                            text: 'Terms & Privacy Policy',
                            style: GoogleFonts.dmSans(
                              fontSize: 12,
                              color: AppColors.lime,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
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
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                              'Sign Up',
                              style: GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                    ),
                  ),
                ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: RichText(
                text: TextSpan(
                  style: GoogleFonts.dmSans(fontSize: 14),
                  children: [
                    TextSpan(
                      text: 'Already have an account? ',
                      style: GoogleFonts.dmSans(color: AppColors.textMuted),
                    ),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.baseline,
                      baseline: TextBaseline.alphabetic,
                      child: GestureDetector(
                        onTap: () => context.go('/login'),
                        child: Text(
                          'Log in',
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
          ],
        ),
      ),
    );
  }
}

class _PasswordStrength extends StatelessWidget {
  final int strength; // 1..4

  const _PasswordStrength({required this.strength});

  @override
  Widget build(BuildContext context) {
    Color activeColorForIndex(int i) {
      if (strength <= 1) return i == 0 ? AppColors.error : AppColors.textDim;
      if (strength == 2) return i <= 1 ? AppColors.warning : AppColors.textDim;
      if (strength >= 4) return AppColors.success;
      return i <= 2 ? AppColors.warning : AppColors.textDim;
    }

    return Row(
      children: [
        ...List.generate(4, (i) {
          return Container(
            width: 8,
            height: 4,
            margin: const EdgeInsets.only(right: 6),
            decoration: BoxDecoration(
              color: activeColorForIndex(i),
              borderRadius: BorderRadius.circular(99),
            ),
          );
        }),
        const SizedBox(width: 6),
        Text('Password strength', style: AppTextStyles.micro.copyWith(color: AppColors.textDim)),
      ],
    );
  }
}

