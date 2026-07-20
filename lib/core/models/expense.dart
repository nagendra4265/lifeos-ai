import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'expense.freezed.dart';
part 'expense.g.dart';

@freezed
@HiveType(typeId: 1)
class Expense with _$Expense {
  const factory Expense({
    @HiveField(0) required String id,
    @HiveField(1) required String title,
    @HiveField(2) required double amount,
    @HiveField(3) required DateTime date,
    @HiveField(4) required String category,
    @HiveField(5) String? note,
  }) = _Expense;

  factory Expense.fromJson(Map<String, dynamic> json) => _$ExpenseFromJson(json);
}
