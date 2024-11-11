import 'package:flutter/material.dart';
import 'package:todo_application_mobile/ListExpense.dart';
import 'package:todo_application_mobile/expense.dart';
import 'package:todo_application_mobile/newExpense.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Expenses> _expenses = [];

  void _addExpenses(Expenses expense) {
    setState(() {
      _expenses.add(expense);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 12,
        backgroundColor: Colors.indigo,
        centerTitle: true,
        title: const Text(
          "Suivi de dépenses",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        color: Colors.white54,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text(
                  "Filtrer :  ",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.indigo,
                  ),
                ),
                const Text(
                  "Somme dépensé :  ",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ExpenseList(expenses: _expenses),
            ),
          ],
        ),
      ),
      floatingActionButton: InkWell(
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (ctx) {
              return NewExpense(
                onAddExpense: _addExpenses,
              );
            },
          );
        },
        child: Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Colors.indigo,
            boxShadow: const [
              BoxShadow(
                blurRadius: 5,
              ),
            ],
          ),
          child: const Icon(
            Icons.add,
            size: 50,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
