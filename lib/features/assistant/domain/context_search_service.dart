import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/providers/notes_provider.dart';
import 'package:flutter_application_1/core/providers/expenses_provider.dart';
import 'package:flutter_application_1/core/providers/tasks_provider.dart';
import 'package:flutter_application_1/core/providers/reminders_provider.dart';
import 'package:intl/intl.dart';

final contextSearchServiceProvider = Provider((ref) => ContextSearchService(ref));

class ContextSearchService {
  final Ref _ref;
  ContextSearchService(this._ref);

  Future<String> query(String input) async {
    final query = input.toLowerCase();

    // 1. Search Expenses
    if (query.contains('spend') || query.contains('expense') || query.contains('cost') || query.contains('bought')) {
      final expenses = _ref.read(expensesProvider).valueOrNull ?? [];
      if (expenses.isEmpty) return "You haven't recorded any expenses yet.";
      
      final total = expenses.fold<double>(0, (sum, e) => sum + e.amount);
      final formatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);
      
      if (query.contains('how much') || query.contains('total')) {
        return "You have spent a total of ${formatter.format(total)} based on your records.";
      }
      
      final matches = expenses.where((e) => query.contains(e.title.toLowerCase()) || query.contains(e.category.toLowerCase())).toList();
      if (matches.isNotEmpty) {
        final last = matches.last;
        return "I found ${matches.length} matching expenses. The latest one is '${last.title}' for ${formatter.format(last.amount)} on ${DateFormat('MMM dd').format(last.date)}.";
      }
      
      return "You've recorded ${expenses.length} expenses totaling ${formatter.format(total)}.";
    }

    // 2. Search Tasks
    if (query.contains('task') || query.contains('todo') || query.contains('do today')) {
      final tasks = _ref.read(tasksProvider).valueOrNull ?? [];
      final pending = tasks.where((t) => !t.isCompleted).toList();
      
      if (pending.isEmpty) return "You don't have any pending tasks. Great job!";
      
      return "You have ${pending.length} pending tasks. The most recent one is '${pending.first.title}'.";
    }

    // 3. Search Notes
    if (query.contains('note') || query.contains('remember') || query.contains('think about')) {
      final notes = _ref.read(notesProvider).valueOrNull ?? [];
      final matches = notes.where((n) => query.contains(n.title.toLowerCase()) || n.content.toLowerCase().contains(query)).toList();
      
      if (matches.isNotEmpty) {
        return "I found a note titled '${matches.first.title}': ${matches.first.content.take(100)}...";
      }
      
      if (notes.isNotEmpty) {
        return "You have ${notes.length} notes saved. Try searching for a specific topic.";
      }
    }

    // 4. Search Reminders
    if (query.contains('remind') || query.contains('upcoming') || query.contains('calendar')) {
      final reminders = _ref.read(remindersProvider).valueOrNull ?? [];
      if (reminders.isEmpty) return "You have no upcoming reminders.";
      
      final next = reminders.first;
      return "Your next reminder is '${next.title}' scheduled for ${DateFormat('MMM dd, hh:mm a').format(next.dateTime)}.";
    }

    return "I'm not quite sure about that. I checked your notes, expenses, tasks, and reminders but couldn't find a direct answer. Can you try rephrasing?";
  }
}

extension StringExtension on String {
  String take(int n) => length > n ? substring(0, n) : this;
}
