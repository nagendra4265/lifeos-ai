import 'package:flutter/material.dart';

import 'package:flutter_application_1/core/widgets/lifeos_ui.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({super.key});

  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  final List<_ExpenseItem> _expenses = [
    const _ExpenseItem(
      title: 'Groceries',
      amount: '₹1,200',
      category: 'Food',
      icon: Icons.shopping_bag_rounded,
      color: Color(0xFFFFB547),
    ),
    const _ExpenseItem(
      title: 'Fuel',
      amount: '₹800',
      category: 'Travel',
      icon: Icons.local_gas_station_rounded,
      color: Color(0xFF3D5AFE),
    ),
    const _ExpenseItem(
      title: 'Subscription',
      amount: '₹499',
      category: 'Bills',
      icon: Icons.subscriptions_rounded,
      color: Color(0xFFFF4AA2),
    ),
  ];

  String _selectedCategory = 'All';

  Future<void> _showExpenseEditor() async {
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    final categoryController = TextEditingController(text: 'General');

    await showDialog<void>(
      context: context,
      builder: (context) {
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
                TextField(
                  controller: categoryController,
                  decoration: const InputDecoration(labelText: 'Category'),
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
                final amount = amountController.text.trim();
                if (title.isEmpty || amount.isEmpty) return;

                setState(() {
                  _expenses.insert(
                    0,
                    _ExpenseItem(
                      title: title,
                      amount: '₹$amount',
                      category: categoryController.text.trim().isEmpty
                          ? 'General'
                          : categoryController.text.trim(),
                      icon: Icons.receipt_long_rounded,
                      color: lifeOsPurple,
                    ),
                  );
                });
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
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
    final filteredExpenses = _expenses.where((expense) {
      if (_selectedCategory == 'All') return true;
      return expense.category.toLowerCase() == _selectedCategory.toLowerCase();
    }).toList();

    final totalAmount = _expenses.fold<int>(
      0,
      (sum, expense) => sum + _parseAmount(expense.amount),
    );

    return LifeOsPage(
      title: 'Expenses',
      subtitle: 'May 2024 spending overview',
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
              value: '₹$totalAmount',
              subtitle: 'This month',
              icon: Icons.pie_chart_rounded,
              color: const Color(0xFF6D4CFF),
            ),
            const LifeOsMetricCard(
              title: 'Bills due',
              value: '5',
              subtitle: 'Upcoming',
              icon: Icons.event_note_rounded,
              color: Color(0xFFFF4AA2),
            ),
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
                    LifeOsSectionTitle(title: 'Monthly overview'),
                    SizedBox(height: 8),
                    Text(
                      'Food & Dining',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 4),
                    Text('32%'),
                    SizedBox(height: 8),
                    Text(
                      'Transport',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 4),
                    Text('18%'),
                    SizedBox(height: 8),
                    Text(
                      'Shopping',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 4),
                    Text('15%'),
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
            child: Text(
              'No expenses in this category.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          )
        else
          ...filteredExpenses.map(
            (expense) => LifeOsListTile(
              title: expense.title,
              subtitle: expense.category,
              icon: expense.icon,
              color: expense.color,
              trailing: Text(
                expense.amount,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
            ),
          ),
      ],
    );
  }

  int _parseAmount(String amount) {
    final digits = amount.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(digits) ?? 0;
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
