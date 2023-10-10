import 'package:movie_series/model/entity/serie.dart';

abstract class SerieDao {
  Future<List<Serie>> getAll();
  Future<List<Serie>> seriesOf(int? movieId);
  Future<int> insert(Serie serie);
  Future<void> update(Serie serie);
  Future<void> delete(Serie serie);
}
