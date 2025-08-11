import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
final class Env {
  @EnviedField(varName: 'QUOTES_KEY', obfuscate: true)
  static final String quotesKey = _Env.quotesKey;
}
