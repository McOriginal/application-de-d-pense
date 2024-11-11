import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_application_mobile/expense.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});
  final void Function(Expenses expense) onAddExpense;
  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  late TextEditingController titleController;
  late TextEditingController priceController;
  final formatter = DateFormat.yMMMd();
  TextEditingController selectedDate = TextEditingController();

  void _datePicker() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
    );

    setState(() {
      selectedDate.text = formatter.format(pickedDate!);
    });
  }

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    priceController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    priceController.dispose();
  }

  void _saveExpenseData() {
    final price = double.tryParse(priceController.text);
    final invalidPrice = price == null || price <= 0;
    try {
      if (titleController.text.trim().isEmpty || invalidPrice) {
        showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: const Text("Erreur"),
                content: const Text(
                    "Veuillez renseigner tous les champs et saisir une valeur valide pour le prix."),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                    ),
                    child: const Text(
                      "Ok",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              );
            });
        return;
      } else {
        return setState(() {
          widget.onAddExpense(Expenses(
            title: titleController.text,
            price: price.toDouble(),
            date: formatter.parse(selectedDate.text),
          ));
          Navigator.pop(context);
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(2),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(15),
            child: TextField(
              controller: titleController,
              decoration: const InputDecoration(
                filled: true,
                hintText: "Entrez un Titre",
                hintStyle: TextStyle(
                  fontSize: 18,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: TextField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        filled: true,
                        hintText: "Somme",
                        prefixText: "F ",
                        hintStyle: TextStyle(
                          fontSize: 18,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(12),
                          ),
                        )),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: TextField(
                    controller: selectedDate,
                    decoration: const InputDecoration(
                      filled: true,
                      prefixIcon: Icon(
                        Icons.date_range,
                        size: 25,
                        color: Colors.blue,
                      ),
                      hintStyle: TextStyle(
                        fontSize: 18,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                    ),
                    readOnly: true,
                    onTap: _datePicker,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text(
                    "Annuler",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _saveExpenseData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text(
                    "Ajouter",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
