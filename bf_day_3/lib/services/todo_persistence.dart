import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo_item.dart';

class TodoPersistenceService {
  static const String _itemsKey = 'todo_items_v1';
  static const String _collapsedKey = 'todo_collapsed_v1';

  Future<void> saveItems(List<TodoItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final list = items.map((e) => e.toJson()).toList(growable: false);
    await prefs.setString(_itemsKey, jsonEncode(list));
  }

  Future<List<TodoItem>?> loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_itemsKey);
    if (jsonStr == null || jsonStr.isEmpty) return null;
    try {
      final decoded = jsonDecode(jsonStr) as List<dynamic>;
      return decoded
          .map((e) => TodoItem.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return null;
    }
  }

  Future<void> saveCollapsed(bool isCollapsed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_collapsedKey, isCollapsed);
  }

  Future<bool> loadCollapsed() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_collapsedKey) ?? false;
  }

  /// Debug helper to clear persisted todo state
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_itemsKey);
    await prefs.remove(_collapsedKey);
  }
}
