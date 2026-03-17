import 'package:flutter/foundation.dart';
import 'package:appwrite/models.dart' as models;
import '../core/app_logger.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  models.User? _user;
  bool _loading = true;

  models.User? get user => _user;
  bool get isLoggedIn => _user != null;
  bool get loading => _loading;
  String get userInitial => _user?.name.isNotEmpty == true
      ? _user!.name[0].toUpperCase() : 'U';

  Future<void> init() async {
    AppLogger.i('AuthProvider.init()');
    _user = await AuthService.getCurrentUser();
    _loading = false;
    AppLogger.i('AuthProvider.init() user=${_user?.$id ?? 'null'}');
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    AppLogger.i('AuthProvider.login(email=$email)');
    await AuthService.login(email: email, password: password);
    _user = await AuthService.getCurrentUser();
    AppLogger.i('AuthProvider.login() user=${_user?.$id ?? 'null'}');
    notifyListeners();
  }

  Future<void> register(String name, String email, String password) async {
    AppLogger.i('AuthProvider.register(email=$email)');
    await AuthService.register(name: name, email: email, password: password);
    _user = await AuthService.getCurrentUser();
    AppLogger.i('AuthProvider.register() user=${_user?.$id ?? 'null'}');
    notifyListeners();
  }

  Future<void> logout() async {
    AppLogger.i('AuthProvider.logout()');
    await AuthService.logout();
    _user = null;
    notifyListeners();
  }
}
