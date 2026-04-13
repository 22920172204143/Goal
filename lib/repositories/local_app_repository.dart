import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_settings.dart';
import '../models/income_record.dart';

class LocalAppRepository {
  static const _recordsKey = 'income_records';
  static const _settingsKey = 'app_settings';

  Future<List<IncomeRecord>> loadRecords() async {
    final preferences = await SharedPreferences.getInstance();
    final payload = preferences.getString(_recordsKey);
    if (payload == null || payload.isEmpty) {
      return <IncomeRecord>[];
    }
    return IncomeRecord.decodeList(payload);
  }

  Future<void> saveRecords(List<IncomeRecord> records) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_recordsKey, IncomeRecord.encodeList(records));
  }

  Future<AppSettings> loadSettings() async {
    final preferences = await SharedPreferences.getInstance();
    final payload = preferences.getString(_settingsKey);
    if (payload == null || payload.isEmpty) {
      return AppSettings.defaults();
    }
    return AppSettings.fromJson(jsonDecode(payload) as Map<String, dynamic>);
  }

  Future<void> saveSettings(AppSettings settings) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_settingsKey, jsonEncode(settings.toJson()));
  }
}
