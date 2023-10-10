import 'package:movie_series/impl/model/database/dao/serie_dao_impl.dart';
import 'package:movie_series/model/database/dao/movie_dao.dart';
import 'package:movie_series/model/database/dao/serie_dao.dart';
import 'package:movie_series/model/database/movie_database.dart';
import 'package:movie_series/model/entity/movie.dart';
import 'package:sqflite/sqlite_api.dart';

class MovieDaoImpl extends MovieDao {
  MovieDaoImpl({required this.db, required this.table, required this.dao});

  final Database db;
  final String table;
  final MovieDatabase dao;

  SerieDao _serieDaoBy(Transaction t) => (dao.serieDao as SerieDaoImpl)..ex = t;

  @override
  Future<List<Movie>> getAll() => db.transaction((txn) async {
        final movies = Movie.fromMapList(await txn.query(table));
        for (var movie in movies) {
          final series = await _serieDaoBy(txn).seriesOf(movie.id);
          movie.series.addAll(series);
        }
        return movies;
      });

  @override
  Future<Movie?> getMovieBy({required int id}) => db.transaction((txn) async {
        final movies = Movie.fromMapList(
            await txn.query(table, where: 'id = ?', whereArgs: [id], limit: 1));
        if (movies.isEmpty) {
          return null;
        } else {
          final movie = movies.first;
          final series = await _serieDaoBy(txn).seriesOf(movie.id);
          movie.series.addAll(series);
          return movie;
        }
      });

  @override
  Future<int> insert(Movie movie) => db.transaction((txn) async {
        final id = await txn.insert(
          table,
          movie.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        final series = movie.series;
        for (var serie in series) {
          await _serieDaoBy(txn).insert(serie..movieId = id);
        }
        return id;
      });

  @override
  Future<void> update(Movie movie, {bool recursive = true}) =>
      db.transaction((txn) async {
        final id = movie.id;
        await txn
            .update(table, movie.toMap(), where: 'id = ?', whereArgs: [id]);
        if (recursive) {
          final series = movie.series;
          final serieDao = _serieDaoBy(txn);
          for (final serie in series) {
            if (serie.movieId == null) {
              serie.id = await serieDao.insert(serie..movieId = id);
            } else {
              serieDao.update(serie);
            }
          }
          final seriesIdList = series.map((s) => s.id);
          final connectedSeries = await serieDao.seriesOf(id);
          final dangledSeries =
              connectedSeries.where((s) => !seriesIdList.contains(s.id));
          for (var s in dangledSeries) {
            await serieDao.delete(s);
          }
        }
      });

  @override
  Future<void> delete(Movie movie) => db.transaction((txn) async {
        final id = movie.id;
        txn.delete(table, where: 'id = ?', whereArgs: [id]);
        final series = movie.series;
        for (var serie in series) {
          _serieDaoBy(txn).delete(serie);
        }
      });

  @override
  Future<bool> isNewValidName(String movieName) => db
          .query(table, where: 'name = ?', whereArgs: [movieName], limit: 1)
          .then((result) async {
        return result.isEmpty;
      });
}
