import 'package:core_flutter/flavors.dart';

class AppConfig {
  final String hostUrl;
  final String baseUrlApi;
  final String baseUrlMedia;

  AppConfig(
      {required this.hostUrl,
      required this.baseUrlApi,
      required this.baseUrlMedia});
}

class AppConfigOption {
  static AppConfig get appConfig {
    // Detect flavor from environment
    Flavor flavor = F.appFlavor ?? Flavor.dev;
    switch (flavor) {
      case Flavor.dev:
        return AppConfig(
          hostUrl: "https://shop-dev-e-commerce.igtech.asia/",
          baseUrlApi: "https://api-dev-e-commerce.igtech.asia/client/",
          baseUrlMedia:
              "https://dsi-ecommerce-dev.obs.ap-southeast-3.myhuaweicloud.com/",
        );
      case Flavor.uat:
        return AppConfig(
          hostUrl: "https://shop-dev-e-commerce.igtech.asia/",
          baseUrlApi: "https://api-dev-e-commerce.igtech.asia/client/",
          baseUrlMedia:
              "https://dsi-ecommerce-dev.obs.ap-southeast-3.myhuaweicloud.com/",
        );
      case Flavor.prod:
        return AppConfig(
          hostUrl: "https://shop-dev-e-commerce.igtech.asia/",
          baseUrlApi: "https://api-dev-e-commerce.igtech.asia/client/",
          baseUrlMedia:
              "https://dsi-ecommerce-dev.obs.ap-southeast-3.myhuaweicloud.com/",
        );
    }
  }
}
