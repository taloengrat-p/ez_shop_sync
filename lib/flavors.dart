enum Flavor {
  dev,
  prod,
  tests;

  static const String DEV = 'dev';
  static const String PROD = 'prod';
  static const String TESTS = 'tests';
}

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.dev:
        return 'Ez Shop Sync -DEV';
      case Flavor.prod:
        return 'Ez Shop Sync';
      default:
        return 'title';
    }
  }
}
