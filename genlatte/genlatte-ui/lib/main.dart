/// Convenience entrypoint to allow `$flutter run` to work during development.
/// During deployment, prefer one of the explicit entrypoints.
library;

import 'package:genlatte/src/bootstrap.dart';
import 'package:genlatte/src/core/core.dart';

Future<void> main() async => bootstrap(appEnv: AppEnv.current);
