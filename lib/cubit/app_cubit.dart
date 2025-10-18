import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:marketplace_app/cubit/app_state.dart';
import 'package:marketplace_app/db/database.dart';

/// AppCubit - Manages global application state
/// Handles database initialization and app-level configuration
class AppCubit extends Cubit<AppState> {
  final DatabaseHelper _dbHelper;

  AppCubit(this._dbHelper) : super(const AppInitial());

  /// Initialize the application
  /// - Ensures database is ready
  /// - Loads initial configuration
  Future<void> initialize() async {
    try {
      emit(const AppLoading());

      debugPrint('🚀 [AppCubit] Initializing application...');

      // ✅ Initialize database (ensures tables exist and seed data is loaded)
      await _dbHelper.database;

      debugPrint('✅ [AppCubit] Database initialized successfully');

      // ✅ App is ready
      emit(const AppReady());

      debugPrint('✅ [AppCubit] Application ready');
    } catch (e, stackTrace) {
      debugPrint('❌ [AppCubit] Initialization failed: $e');
      debugPrint('Stack trace: $stackTrace');
      emit(AppError('فشل تهيئة التطبيق: $e'));
    }
  }

  /// Reset application state (for testing or debugging)
  Future<void> reset() async {
    try {
      emit(const AppLoading());
      debugPrint('🔄 [AppCubit] Resetting application...');

      // Note: resetDatabase() is available but should be used carefully
      // Uncomment only if you need to reset data during development
      // await _dbHelper.resetDatabase();

      await initialize();
    } catch (e) {
      debugPrint('❌ [AppCubit] Reset failed: $e');
      emit(AppError('فشل إعادة تعيين التطبيق: $e'));
    }
  }
}
