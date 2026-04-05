import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

abstract class NotificationsLocalDataSource {
  Future<void> saveReadIds(Set<String> ids);
  Set<String> loadReadIds();
}

class NotificationsLocalDataSourceImpl implements NotificationsLocalDataSource {
  const NotificationsLocalDataSourceImpl(this._prefs);

  static const _key = 'read_notification_ids';
  final SharedPreferences _prefs;

  @override
  Future<void> saveReadIds(Set<String> ids) async {
    if (ids.isEmpty) {
      await _prefs.remove(_key);
      return;
    }
    await _prefs.setString(_key, jsonEncode(ids.toList()));
  }

  @override
  Set<String> loadReadIds() {
    final jsonStr = _prefs.getString(_key);
    if (jsonStr == null) return {};
    try {
      final list = (jsonDecode(jsonStr) as List).cast<String>();
      return list.toSet();
    } on Object {
      return {};
    }
  }
}
