import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/providers/expenses_provider.dart';
import 'package:intl/intl.dart';

import 'package:flutter_application_1/core/widgets/lifeos_ui.dart';

class ExpensesPage extends ConsumerStatefulWidget {
  const ExpensesPage({super.key});

  @override
  ConsumerState<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends ConsumerState<ExpensesPage> {
  String _selectedCategory = 'All';
  final currencyFormatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

  Future<void> _showExpenseEditor() async {
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    String selectedCategory = 'General';
    final categories = ['Food', 'Travel', 'Bills', 'General', 'Others'];

    await showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('New expense'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Title'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Amount'),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: selectedCategory,
                      decoration: const InputDecoration(labelText: 'Category'),
                      items: categories.map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            selectedCategory = newValue;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    final title = titleController.text.trim();
                    final amountStr = amountController.text.trim();
                    if (title.isEmpty || amountStr.isEmpty) return;
                    final amount = double.tryParse(amountStr) ?? 0;

                    ref.read(expensesProvider.notifier).addExpense(
                      title: title,
                      amount: amount,
                      category: selectedCategory,
                    );
                    
                    Navigator.of(context).pop();
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _showExpenseFilters() async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Expense filters',
                  style: Theme.of(
                    sheetContext,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 16),
                ...['All', 'Food', 'Travel', 'Bills', 'General'].map(
                  (category) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.category_rounded),
                    title: Text(category),
                    trailing: _selectedCategory == category
                        ? const Icon(Icons.check_rounded)
                        : null,
                    onTap: () {
                      setState(() => _selectedCategory = category);
                      Navigator.of(sheetContext).pop();
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      setState(() => _selectedCategory = 'All');
                      Navigator.of(sheetContext).pop();
                    },
                    child: const Text('Reset'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final expensesAsync = ref.watch(expensesProvider);

    return expensesAsync.when(
      data: (expenses) {
        final filteredExpenses = expenses.where((expense) {
          if (_selectedCategory == 'All') return true;
          return expense.category.toLowerCase() == _selectedCategory.toLowerCase();
        }).toList();

        final totalAmount = expenses.fold<double>(0, (sum, e) => sum + e.amount);

        return LifeOsPage(
          title: 'Expenses',
          subtitle: '${DateFormat('MMMM yyyy').format(DateTime.now())} spending overview',
          trailing: IconButton(
            onPressed: _showExpenseFilters,
            icon: const Icon(Icons.tune_rounded),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _showExpenseEditor,
            child: const Icon(Icons.add),
          ),
          children: [
            GridView.count(
              crossAxisCount: MediaQuery.sizeOf(context).width > 700 ? 3 : 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.1,
              children: [
                LifeOsMetricCard(
                  title: 'Total spent',
                  value: currencyFormatter.format(totalAmount),
                  subtitle: 'This month',
                  icon: Icons.pie_chart_rounded,
                  color: const Color(0xFF6D4CFF),
                ),
                const LifeOsMetricCard(
                  title: 'Expenses count',
                  value: '0', // Placeholder
                  subtitle: 'Transactions',
                  icon: Icons.receipt_long_rounded,
                  color: Color(0xFFFF4AA2),
                ).copyWithValue(expenses.length.toString()),
                const LifeOsMetricCard(
                  title: 'Budget left',
                  value: '₹12,350',
                  subtitle: 'For the month',
                  icon: Icons.account_balance_wallet_rounded,
                  color: Color(0xFF18A058),
                ),
              ],
            ),
            LifeOsCard(
              child: Row(
                children: [
                  const LifeOsDonutChart(
                    colors: [
                      Color(0xFF6D4CFF),
                      Color(0xFFFF4AA2),
                      Color(0xFF00B8FF),
                      Color(0xFFFFB547),
                      Color(0xFF18A058),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        LifeOsSectionTitle(title: 'Category split'),
                        SizedBox(height: 8),
                        Text('Based on your latest spending patterns.'),
                        SizedBox(height: 4),
                        Text('Add more expenses to see detailed analysis.'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ChoiceChip(
                  selected: _selectedCategory == 'All',
                  label: const Text('All'),
                  onSelected: (_) => setState(() => _selectedCategory = 'All'),
                ),
                ChoiceChip(
                  selected: _selectedCategory == 'Food',
                  label: const Text('Food'),
                  onSelected: (_) => setState(() => _selectedCategory = 'Food'),
                ),
                ChoiceChip(
                  selected: _selectedCategory == 'Travel',
                  label: const Text('Travel'),
                  onSelected: (_) => setState(() => _selectedCategory = 'Travel'),
                ),
                ChoiceChip(
                  selected: _selectedCategory == 'Bills',
                  label: const Text('Bills'),
                  onSelected: (_) => setState(() => _selectedCategory = 'Bills'),
                ),
              ],
            ),
            if (filteredExpenses.isEmpty)
              LifeOsCard(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Icon(Icons.account_balance_wallet_rounded, size: 48, color: lifeOsMuted.withValues(alpha: 0.5)),
                        const SizedBox(height: 12),
                        Text(
                          expenses.isEmpty ? 'No expenses yet.' : 'No results found.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: lifeOsMuted),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              ...filteredExpenses.map(
                (expense) => LifeOsListTile(
                  title: expense.title,
                  subtitle: '${expense.category} • ${DateFormat('dd MMM').format(expense.date)}',
                  icon: _getIconForCategory(expense.category),
                  color: _getColorForCategory(expense.category),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        currencyFormatter.format(expense.amount),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      IconButton(
                        onPressed: () => ref.read(expensesProvider.notifier).deleteExpense(expense.id),
                        icon: const Icon(Icons.delete_outline_rounded, size: 18),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }

  IconData _getIconForCategory(String category) {
    return switch (category.toLowerCase()) {
      'food' => Icons.restaurant_rounded,
      'travel' => Icons.directions_car_rounded,
      'bills' => Icons.receipt_long_rounded,
      _ => Icons.payment_rounded,
    };
  }

  Color _getColorForCategory(String category) {
    return switch (category.toLowerCase()) {
      'food' => const Color(0xFF6D4CFF),
      'travel' => const Color(0xFFFFB547),
      'bills' => const Color(0xFFFF4AA2),
      _ => lifeOsPurple,
    };
  }
}

extension on LifeOsMetricCard {
  LifeOsMetricCard copyWithValue(String newValue) {
    return LifeOsMetricCard(
      title: title,
      value: newValue,
      icon: icon,
      color: color,
      subtitle: subtitle,
    );
  }
}

class _ExpenseItem {
  const _ExpenseItem({
    required this.title,
    required this.amount,
    required this.category,
    required this.icon,
    required this.color,
  });

  final String title;
  final String amount;
  final String category;
  final IconData icon;
  final Color color;
}
