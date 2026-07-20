import 'package:hive/hive.dart';

abstract class BaseRepository<T> {
  final String boxName;
  Box<T>? _box;

  BaseRepository(this.boxName);

  Future<Box<T>> get box async {
    if (_box?.isOpen ?? false) return _box!;
    _box = await Hive.openBox<T>(boxName);
    return _box!;
  }

  Future<List<T>> getAll() async {
    final b = await box;
    return b.values.toList();
  }

  Future<void> save(String id, T item) async {
    final b = await box;
    await b.put(id, item);
  }

  Future<void> delete(String id) async {
    final b = await box;
    await b.delete(id);
  }

  Future<T?> getById(String id) async {
    final b = await box;
    return b.get(id);
  }

  Future<void> clear() async {
    final b = await box;
    await b.clear();
  }
}
