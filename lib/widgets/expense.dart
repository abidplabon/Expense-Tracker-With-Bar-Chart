import 'package:flutter/material.dart';
import 'package:track_expense/widgets/chart/chart.dart';
import 'package:track_expense/widgets/expense_list/expense_list.dart';
import 'package:track_expense/models/expense.dart';
import 'package:track_expense/widgets/new_expense.dart';


class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registerExpenses =[
    Expense(title: 'Flutter Learning', amount: 19.00, date: DateTime.now(), category: Category.food),
    Expense(title: 'Flutter Learning', amount: 19.00, date: DateTime.now(), category: Category.food)
  ];
  
  void _overLayPress(){
    showModalBottomSheet(context: context, builder: (ctx)=> NewExpense(onAddExpense: _addExpense));
  }

  void _addExpense(Expense expense){
    setState(() {
      _registerExpenses.add(expense);
    });
  }
  void _removeExpense(Expense expense){
    final expenseIndex = _registerExpenses.indexOf(expense);
    setState(() {
      _registerExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 3),
            content: const Text("Expense Deleted"),
          action: SnackBarAction(label: "Undo", onPressed: (){
            setState(() {
              _registerExpenses.insert(expenseIndex, expense);
            });
          }),
        ));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Flutter Expense Tracker')),
        actions: [
          IconButton(
              onPressed: _overLayPress,
              icon: const Icon(Icons.add)),
        ],
      ),
      body: Center(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Chart(expenses: _registerExpenses),
              Expanded(child: ExpensesList(expenses: _registerExpenses, onRemoveExpense: _removeExpense,))
            ],
          ),
      ),
    );
  }
}
