import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/models/expense.dart';
import 'package:flutter_application_1/core/repositories/expenses_repository.dart';
import 'package:uuid/uuid.dart';

final expensesRepositoryProvider = Provider((ref) => ExpensesRepository());

final expensesProvider = AsyncNotifierProvider<ExpensesNotifier, List<Expense>>(ExpensesNotifier.new);

class ExpensesNotifier extends AsyncNotifier<List<Expense>> {
  late final ExpensesRepository _repository;

  @override
  Future<List<Expense>> build() async {
    _repository = ref.watch(expensesRepositoryProvider);
    return _repository.getAll();
  }

  Future<void> addExpense({
    required String title,
    required double amount,
    required String category,
    DateTime? date,
    String? note,
  }) async {
    final expense = Expense(
      id: const Uuid().v4(),
      title: title,
      amount: amount,
      category: category,
      date: date ?? DateTime.now(),
      note: note,
    );
    
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.save(expense.id, expense);
      return _repository.getAll();
    });
  }

  Future<void> deleteExpense(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.delete(id);
      return _repository.getAll();
    });
  }
}
