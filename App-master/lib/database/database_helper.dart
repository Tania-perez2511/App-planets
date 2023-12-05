import 'package:path/path.dart';
import 'package:planets/screens/formCelestial.dart';
import 'package:planets/screens/formSistem.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    return await openDatabase(
      join(dbPath, 'registro_cuerpos_celestes.db'),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE cuerpos_celestes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT,
            foto TEXT,
            descripcion TEXT,
            tipo TEXT,
            naturaleza TEXT,
            tamano REAL,
            distancia REAL,
            sistemaId INTEGER
          );
        ''');
        await db.execute('''
          CREATE TABLE sistemas(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT,
            foto TEXT,
            descripcion TEXT,
            tamano REAL,
            distancia REAL
          );
        ''');
      },
      version: 1,
    );
  }

  Future<int> CREATE_CEL(CREATE_CELE_BODY cuerpoCeleste) async {
    Database db = await database;
    return await db.insert('cuerpos_celestes', cuerpoCeleste.toMap());
  }

  Future<int> CREATE_SIS(INFO_SISTEM sistema) async {
    Database db = await database;
    return await db.insert('sistemas', sistema.toMap());
  }

  Future<List<CREATE_CELE_BODY>> GET_CEL_TYPE() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('cuerpos_celestes');
    return List.generate(maps.length, (i) {
      return CREATE_CELE_BODY.fromMap(maps[i]);
    });
  }

  Future<List<INFO_SISTEM>> GET_SS_CSR() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('sistemas');
    return List.generate(maps.length, (i) {
      return INFO_SISTEM.fromMap(maps[i]);
    });
  }

  Future<INFO_SISTEM> GET_SIS_ORDER(int id) async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'sistemas',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return INFO_SISTEM.fromMap(maps.first);
    } else {
      throw Exception('Sistema no encontrado');
    }
  }
}
