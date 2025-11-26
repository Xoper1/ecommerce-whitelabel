import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/client_entity.dart';
import '../../../domain/usecases/get_client_config_usecase.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final GetClientConfigUseCase _getClientConfigUseCase;

  ThemeBloc({
    required GetClientConfigUseCase getClientConfigUseCase,
  })  : _getClientConfigUseCase = getClientConfigUseCase,
        super(ThemeInitial()) {
    on<LoadClientTheme>(_onLoadClientTheme);
    on<ResetTheme>(_onResetTheme);
  }

  Future<void> _onLoadClientTheme(
    LoadClientTheme event,
    Emitter<ThemeState> emit,
  ) async {
    emit(ThemeLoading());

    try {
      final client = await _getClientConfigUseCase();
      final themeData = _buildThemeFromClient(client);
      emit(ThemeLoaded(client: client, themeData: themeData));
    } catch (e) {
      emit(ThemeError(message: e.toString()));
      // Fallback to default theme on error
      final defaultTheme = _buildDefaultTheme();
      emit(ThemeLoaded(
        client: const _DefaultClient(),
        themeData: defaultTheme,
      ));
    }
  }

  Future<void> _onResetTheme(
    ResetTheme event,
    Emitter<ThemeState> emit,
  ) async {
    final defaultTheme = _buildDefaultTheme();
    emit(ThemeLoaded(
      client: const _DefaultClient(),
      themeData: defaultTheme,
    ));
  }

  ThemeData _buildThemeFromClient(client) {
    Color primaryColor;

    // Parse color from client configuration
    if (client.primaryColor != null && client.primaryColor!.isNotEmpty) {
      try {
        final colorString = client.primaryColor!.replaceAll('#', '');
        primaryColor = Color(int.parse('0xFF$colorString'));
      } catch (e) {
        primaryColor = Colors.deepPurple; // fallback
      }
    } else {
      primaryColor = Colors.deepPurple; // fallback
    }

    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
      ),
      useMaterial3: true,
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
      ),
    );
  }

  ThemeData _buildDefaultTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    );
  }
}

// Default client for fallback
class _DefaultClient extends ClientEntity {
  const _DefaultClient()
      : super(
          id: 0,
          name: 'Default',
          logoUrl: null,
          primaryColor: '#673AB7',
        );
}
