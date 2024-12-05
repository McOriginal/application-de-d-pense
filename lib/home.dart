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
  String? dropdownMonthValue;

  @override
  void initState() {
    super.initState();
    dropdownMonthValue = null;
  }

  void _addExpenses(Expenses expense) {
    setState(() {
      _expenses.add(expense);
      _calculateTotalForSelectedMonth(dropdownMonthValue);
    });
  }

  double _calculateTotalForSelectedMonth(String? month) {
    if (month == null) {
      setState(() {});
      return _expenses.fold(0.0, (sum, item) => sum + item.price);
    }
    return _expenses
        .where((expense) => DateFormat.M().format(expense.date) == month)
        .fold(0.0, (sum, item) => sum + item.price);
  }

  @override
  Widget build(BuildContext context) {
    // Créons une liste de mois uniques basés sur les dates des dépenses.
    final months = _expenses
        .map((item) => DateFormat.M().format(item.date))
        .toSet()
        .toList();

    final totalSpent = _calculateTotalForSelectedMonth(dropdownMonthValue);

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
                      dropdownMonthValue == null
                          ? const Text(
                              "Filtrer par mois:  ",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.indigo,
                              ),
                            )
                          : TextButton(
                              onPressed: () {
                                setState(() {
                                  dropdownMonthValue = null;
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
                        value: dropdownMonthValue,
                        onChanged: (String? value) {
                          setState(() {
                            dropdownMonthValue = value;
                            _calculateTotalForSelectedMonth(dropdownMonthValue);
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
                        items: months.map((month) {
                          return DropdownMenuItem<String>(
                            value: month,
                            child: Text(month),
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
                  onUpdateTotal: (month) {
                    _calculateTotalForSelectedMonth(month);
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
