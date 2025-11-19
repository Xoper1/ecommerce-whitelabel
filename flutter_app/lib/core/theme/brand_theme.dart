import 'package:flutter/material.dart';

/// Mapeia domínios de clientes para cores primárias e definições de tema
class BrandTheme {
  static const Map<String, Color> _domainColors = {
    'devnology.com': Color(0xFF2E7D32), // Verde
    'in8.com': Color(0xFF6A1B9A), // Roxo
    'localhost': Color(0xFF7B1FA2), // Roxo padrão para dev
    'cliente1.local': Color(0xFF7B1FA2), // Roxo padrão para testes
  };

  /// Obtém a cor primária baseada no domínio
  static Color getPrimaryColorByDomain(String domain) {
    // Remove protocolo se existir
    String cleanDomain = domain
        .replaceAll('http://', '')
        .replaceAll('https://', '')
        .split(':')[0] // Remove porta
        .toLowerCase();

    // Procura correspondência exata ou por domínio base (sem subdomínios)
    if (_domainColors.containsKey(cleanDomain)) {
      return _domainColors[cleanDomain]!;
    }

    // Tenta correspondência com domínio base (ex: example.com em sub.example.com)
    for (final entry in _domainColors.entries) {
      if (cleanDomain.endsWith(entry.key)) {
        return entry.value;
      }
    }

    // Retorna cor padrão (roxo deep purple)
    return const Color(0xFF7B1FA2);
  }

  /// Cria um ThemeData baseado na cor primária
  static ThemeData createTheme(Color primaryColor) {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
      useMaterial3: true,
      primaryColor: primaryColor,
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: BorderSide(color: primaryColor),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  /// Retorna nome do cliente baseado no domínio (para fins informativos)
  static String getClientNameByDomain(String domain) {
    String cleanDomain = domain
        .replaceAll('http://', '')
        .replaceAll('https://', '')
        .split(':')[0]
        .toLowerCase();

    const Map<String, String> clientNames = {
      'devnology.com': 'Devnology',
      'in8.com': 'IN8',
      'localhost': 'Development',
      'cliente1.local': 'Cliente 1',
    };

    return clientNames[cleanDomain] ?? 'Client';
  }
}
