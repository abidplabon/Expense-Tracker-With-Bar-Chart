import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

final formatter = DateFormat.yMd();
const uuid = Uuid();
enum Category {food, education, travel, entertainment}
const categoryIcons = {
  Category.food: Icons.lunch_dining,
  Category.education: Icons.read_more,
  Category.travel: Icons.flight_takeoff,
  Category.entertainment: Icons.movie,
};
class Expense{
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  Expense({required this.title,required this.amount,required this.date,required this.category}): id = uuid.v4();

  String get formattedDate{
    return formatter.format(date);
  }
}

class ExpenseBucket{
  final Category category;
  final List<Expense> expenses;

  const ExpenseBucket({
    required this.category,
    required this.expenses,
});
  ExpenseBucket.forCategory(List<Expense> allExpense, this.category): expenses = allExpense.where((expense) => expense.category==category).toList();
  double get totalExpenses{
    double sum = 0;
    for (final expense in expenses){
      sum +=expense.amount;
    }
    return sum;
  }
}
