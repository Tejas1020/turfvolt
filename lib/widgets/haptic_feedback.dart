import 'package:flutter/services.dart';
import '../core/app_colors.dart';

/// Haptic feedback wrapper for consistent tactile responses
/// Patterns based on iOS Human Interface Guidelines
class Haptic {
  /// Light impact - button taps, set logging, small interactions
  static Future<void> lightImpact() async {
    await SystemChannels.platform.invokeMethod('HapticFeedback.vibrate', 'HapticFeedbackType.light');
  }

  /// Medium impact - card taps, selection changes
  static Future<void> mediumImpact() async {
    await SystemChannels.platform.invokeMethod('HapticFeedback.vibrate', 'HapticFeedbackType.medium');
  }

  /// Heavy impact - major actions, deletions
  static Future<void> heavyImpact() async {
    await SystemChannels.platform.invokeMethod('HapticFeedback.vibrate', 'HapticFeedbackType.heavy');
  }

  /// Success - workout complete, PR achieved, milestone hit
  static Future<void> success() async {
    await SystemChannels.platform.invokeMethod('HapticFeedback.vibrate', 'HapticFeedbackType.success');
  }

  /// Warning - validation errors, form issues
  static Future<void> warning() async {
    await SystemChannels.platform.invokeMethod('HapticFeedback.vibrate', 'HapticFeedbackType.warning');
  }

  /// Error - critical failures, network errors
  static Future<void> error() async {
    await SystemChannels.platform.invokeMethod('HapticFeedback.vibrate', 'HapticFeedbackType.error');
  }

  /// Selection tick - picker scrolling, stepper changes
  static Future<void> selection() async {
    await SystemChannels.platform.invokeMethod('HapticFeedback.vibrate', 'HapticFeedbackType.selection');
  }

  /// Celebration pattern - confetti trigger, achievement unlock
  static Future<void> celebration() async {
    // Triple light tap pattern for celebration
    await lightImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await lightImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await lightImpact();
    await Future.delayed(const Duration(milliseconds: 200));
    await success();
  }
}
