import 'package:imc_flutter/src/classes/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigService {
  SharedPreferences? _prefs;
  ConfigInfo? _config;

  static final ConfigService instance = ConfigService._();

  ConfigService._();

  ConfigInfo? get config => _config;

  Future<void> startService() async {
    _prefs ??= await SharedPreferences.getInstance();

    await getConfig();
  }

  Future<bool> setConfig(ConfigInfo config) async {
    try {
      await _prefs!.setString('config', config.toJson());
      _config = config;
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<ConfigInfo?> getConfig() async {
    if (_config != null) {
      return _config;
    }

    final config = _prefs!.getString('config');

    if (config == null) {
      return null;
    }

    _config = ConfigInfo.fromJson(config);

    return _config;
  }
}
