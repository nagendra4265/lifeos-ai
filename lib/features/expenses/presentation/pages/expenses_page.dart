import 'package:flutter/material.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({super.key});

  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  final List<_ExpenseItem> _expenses = [
    const _ExpenseItem(title: 'Groceries', amount: '₹1200', category: 'Food'),
    const _ExpenseItem(title: 'Fuel', amount: '₹800', category: 'Travel'),
  ];

  Future<void> _showExpenseEditor() async {
    final titleController = TextEditingController();
    final amountController = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('New expense'),
          content: Column(
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
            ],
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
                if (title.isEmpty || amount.isEmpty) {
                  return;
                }

                setState(() {
                  _expenses.insert(
                    0,
                    _ExpenseItem(
                      title: title,
                      amount: '₹$amount',
                      category: 'General',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Expense Tracker')),
      floatingActionButton: FloatingActionButton(
        onPressed: _showExpenseEditor,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _expenses.length,
        itemBuilder: (context, index) {
          final expense = _expenses[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const Icon(Icons.receipt_long_outlined),
              title: Text(expense.title),
              subtitle: Text(expense.category),
              trailing: Text(
                expense.amount,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ExpenseItem {
  const _ExpenseItem({
    required this.title,
    required this.amount,
    required this.category,
  });

  final String title;
  final String amount;
  final String category;
}
