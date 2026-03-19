import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';
import '../../widgets/lime_button.dart';

class ValuePropScreen extends StatefulWidget {
  const ValuePropScreen({super.key});

  @override
  State<ValuePropScreen> createState() => _ValuePropScreenState();
}

class _ValuePropScreenState extends State<ValuePropScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<ValuePropSlide> _slides = [
    ValuePropSlide(
      icon: Icons.timer_outlined,
      iconColor: AppColors.summerOrange,
      title: 'Log workouts in 30 seconds',
      description: 'Quick, intuitive logging that fits your routine. No complicated forms or endless inputs.',
      gradient: const LinearGradient(
        colors: [AppColors.summerOrange, AppColors.sunshineYellow],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    ValuePropSlide(
      icon: Icons.trending_up,
      iconColor: AppColors.oceanBlue,
      title: 'See your progress over time',
      description: 'Beautiful visualizations show your strength gains, consistency, and personal records.',
      gradient: const LinearGradient(
        colors: [AppColors.oceanBlue, AppColors.skyBlue],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    ValuePropSlide(
      icon: Icons.people_outline,
      iconColor: AppColors.success,
      title: 'Join thousands crushing goals',
      description: 'Become part of a community that celebrates every PR, every streak, every win.',
      gradient: const LinearGradient(
        colors: [AppColors.success, AppColors.accentLight],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBg,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Expanded(
              flex: 3,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemCount: _slides.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: _SlideContent(slide: _slides[index]),
                ),
              ),
            ),
            const Spacer(),
            _buildPageIndicator(),
            const SizedBox(height: 32),
            _buildCTA(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _SlideContent({required ValuePropSlide slide}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            gradient: slide.gradient,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: slide.iconColor.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Icon(
            slide.icon,
            size: 60,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 40),
        Text(
          slide.title,
          style: AppTextStyles.headline.copyWith(
            fontSize: 28,
            color: AppColors.textPrimary,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          slide.description,
          style: AppTextStyles.bodySecondary.copyWith(
            fontSize: 16,
            height: 1.6,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _slides.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: index == _currentPage ? 28 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: index == _currentPage
                ? AppColors.summerOrange
                : AppColors.borderDefault,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  Widget _buildCTA() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: LimeButton(
        label: 'Get Started',
        onPressed: () => context.go('/onboarding/goals'),
        icon: Icons.arrow_forward,
        fullWidth: true,
      ),
    );
  }
}

class ValuePropSlide {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  final Gradient gradient;

  ValuePropSlide({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    required this.gradient,
  });
}
