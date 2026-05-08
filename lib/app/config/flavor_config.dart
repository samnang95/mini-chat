enum Flavor { dev, staging, prod }

class FlavorConfig {
  final Flavor flavor;
  final String envFileName;

  const FlavorConfig._({
    required this.flavor,
    required this.envFileName,
  });

  static const dev = FlavorConfig._(
    flavor: Flavor.dev,
    envFileName: '.env.dev',
  );

  static const staging = FlavorConfig._(
    flavor: Flavor.staging,
    envFileName: '.env.staging',
  );

  static const prod = FlavorConfig._(
    flavor: Flavor.prod,
    envFileName: '.env.prod',
  );

  bool get isDev => flavor == Flavor.dev;
  bool get isStaging => flavor == Flavor.staging;
  bool get isProd => flavor == Flavor.prod;
}
