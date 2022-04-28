import 'package:lardgreen/models/sqllite_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQLiteHelper {
  final String nameDatabase = 'lardgreen.db';
  final String nameTable = 'chartTable';
  final int versionDatabase = 1;
  final String columnId = 'id';
  final String columnDocIdSeller = 'docIdSeller';
  final String columnNameSeller = 'nameSeller';
  final String columnDocIdProduct = 'docIdProduct';
  final String columnNameProduct = 'nameProduct';
  final String columnPrice = 'price';
  final String columnAmount = 'amount';
  final String columnSum = 'sum';

  SQLiteHelper() {
    initDatabase();
  }

  Future<void> initDatabase() async {
    await openDatabase(
      join(await getDatabasesPath(), nameDatabase),
      onCreate: (db, version) => db.execute(
          'CREATE TABLE $nameTable (id INTEGER PRIMARY KEY, $columnDocIdSeller TEXT, $columnNameSeller TEXT, $columnDocIdProduct TEXT, $columnNameProduct TEXT, $columnPrice TEXT, $columnAmount TEXT, $columnSum TEXT)'),
      version: versionDatabase,
    );
  }

  Future<Database> connectedDatabase() async {
    return await openDatabase(
      join(
        await getDatabasesPath(),
        nameDatabase,
      ),
    );
  }

  Future<void> insertNewValue({required SQLiteModel sqLiteModel}) async {
    Database database = await connectedDatabase();
    database
        .insert(
      nameTable,
      sqLiteModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    )
        .then((value) {
      print('insert Success at ==> ${sqLiteModel.toMap()}');
    });
  }

  Future<List<SQLiteModel>> readAllDatabase() async {
    Database database = await connectedDatabase();
    var sQLiteModels = <SQLiteModel>[];

    List<Map<String, dynamic>> maps = await database.query(nameTable);
    for (var item in maps) {
      SQLiteModel sqLiteModel = SQLiteModel.fromMap(item);
      sQLiteModels.add(sqLiteModel);
    }

    return sQLiteModels;
  }

  Future<void> deleteAllData() async {
    Database database = await connectedDatabase();
    await database.delete(nameTable);
  }

  Future<void> deleteWhereId({required int id}) async {
    Database database = await connectedDatabase();
    await database.delete(nameTable, where: '$columnId = $id');
  }
}
