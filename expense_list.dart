import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/expense.dart';

class ExpenseList extends StatefulWidget {
  const ExpenseList({Key? key}) : super(key: key);

  @override
  State<ExpenseList> createState() => _ExpenseListState();
}

class _ExpenseListState extends State<ExpenseList> {
  late Future<List<Expense>> _expenses;

  @override
  void initState() {
    super.initState();
    _expenses = DBHelper.getExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Expense>>(
      future: _expenses,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading expenses.'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No expenses found.'));
        }

        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final expense = snapshot.data![index];
            return ListTile(
              title: Text(expense.title),
              subtitle: Text('${expense.category} • ${expense.date.split('T')[0]}'),
              trailing: Text('\$${expense.amount.toStringAsFixed(2)}'),
            );
          },
        );
      },
    );
  }
}
