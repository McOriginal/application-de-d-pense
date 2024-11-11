import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();
final formatter = DateFormat.yMMMd();

class Expenses {
  final String id;
  late String title;
  late double price;
  late DateTime date;

  Expenses({
    required this.title,
    required this.price,
    required this.date,
  }) : id = uuid.v4();

  String get formateDate {
    return formatter.format(date);
  }
}
