import 'package:appwrite/appwrite.dart';
import '../core/constants.dart';
import '../core/app_logger.dart';

class AppwriteService {
  // NOTE: For Flutter/mobile, Appwrite uses cookie-based sessions by default.
  // Do NOT set JWT on the client, otherwise Appwrite rejects requests
  // with "JWT and cookie used in the same request".
  static Client client = _newClient();

  static Account get account => Account(client);
  static Databases get db => Databases(client);

  static Client _newClient() {
    return Client()
      ..setEndpoint(AppwriteConfig.endpoint)
      ..setProject(AppwriteConfig.projectId);
  }

  /// Recreate client to clear any previously set headers (e.g. JWT).
  static void reset() {
    client = _newClient();
    AppLogger.i('AppwriteService: client reset');
  }
}

class DatabaseService {
  static Databases get _db => AppwriteService.db;

  static bool get _dbConfigured => AppwriteConfig.databaseId != 'YOUR_DATABASE_ID';

  // Users (profile)
  static Future<void> upsertUserProfile({
    required String userId,
    required String name,
    required String email,
  }) async {
    if (!_dbConfigured) {
      AppLogger.e('DatabaseService.upsertUserProfile skipped (databaseId not set)');
      return;
    }

    final data = <String, dynamic>{
      'userId': userId,
      'name': name,
      'email': email,
      'createdAt': DateTime.now().toIso8601String(),
      'phone': '',
    };

    try {
      AppLogger.i('DatabaseService.upsertUserProfile: db=${AppwriteConfig.databaseId} col=${AppwriteConfig.colUsers} userId=$userId');
      await _db.createDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.colUsers,
        documentId: userId,
        data: data,
      );
      AppLogger.i('DatabaseService.upsertUserProfile created user doc=$userId');
    } on AppwriteException catch (e) {
      AppLogger.e('DatabaseService.upsertUserProfile AppwriteException: code=${e.code} message=${e.message}');
      // 409 = document already exists → update it
      if (e.code == 409) {
        await _db.updateDocument(
          databaseId: AppwriteConfig.databaseId,
          collectionId: AppwriteConfig.colUsers,
          documentId: userId,
          data: data,
        );
        AppLogger.i('DatabaseService.upsertUserProfile updated user doc=$userId');
        return;
      }
      rethrow;
    } catch (e, st) {
      AppLogger.e('DatabaseService.upsertUserProfile unexpected error: $e\n$st');
      rethrow;
    }
  }

  // Plans
  static Future<List<Map<String, dynamic>>> getPlans(String userId) async {
    final res = await _db.listDocuments(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.colPlans,
      queries: [Query.equal('userId', userId)],
    );
    return res.documents
        .map((d) => <String, dynamic>{...d.data, '\$id': d.$id})
        .toList();
  }

  static Future<Map<String, dynamic>> createPlan(Map<String, dynamic> data) async {
    final doc = await _db.createDocument(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.colPlans,
      documentId: ID.unique(),
      data: data,
    );
    return <String, dynamic>{...doc.data, '\$id': doc.$id};
  }

  static Future<void> deletePlan(String planId) async {
    await _db.deleteDocument(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.colPlans,
      documentId: planId,
    );
  }

  // Logs
  static Future<List<Map<String, dynamic>>> getLogs(String userId) async {
    final res = await _db.listDocuments(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.colLogs,
      queries: [
        Query.equal('userId', userId),
        Query.orderDesc('\$createdAt'),
      ],
    );
    return res.documents
        .map((d) => <String, dynamic>{...d.data, '\$id': d.$id})
        .toList();
  }

  static Future<Map<String, dynamic>> createLog(Map<String, dynamic> data) async {
    final doc = await _db.createDocument(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.colLogs,
      documentId: ID.unique(),
      data: data,
    );
    return <String, dynamic>{...doc.data, '\$id': doc.$id};
  }

  // Custom Exercises
  static Future<List<Map<String, dynamic>>> getCustomExercises(String userId) async {
    final res = await _db.listDocuments(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.colExercises,
      queries: [Query.equal('userId', userId)],
    );
    return res.documents
        .map((d) => <String, dynamic>{...d.data, '\$id': d.$id})
        .toList();
  }

  static Future<Map<String, dynamic>> createCustomExercise(Map<String, dynamic> data) async {
    final doc = await _db.createDocument(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.colExercises,
      documentId: ID.unique(),
      data: data,
    );
    return <String, dynamic>{...doc.data, '\$id': doc.$id};
  }

  static Future<void> deleteCustomExercise(String exerciseId) async {
    await _db.deleteDocument(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.colExercises,
      documentId: exerciseId,
    );
  }
}
