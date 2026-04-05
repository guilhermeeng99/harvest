import 'package:equatable/equatable.dart';

sealed class StartupState extends Equatable {
  const StartupState();

  @override
  List<Object?> get props => [];
}

class StartupInitial extends StartupState {
  const StartupInitial();
}

class StartupLoading extends StartupState {
  const StartupLoading({required this.step, required this.progress});

  final String step;
  final double progress;

  @override
  List<Object?> get props => [step, progress];
}

class StartupComplete extends StartupState {
  const StartupComplete();
}

class StartupUnauthenticated extends StartupState {
  const StartupUnauthenticated();
}

class StartupError extends StartupState {
  const StartupError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
