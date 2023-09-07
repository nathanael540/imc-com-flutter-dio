import 'package:imc_flutter/src/classes/imc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImcService {
  SharedPreferences? _prefs;

  Future<void> _checkOrInitPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<bool> saveIMC(IMC imc) async {
    await _checkOrInitPrefs();

    final keys = _prefs!.getKeys();

    try {
      await _prefs!.setString('imc${keys.length}', imc.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<IMC>> getIMCs() async {
    await _checkOrInitPrefs();

    final imcs = <IMC>[];

    final keys = _prefs!.getKeys().toList()..sort();

    for (final key in keys) {
      final imcString = _prefs!.getString(key);
      if (imcString != null) {
        imcs.add(
          IMC.fromJson(imcString),
        );
      }
    }

    await Future.delayed(const Duration(seconds: 2));

    return imcs;
  }

  Future<bool> clearIMCs() async {
    await _checkOrInitPrefs();

    try {
      await _prefs!.clear();
      return true;
    } catch (e) {
      return false;
    }
  }
}
