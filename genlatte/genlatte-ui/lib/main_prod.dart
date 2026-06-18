import 'package:genlatte/src/bootstrap.dart';
import 'package:genlatte/src/core/core.dart';

/// Entrypoint for the production environment.
Future<void> main() async => bootstrap(appEnv: AppEnv.prod);
