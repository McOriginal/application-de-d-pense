import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_application_mobile/editExpense.dart';
import 'package:todo_application_mobile/expense.dart';

class ExpenseList extends StatefulWidget {
  const ExpenseList(
      {super.key, required this.expenses, required this.onUpdateTotal});

  final List<Expenses> expenses;
  final Function(String?) onUpdateTotal;

  @override
  State<ExpenseList> createState() => _ExpenseListState();
}

class _ExpenseListState extends State<ExpenseList> {
  void updataExpenseData(index, Expenses updateItem) {
    setState(() {
      widget.expenses[index] = updateItem;
    });
    widget.onUpdateTotal(null);
  }

  void deleteExpense(int index) {
    final removedExpense = widget.expenses[index];
    setState(() {
      widget.expenses.removeAt(index);
    });
    widget.onUpdateTotal(null);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${removedExpense.title} a été supprimé.',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formatDate = DateFormat.yMd();
    late Widget content;

    if (widget.expenses.isNotEmpty) {
      content = ListView.builder(
          itemCount: widget.expenses.length,
          itemBuilder: (context, index) {
            final expense = widget.expenses[index];
            return Dismissible(
              key: Key(expense.id.toString()),
              background: Container(color: Colors.red),
              onDismissed: (direction) {
                deleteExpense(index);
              },
              child: Card(
                elevation: 7,
                color: Colors.indigo,
                margin: const EdgeInsets.only(bottom: 30),
                child: SizedBox(
                  height: 130,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(
                            Icons.monetization_on_sharp,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                expense.title.toUpperCase(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                formatDate.format(expense.date),
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.amber,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "${expense.price.toStringAsFixed(2)} F",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (ctx) {
                                          return EditExpense(
                                            expense: expense,
                                            onSave: (updatedItem) {
                                              return updataExpenseData(
                                                  index, updatedItem);
                                            },
                                          );
                                        });
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    deleteExpense(index);
                                  },
                                  icon: const Icon(
                                    Icons.delete_forever,
                                    size: 30,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
    } else {
      content = const Center(
        child: Text(
          "Aucune dépense pour le moment",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.indigo,
          ),
        ),
      );
    }
    return content;
  }
}
