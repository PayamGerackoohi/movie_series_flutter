import 'package:movie_series/model/entity/movie.dart';

abstract class MovieDao {
  Future<List<Movie>> getAll();
  Future<Movie?> getMovieBy({required int id});
  Future<int> insert(Movie movie);
  Future<void> update(Movie movie, {bool recursive = true});
  Future<void> delete(Movie movie);
  Future<bool> isNewValidName(String movieName);
}
