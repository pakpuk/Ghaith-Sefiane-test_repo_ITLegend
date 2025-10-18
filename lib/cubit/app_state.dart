import 'package:equatable/equatable.dart';

/// AppState - Represents the global application state
abstract class AppState extends Equatable {
  const AppState();

  @override
  List<Object?> get props => [];
}

/// Initial state when app starts
class AppInitial extends AppState {
  const AppInitial();
}

/// Loading state during initialization
class AppLoading extends AppState {
  const AppLoading();
}

/// Ready state when app is fully initialized
class AppReady extends AppState {
  const AppReady();
}

/// Error state when initialization fails
class AppError extends AppState {
  final String message;

  const AppError(this.message);

  @override
  List<Object> get props => [message];
}
