import 'package:flutter/material.dart';
import 'package:imc_flutter/src/app.dart';
import 'package:imc_flutter/src/services/config_service.dart';
import 'package:imc_flutter/src/services/imc_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Singleton de Nome e Altura
  await ConfigService.instance.startService();

  // Singleton de Lista de IMCs salvos
  await ImcService.instance.startService();

  runApp(const AppCore());
}
