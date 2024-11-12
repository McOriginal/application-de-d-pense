import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  String? dropdownValue;

  @override
  void initState() {
    super.initState();
    dropdownValue = null;
  }

  void _addExpenses(Expenses expense) {
    setState(() {
      _expenses.add(expense);
      _calculateTotalForSelectedYear(dropdownValue);
    });
  }

  double _calculateTotalForSelectedYear(String? year) {
    if (year == null) {
      setState(() {});
      return _expenses.fold(0.0, (sum, item) => sum + item.price);
    }
    return _expenses
        .where((expense) => DateFormat.y().format(expense.date) == year)
        .fold(0.0, (sum, item) => sum + item.price);
  }

  @override
  Widget build(BuildContext context) {
    // Créons une liste d'années uniques basées sur les dates des dépenses.
    final years = _expenses
        .map((item) => DateFormat.y().format(item.date))
        .toSet()
        .toList();

    final totalSpent = _calculateTotalForSelectedYear(dropdownValue);

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
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          color: Colors.white54,
          child: Column(
            children: [
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      dropdownValue == null
                          ? const Text(
                              "Filtrer par:  ",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.indigo,
                              ),
                            )
                          : TextButton(
                              onPressed: () {
                                setState(() {
                                  dropdownValue = null;
                                });
                              },
                              child: const Text(
                                "Effacer",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                      DropdownButton<String>(
                        value: dropdownValue,
                        onChanged: (String? value) {
                          setState(() {
                            dropdownValue = value;
                            _calculateTotalForSelectedYear(dropdownValue);
                          });
                        },
                        underline: Container(
                          color: Colors.indigo,
                          height: 1,
                        ),
                        icon: const Icon(
                          Icons.arrow_drop_down_circle_sharp,
                          size: 25,
                          color: Colors.indigo,
                        ),
                        items: years.map((year) {
                          return DropdownMenuItem<String>(
                            value: year,
                            child: Text(year),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        "Total",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
                      Text(
                        "${totalSpent.toStringAsFixed(2)} F",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 15),
              Expanded(
                child: ExpenseList(
                  expenses: _expenses,
                  onUpdateTotal: (year) {
                    _calculateTotalForSelectedYear(year);
                  },
                ),
              ),
            ],
          ),
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
