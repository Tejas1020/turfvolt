import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_text_styles.dart';
import '../../../core/constants.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/exercise_provider.dart';
import '../../../widgets/app_toast.dart';
import '../../../widgets/exercise_row.dart';
import '../../../widgets/lime_button.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  String selectedMuscle = 'All';
  String searchQuery = '';
  bool showAddForm = false;

  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String _formMuscle = muscleGroups.first;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveCustomExercise() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      showToast(context, 'Exercise name is required', isError: true);
      return;
    }
    final auth = context.read<AuthProvider>();
    final user = auth.user;
    if (user == null) {
      showToast(context, 'Please log in again', isError: true);
      return;
    }
    try {
      await context.read<ExerciseProvider>().addCustomExercise(
            userId: user.$id,
            name: name,
            muscle: _formMuscle,
            description: _descCtrl.text.trim(),
          );
      if (!mounted) return;
      setState(() {
        showAddForm = false;
        _nameCtrl.clear();
        _descCtrl.clear();
        _formMuscle = muscleGroups.first;
      });
      showToast(context, 'Exercise saved');
    } catch (e) {
      if (!mounted) return;
      showToast(context, e.toString(), isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final exP = context.watch<ExerciseProvider>();
    final all = exP.exercises;

    final filtered = all.where((e) {
      final matchesSearch = searchQuery.trim().isEmpty ||
          e.name.toLowerCase().contains(searchQuery.toLowerCase().trim());
      final matchesMuscle = selectedMuscle == 'All' || e.muscle == selectedMuscle;
      return matchesSearch && matchesMuscle;
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('EXERCISE LIBRARY', style: AppTextStyles.screenTitle),
              LimeButton(
                label: '+ Add Custom',
                size: ButtonSize.small,
                onPressed: () => setState(() => showAddForm = !showAddForm),
              ),
            ],
          ),
          if (showAddForm) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: AppColors.neumoBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.neumoHighlight, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.neumoHighlight.withOpacity(0.2),
                    offset: const Offset(-2, -2),
                    blurRadius: 4,
                  ),
                  BoxShadow(
                    color: AppColors.neumoShadow.withOpacity(0.35),
                    offset: const Offset(2, 2),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'New custom exercise',
                    style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(hintText: 'Exercise name'),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: _formMuscle,
                    dropdownColor: AppColors.cardBg,
                    style: AppTextStyles.body,
                    decoration: const InputDecoration(),
                    items: muscleGroups
                        .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                        .toList(),
                    onChanged: (v) => setState(() => _formMuscle = v ?? muscleGroups.first),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _descCtrl,
                    decoration: const InputDecoration(hintText: 'Short description'),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveCustomExercise,
                      child: const Text('Save Exercise'),
                    ),
                  ),
                ],
              ),
            ),
          ] else
            const SizedBox(height: 14),
          TextField(
            onChanged: (v) => setState(() => searchQuery = v),
            decoration: const InputDecoration(
              hintText: 'Search exercises...',
              prefixIcon: Icon(Icons.search, color: AppColors.textDim, size: 18),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 38,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 1 + muscleGroups.length,
              itemBuilder: (context, i) {
                final m = i == 0 ? 'All' : muscleGroups[i - 1];
                final isSelected = selectedMuscle == m;
                return GestureDetector(
                  onTap: () => setState(() => selectedMuscle = m),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.lime : AppColors.cardBg,
                      borderRadius: BorderRadius.circular(99),
                      border: isSelected
                          ? null
                          : Border.all(color: AppColors.borderDefault, width: 0.5),
                    ),
                    child: Text(
                      m,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isSelected ? AppColors.appBg : AppColors.textMuted,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 14),
          if (exP.loading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(color: AppColors.lime, strokeWidth: 2),
              ),
            )
          else if (filtered.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text('No exercises found.', style: AppTextStyles.secondary),
            )
          else
            ...filtered.map(
              (e) => ExerciseRow(
                name: e.name,
                muscle: e.muscle,
                desc: e.desc,
                icon: e.icon,
                isCustom: e.isCustom,
              ),
            ),
        ],
      ),
    );
  }
}

