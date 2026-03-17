import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import '../core/app_colors.dart';
import '../core/app_text_styles.dart';

void showToast(BuildContext context, String message, {bool isError = false}) {
  final messenger = ScaffoldMessenger.of(context);
  messenger.clearSnackBars();
  messenger.showSnackBar(
    SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      margin: const EdgeInsets.all(16),
      duration: const Duration(milliseconds: 2500),
      content: AwesomeSnackbarContent(
        title: isError ? 'Error' : 'Success',
        message: message,
        contentType: isError ? ContentType.failure : ContentType.success,
        titleTextStyle: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
        messageTextStyle: AppTextStyles.body,
        color: isError ? AppColors.coral : AppColors.lime,
      ),
    ),
  );
}
