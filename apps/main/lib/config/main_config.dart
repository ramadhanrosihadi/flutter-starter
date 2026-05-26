import 'package:core/core.dart';

class MainConfig extends AppConfig {
  @override
  Environment get environment => Environment.fromString(
        const String.fromEnvironment('ENV', defaultValue: 'dev'),
      );

  @override
  String get baseUrl => switch (environment) {
        Environment.dev => 'http://127.0.0.1:8000/api',
        Environment.staging => 'https://ramadhanrosihadi.web.id/api',
        Environment.prod => 'https://ramadhanrosihadi.web.id/api',
      };
}
