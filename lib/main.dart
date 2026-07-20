import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/persistence/persistence_service.dart';

import 'package:flutter_application_1/app/app.dart';
export 'package:flutter_application_1/app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PersistenceService.init();
  runApp(const ProviderScope(child: LifeOsApp()));
}
