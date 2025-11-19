import 'package:hive/hive.dart';

import 'expense_hive_model.dart';

class ExpenseHiveModelAdapter extends TypeAdapter<ExpenseHiveModel> {
  @override
  final int typeId = 1;

  @override
  ExpenseHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (int i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return ExpenseHiveModel(
      id: fields[0] as String,
      category: fields[1] as String,
      iconKey: fields[2] as String,
      amountOriginal: fields[3] as double,
      currency: fields[4] as String,
      amountUsd: fields[5] as double,
      date: fields[6] as DateTime,
      receiptPath: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ExpenseHiveModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.category)
      ..writeByte(2)
      ..write(obj.iconKey)
      ..writeByte(3)
      ..write(obj.amountOriginal)
      ..writeByte(4)
      ..write(obj.currency)
      ..writeByte(5)
      ..write(obj.amountUsd)
      ..writeByte(6)
      ..write(obj.date)
      ..writeByte(7)
      ..write(obj.receiptPath);
  }
}
