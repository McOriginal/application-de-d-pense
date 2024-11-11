import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_application_mobile/expense.dart';

class EditExpense extends StatefulWidget {
  const EditExpense({super.key, required this.expense, required this.onSave});

  final Expenses expense;
  final Function(Expenses) onSave;

  @override
  State<EditExpense> createState() => _EditExpenseState();
}

class _EditExpenseState extends State<EditExpense> {
  late TextEditingController titleController;
  late TextEditingController priceController;
  final formatter = DateFormat.yMMMd();
  TextEditingController selectedDate = TextEditingController();

  void _datePicker() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: widget.expense.date,
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate.text = formatter.format(pickedDate);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.expense.title);
    priceController =
        TextEditingController(text: widget.expense.price.toString());
    selectedDate.text = formatter.format(widget.expense.date);
  }

  @override
  void dispose() {
    titleController.dispose();
    priceController.dispose();
    super.dispose();
  }

  void _saveExpenseData() {
    final price = double.tryParse(priceController.text);
    final invalidPrice = price == null || price <= 0;
    if (titleController.text.trim().isEmpty || invalidPrice) {
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text("Erreur"),
            content: const Text(
              "Veuillez renseigner tous les champs et saisir une valeur valide pour le prix.",
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                ),
                child: const Text("Ok", style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      );
      return;
    } else {
      final updateData = Expenses(
        title: titleController.text,
        price: price,
        date: formatter.parse(selectedDate.text),
      );

      widget.onSave(updateData);
      Navigator.pop(context);
      // Enregistrez les modifications ici
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              filled: true,
              hintText: "Entrez un Titre",
              hintStyle: TextStyle(fontSize: 18),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
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
                      hintStyle: TextStyle(fontSize: 18),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
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
                      hintStyle: TextStyle(fontSize: 18),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
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
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text("Annuler",
                      style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _saveExpenseData,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text("Ajouter",
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
