import 'package:flutter/material.dart';
import '../core/app_colors.dart';

enum ButtonSize { normal, small }

class LimeButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final ButtonSize size;
  final bool isLoading;

  const LimeButton({
    super.key,
    required this.label,
    this.onPressed,
    this.size = ButtonSize.normal,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final padding = size == ButtonSize.normal
        ? const EdgeInsets.symmetric(horizontal: 20, vertical: 10)
        : const EdgeInsets.symmetric(horizontal: 14, vertical: 6);
    final fontSize = size == ButtonSize.normal ? 14.0 : 12.0;
    final height = size == ButtonSize.normal ? 44.0 : 32.0;

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.lime,
        foregroundColor: AppColors.appBg,
        padding: padding,
        minimumSize: Size(size == ButtonSize.normal ? double.infinity : 0, height),
        elevation: 0,
        shadowColor: AppColors.neumoShadow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
      child: isLoading
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.appBg,
              ),
            )
          : Text(label),
    );
  }
}
