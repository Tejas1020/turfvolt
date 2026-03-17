import 'package:appwrite/models.dart' as models;
import 'package:appwrite/appwrite.dart' show ID;
import 'package:appwrite/appwrite.dart' show AppwriteException;
import '../core/app_logger.dart';
import 'appwrite_service.dart';

class AuthService {
  static const _timeout = Duration(seconds: 12);

  static String _friendlyError(Object e) {
    if (e is AppwriteException) {
      final m = (e.message ?? '').trim();
      if (m.isNotEmpty) return m;
      return 'Request failed. Please try again.';
    }
    final s = e.toString();
    if (s.contains('SocketException')) return 'No internet connection.';
    if (s.contains('TimeoutException')) return 'Request timed out. Please try again.';
    return s;
  }

  static Future<models.User?> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      AppLogger.i('AuthService.register()');
      final user = await AppwriteService.account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: name,
      ).timeout(_timeout);
      AppLogger.i('AuthService.register() created user=${user.$id}');
      // Create cookie session first, then write user profile into DB.
      await login(email: email, password: password);
      try {
        await DatabaseService.upsertUserProfile(
          userId: user.$id,
          name: name,
          email: email,
        ).timeout(_timeout);
      } catch (e) {
        // Don't block signup if profile write fails; log it.
        AppLogger.e('AuthService.register() user profile upsert failed', e);
      }
      return user;
    } catch (e) {
      AppLogger.e('AuthService.register() failed', e);
      throw Exception(_friendlyError(e));
    }
  }

  static Future<models.User?> login({
    required String email,
    required String password,
  }) async {
    try {
      AppLogger.i('AuthService.login()');
      // Ensure we are NOT sending any JWT header.
      AppwriteService.reset();
      await AppwriteService.account.createEmailPasswordSession(
        email: email,
        password: password,
      ).timeout(_timeout);

      final user = await AppwriteService.account.get().timeout(_timeout);
      AppLogger.i('AuthService.login() session ok user=${user.$id}');
      return user;
    } catch (e) {
      AppLogger.e('AuthService.login() failed', e);
      throw Exception(_friendlyError(e));
    }
  }

  static Future<void> logout() async {
    try {
      AppLogger.i('AuthService.logout()');
      await AppwriteService.account.deleteSession(sessionId: 'current').timeout(_timeout);
      AppwriteService.reset();
    } catch (e) {
      // Ignore errors on logout
      AppLogger.e('AuthService.logout() failed (ignored)', e);
      AppwriteService.reset();
    }
  }

  static Future<models.User?> getCurrentUser() async {
    try {
      AppLogger.i('AuthService.getCurrentUser()');
      return await AppwriteService.account.get().timeout(_timeout);
    } catch (e) {
      AppLogger.i('AuthService.getCurrentUser() no session');
      return null;
    }
  }

  static Future<bool> hasSession() async {
    try {
      await AppwriteService.account.get().timeout(_timeout);
      return true;
    } catch (_) {
      return false;
    }
  }
}
