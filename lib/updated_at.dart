import 'package:grocery_app/database.dart';

Future<void> updateAddress(int id, Map<String, dynamic> updatedValues) async {
  final db = await DatabaseHelper().database;

  // Set the updated_at field to the current timestamp
  updatedValues['updated_at'] = DateTime.now().toIso8601String();

  await db.update(
    'shipping_addresses',
    updatedValues,
    where: 'id = ?',
    whereArgs: [id],
  );
}
