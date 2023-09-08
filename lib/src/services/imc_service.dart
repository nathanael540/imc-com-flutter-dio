import 'package:hive_flutter/hive_flutter.dart';
import 'package:imc_flutter/src/classes/imc.dart';
import 'package:imc_flutter/src/classes/imc_hive_adapter.dart';

class ImcService {
  Box<IMC>? _box;

  static final ImcService instance = ImcService._();

  ImcService._();

  Future<void> startService() async {
    await Hive.initFlutter();

    Hive.registerAdapter(IMCHiveAdapter());

    _box = await Hive.openBox<IMC>('imcs');
  }

  Future<void> saveIMC(IMC imc) async {
    await _box?.add(imc);
  }

  Future<List<IMC>> getIMCs() async {
    return _box?.values.toList() ?? [];
  }
}
