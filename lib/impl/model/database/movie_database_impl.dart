import 'package:flutter/material.dart';
import 'package:movie_series/impl/model/database/dao/movie_dao_impl.dart';
import 'package:movie_series/impl/model/database/dao/serie_dao_impl.dart';
import 'package:movie_series/model/database/dao/movie_dao.dart';
import 'package:movie_series/model/database/dao/serie_dao.dart';
import 'package:movie_series/model/database/movie_database.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// *** databasesPath ***
// *** ~/Library/Containers/com.example.movieSeries/Data/.dart_tool/sqflite_common_ffi/databases
// *** ~/Library/Containers/com.example.movieSeries/Data/Documents
class MovieDatabaseImpl implements MovieDatabase {
  static const String databaseName = 'movie_series.db';
  static const String movieTable = 'movie';
  static const String serieTable = 'serie';
  final Database db;

  MovieDatabaseImpl._create({required this.db});

  static Future<MovieDatabaseImpl> create() async {
    WidgetsFlutterBinding.ensureInitialized();
    // databaseFactory = databaseFactoryFfi;
    final db = await openDatabase(join(await getDatabasesPath(), databaseName),
        onCreate: ((db, version) => db.transaction((txn) async {
              await txn.execute('create table $movieTable('
                  'id integer primary key autoincrement,'
                  'name text)');
              await txn.execute('create table $serieTable('
                  'id integer primary key autoincrement,'
                  'movie_id integer,'
                  'idx integer,'
                  'count integer,'
                  'last integer)');
            })),
        version: 1);
    return MovieDatabaseImpl._create(db: db);
  }

  @override
  MovieDao get movieDao => MovieDaoImpl(db: db, table: movieTable, dao: this);

  @override
  SerieDao get serieDao => SerieDaoImpl(db: db, table: serieTable);
}
