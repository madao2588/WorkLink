import 'package:flutter/material.dart';

import 'app/app.dart';
import 'app/shared/storage/auth_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final LocalAuthStorage authStorage = LocalAuthStorage();
  await authStorage.initialize();

  runApp(WorkLinkBootstrap(authStorage: authStorage));
}
