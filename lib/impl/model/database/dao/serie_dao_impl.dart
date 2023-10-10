import 'package:movie_series/model/database/dao/serie_dao.dart';
import 'package:movie_series/model/entity/serie.dart';
import 'package:sqflite/sqlite_api.dart';

class SerieDaoImpl extends SerieDao {
  SerieDaoImpl({required this.db, required this.table});

  final Database db;
  final String table;
  DatabaseExecutor? _ex;
  DatabaseExecutor get ex => _ex ?? db;
  set ex(value) => _ex = value;

  @override
  Future<List<Serie>> getAll() async => Serie.fromMapList(await ex.query(
        table,
        orderBy: 'idx asc',
      ));

  @override
  Future<List<Serie>> seriesOf(int? movieId) async => Serie.fromMapList(
        await ex.query(
          table,
          where: 'movie_id = ?',
          whereArgs: [movieId],
          orderBy: 'idx asc',
        ),
      );

  @override
  Future<int> insert(Serie serie) async => ex.insert(
        table,
        serie.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

  @override
  Future<void> update(Serie serie) async => ex.update(
        table,
        serie.toMap(),
        where: 'id = ?',
        whereArgs: [serie.id],
      );

  @override
  Future<void> delete(Serie serie) async => ex.delete(
        table,
        where: 'id = ?',
        whereArgs: [serie.id],
      );
}
