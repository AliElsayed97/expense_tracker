import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class ExpenseHiveModel extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String category;
  @HiveField(2)
  String iconKey;
  @HiveField(3)
  double amountOriginal;
  @HiveField(4)
  String currency;
  @HiveField(5)
  double amountUsd;
  @HiveField(6)
  DateTime date;
  @HiveField(7)
  String? receiptPath;

  ExpenseHiveModel({
    required this.id,
    required this.category,
    required this.iconKey,
    required this.amountOriginal,
    required this.currency,
    required this.amountUsd,
    required this.date,
    this.receiptPath,
  });
}
