import 'package:flutter/material.dart';
import '../config/app_config.dart';
import 'brand_theme.dart';

/// Provider para gerenciar o tema dinâmico baseado no domínio do cliente
class ThemeProvider extends ChangeNotifier {
  late String _currentDomain;
  late Color _primaryColor;
  late ThemeData _themeData;

  ThemeProvider({String? initialDomain}) {
    _currentDomain = initialDomain ?? AppConfig.clientDomain;
    _updateTheme();
  }

  String get currentDomain => _currentDomain;
  Color get primaryColor => _primaryColor;
  ThemeData get themeData => _themeData;
  String get clientName => BrandTheme.getClientNameByDomain(_currentDomain);

  /// Atualiza o domínio e recalcula o tema
  void updateDomain(String newDomain) {
    if (_currentDomain != newDomain) {
      _currentDomain = newDomain;
      _updateTheme();
      notifyListeners();
    }
  }

  /// Recalcula a cor primária e tema baseado no domínio atual
  void _updateTheme() {
    _primaryColor = BrandTheme.getPrimaryColorByDomain(_currentDomain);
    _themeData = BrandTheme.createTheme(_primaryColor);
  }
}
