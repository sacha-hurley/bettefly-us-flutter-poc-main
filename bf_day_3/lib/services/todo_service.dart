import 'package:flutter/foundation.dart';
import '../models/todo_item.dart';
import 'todo_persistence.dart';

/// Global TodoService - single source of truth for todos across the app
class TodoService extends ChangeNotifier {
  static final TodoService _instance = TodoService._internal();
  factory TodoService() => _instance;
  TodoService._internal();

  final TodoPersistenceService _persistence = TodoPersistenceService();

  final List<TodoItem> _items = <TodoItem>[];
  bool _isCollapsed = false; // shared collapse preference (for main card)
  bool _initialized = false;

  List<TodoItem> get items => List.unmodifiable(_items);
  bool get isCollapsed => _isCollapsed;
  bool get isInitialized => _initialized;

  Future<void> ensureInitialized() async {
    if (_initialized) return;
    final stored = await _persistence.loadItems();
    final collapsed = await _persistence.loadCollapsed();
    if (stored != null && stored.isNotEmpty) {
      _items
        ..clear()
        ..addAll(stored.where((e) => e.id != 'daily'));
    } else {
      // Defaults per PRD
      _items
        ..clear()
        ..addAll(<TodoItem>[
          TodoItem(
            id: 'profile',
            title: 'Profile setup',
            isCompleted: true,
            navigationRoute: '/profile',
          ),
          TodoItem(
            id: 'dashboard',
            title: 'Explore health dashboard',
            navigationRoute: '/dashboard',
          ),
          TodoItem(
            id: 'leaderboard',
            title: 'Explore leaderboard',
            navigationRoute: '/leaderboard',
          ),
          TodoItem(
            id: 'challenge',
            title: 'Opt-in to company challenge',
            navigationRoute: '/challenges',
          ),
          // 'daily' item removed per spec
        ]);
    }
    _isCollapsed = collapsed;
    _initialized = true;
    notifyListeners();
  }

  Future<void> toggleCollapse() async {
    _isCollapsed = !_isCollapsed;
    await _persistence.saveCollapsed(_isCollapsed);
    notifyListeners();
  }

  Future<void> setCollapsed(bool value) async {
    _isCollapsed = value;
    await _persistence.saveCollapsed(_isCollapsed);
    notifyListeners();
  }

  Future<void> toggleComplete(String id) async {
    for (var i = 0; i < _items.length; i++) {
      if (_items[i].id == id) {
        _items[i] = _items[i].copyWith(isCompleted: !_items[i].isCompleted);
        break;
      }
    }
    await _persistence.saveItems(_items);
    notifyListeners();
  }

  Future<void> markComplete(String id) async {
    for (var i = 0; i < _items.length; i++) {
      if (_items[i].id == id) {
        if (!_items[i].isCompleted) {
          _items[i] = _items[i].copyWith(isCompleted: true);
        }
        break;
      }
    }
    await _persistence.saveItems(_items);
    notifyListeners();
  }

  Future<void> remove(String id) async {
    _items.removeWhere((e) => e.id == id);
    await _persistence.saveItems(_items);
    notifyListeners();
  }

  TodoItem? getById(String id) {
    try {
      return _items.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }
}
