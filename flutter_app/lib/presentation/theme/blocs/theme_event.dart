import 'package:equatable/equatable.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object?> get props => [];
}

class LoadClientTheme extends ThemeEvent {
  final String domain;

  const LoadClientTheme({required this.domain});

  @override
  List<Object?> get props => [domain];
}

class ResetTheme extends ThemeEvent {}
