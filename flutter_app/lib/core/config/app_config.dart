class AppConfig {
  // Configure based on environment
  static const String baseUrl = 'http://localhost:3000';

  // Client domain - can be changed dynamically
  static String clientDomain = 'cliente1.local';

  // Storage keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String clientConfigKey = 'client_config';

  // Method to detect domain from URL (for web)
  static String getCurrentDomain() {
    // In a web environment, you could use:
    // return Uri.base.host;
    // For now, return the configured domain
    return clientDomain;
  }

  // Method to set domain dynamically
  static void setClientDomain(String domain) {
    clientDomain = domain;
  }

  // Domain mappings for testing
  static const Map<String, String> domainMappings = {
    'devnology.com:8000': 'cliente1.local',
    'in8.com:8000': 'cliente2.local',
    'localhost:8080': 'cliente1.local',
  };

  // Get domain from current URL
  static String getDomainFromUrl(String url) {
    final uri = Uri.parse(url);
    final hostWithPort = '${uri.host}:${uri.port}';
    return domainMappings[hostWithPort] ?? clientDomain;
  }
}
