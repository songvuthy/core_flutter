enum Flavor {
  dev,
  uat,
  prod,
}

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.dev:
        return 'App Dev';
      case Flavor.uat:
        return 'App UAT';
      case Flavor.prod:
        return 'App Prod';
      default:
        return 'title';
    }
  }

}
