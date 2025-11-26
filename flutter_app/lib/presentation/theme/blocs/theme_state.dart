import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../domain/entities/client_entity.dart';

abstract class ThemeState extends Equatable {
  const ThemeState();

  @override
  List<Object?> get props => [];
}

class ThemeInitial extends ThemeState {}

class ThemeLoading extends ThemeState {}

class ThemeLoaded extends ThemeState {
  final ClientEntity client;
  final ThemeData themeData;

  const ThemeLoaded({
    required this.client,
    required this.themeData,
  });

  @override
  List<Object?> get props => [client, themeData];
}

class ThemeError extends ThemeState {
  final String message;

  const ThemeError({required this.message});

  @override
  List<Object?> get props => [message];
}
