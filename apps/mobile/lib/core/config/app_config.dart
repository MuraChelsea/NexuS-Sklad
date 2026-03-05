class AppConfig {
  const AppConfig({
    required this.apiBaseUrl,
    required this.appName,
  });

  final String apiBaseUrl;
  final String appName;

  factory AppConfig.fromEnvironment() {
    return const AppConfig(
      apiBaseUrl: String.fromEnvironment(
        'NEXUSSKLAD_API_BASE_URL',
        defaultValue: 'http://localhost:4000',
      ),
      appName: 'NexusSklad',
    );
  }
}
