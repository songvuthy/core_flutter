import 'package:core_flutter/flavors.dart';

class AppConfig {
  final String baseUrlApi;
  final String baseUrlMedia;

  AppConfig({
    required this.baseUrlApi,
    required this.baseUrlMedia,
  });
}

class AppConfigOption {
  static AppConfig get appConfig {
    // Detect flavor from environment
    Flavor flavor = F.appFlavor ?? Flavor.dev;
    switch (flavor) {
      case Flavor.dev:
        return AppConfig(
          baseUrlApi: "http://136.228.129.2:90/api/v1/client/",
          baseUrlMedia: "http://136.228.129.2:90/",
        );
      case Flavor.uat:
        return AppConfig(
          baseUrlApi: "http://136.228.129.2:90/api/v1/client/",
          baseUrlMedia: "http://136.228.129.2:90/",
        );
      case Flavor.prod:
        return AppConfig(
          baseUrlApi: "http://136.228.129.2:90/api/v1/client/",
          baseUrlMedia: "http://136.228.129.2:90/",
        );
    }
  }
}
