import 'package:envied/envied.dart';
part 'env.g.dart';

@Envied(path: '.env', obfuscate: true) // Specify the path to your .env file
abstract class Env {
  @EnviedField(varName: 'API_KEY')
  static final String apiKey =
      _Env.apiKey; // Use obfuscate: true for extra security (optional)
}
