import 'dart:io';
import 'package:buah_app/buah.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseBuah {
  DatabaseBuah._privateConstructor();
  static final DatabaseBuah instance = DatabaseBuah._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "buah_database.db");
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    // Buat tabel buah
    await db.execute('''
        CREATE TABLE buahTabel
          (
            id INTEGER PRIMARY KEY,
            nama TEXT,
            harga INTEGER
          )
        ''');

  }

  // Fungsi retrieve data all buah
  Future<List<Buah>> getBuahAll() async {
    Database db = await instance.database;
    var buah = await db.query('buahTabel', orderBy: 'nama');
    List<Buah> buahList =
        buah.isNotEmpty ? buah.map((e) => Buah.fromMap(e)).toList() : [];
    return buahList;
  }

  // Fungsi retrieve data buah 1 aja
  Future<List<Buah>> getBuah(String nama) async {
    Database db = await instance.database;
    var buah = await db.query('buahTabel',
        where: 'nama LIKE ?', whereArgs: ['%$nama%'], orderBy: 'nama');
    List<Buah> buahList =
        buah.isNotEmpty ? buah.map((e) => Buah.fromMap(e)).toList() : [];
    return buahList;
  }

  // Fungsi insertion data buah
  Future<int> addBuah(Buah buah) async {
    Database db = await instance.database;
    return await db.insert(
      "buahTabel",
      buah.toMap(),
    );
  }

  // Fungsi update data buah
  Future<int> updateBuah(Buah buah) async {
    Database db = await instance.database;
    return await db.update(
      "buahTabel",
      buah.toMap(),
      where: 'id = ?',
      whereArgs: [buah.id],
    );
  }

  // Fungsi hapus data buah
  Future<int> deleteBuah(int id) async {
    Database db = await instance.database;
    return await db.delete(
      "buahTabel",
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
