import 'package:flutter_application_1/core/models/expense.dart';
import 'package:flutter_application_1/core/repositories/base_repository.dart';

class ExpensesRepository extends BaseRepository<Expense> {
  ExpensesRepository() : super('expenses');
}
