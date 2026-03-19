import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';
import '../../widgets/lime_button.dart';
import '../../widgets/muscle_chip.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  String? _selectedGoal;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  final List<Map<String, dynamic>> _goals = [
    {'id': 'strength', 'title': 'Build Strength', 'icon': Icons.fitness_center, 'color': AppColors.summerOrange},
    {'id': 'cardio', 'title': 'Improve Cardio', 'icon': Icons.favorite, 'color': AppColors.oceanBlue},
    {'id': 'weight_loss', 'title': 'Lose Weight', 'icon': Icons.monitor_weight, 'color': AppColors.success},
    {'id': 'general', 'title': 'General Fitness', 'icon': Icons.sports_gymnastics, 'color': AppColors.sunshineYellow},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text(
                'Let\'s get to know you',
                style: AppTextStyles.displayHero,
              ),
              const SizedBox(height: 8),
              Text(
                'This helps us personalize your first workout',
                style: AppTextStyles.bodySecondary.copyWith(fontSize: 15),
              ),
              const SizedBox(height: 32),
              _buildForm(),
              const SizedBox(height: 24),
              Text(
                'What\'s your primary goal?',
                style: AppTextStyles.headline,
              ),
              const SizedBox(height: 16),
              _buildGoalGrid(),
              const SizedBox(height: 32),
              _buildContinueButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      children: [
        TextField(
          controller: _nameController,
          style: AppTextStyles.bodyPrimary,
          decoration: InputDecoration(
            labelText: 'Your name',
            labelStyle: AppTextStyles.inputHint,
            prefixIcon: const Icon(Icons.person_outline, color: AppColors.summerOrange),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _emailController,
          style: AppTextStyles.bodyPrimary,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Email',
            labelStyle: AppTextStyles.inputHint,
            prefixIcon: const Icon(Icons.email_outlined, color: AppColors.summerOrange),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildGoalGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.1,
      ),
      itemCount: _goals.length,
      itemBuilder: (context, index) {
        final goal = _goals[index];
        final isSelected = _selectedGoal == goal['id'];
        return _GoalCard(
          icon: goal['icon'],
          title: goal['title'],
          color: goal['color'],
          isSelected: isSelected,
          onTap: () => setState(() => _selectedGoal = goal['id']),
        );
      },
    );
  }

  Widget _buildContinueButton() {
    final hasName = _nameController.text.trim().isNotEmpty;
    final hasGoal = _selectedGoal != null;
    final isEnabled = hasName && hasGoal;

    return LimeButton(
      label: 'Continue',
      onPressed: isEnabled && !_isLoading
          ? _handleContinue
          : null,
      icon: Icons.arrow_forward,
      fullWidth: true,
      opacity: isEnabled ? 1.0 : 0.5,
    );
  }

  void _handleContinue() async {
    setState(() => _isLoading = true);

    // Simulate quick setup - in production this would create user + first workout
    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;
    context.go('/home');
  }
}

class _GoalCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _GoalCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.15) : AppColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : AppColors.borderDefault,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 36,
              color: isSelected ? color : AppColors.textMuted,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: AppTextStyles.cardTitle.copyWith(
                color: isSelected ? AppColors.textPrimary : AppColors.textMuted,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
