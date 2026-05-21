abstract class AppConfig {
  static late AppConfig instance;

  abstract String baseUrl;
  abstract Environment environment;
}

enum Environment {
  dev,
  staging,
  prod;

  factory Environment.fromString(String value) {
    return switch (value) {
      'staging' => Environment.staging,
      'prod' => Environment.prod,
      _ => Environment.dev,
    };
  }
}
