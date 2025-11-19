import 'dart:html' as html;

/// Detecta automaticamente o domínio atual quando executado em navegador
class DomainDetector {
  /// Obtém o domínio atual da URL no navegador
  static String getCurrentDomain() {
    try {
      // Para web (Flutter web executa em navegador)
      final host = html.window.location.host; // ex: "devnology.com:8000"
      return host;
    } catch (e) {
      // Fallback para testes/desenvolvimento
      return 'localhost';
    }
  }

  /// Obtém protocolo atual (http ou https)
  static String getCurrentProtocol() {
    try {
      return html.window.location.protocol.replaceAll(':', '');
    } catch (e) {
      return 'http';
    }
  }

  /// Obtém a URL completa da API (baseUrl)
  static String getApiBaseUrl() {
    final protocol = getCurrentProtocol();
    final host = getCurrentDomain();
    // A API deve estar no mesmo host, mas em uma porta ou path diferente
    // Ajuste conforme necessário (ex: :3000, /api)
    return '$protocol://$host';
  }
}
