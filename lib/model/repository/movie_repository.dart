import 'package:movie_series/model/entity/movie.dart';

abstract class MovieRepository {
  Future<List<Movie>> get currentMovies;
  Future<Movie?> get currentMovie;
  Stream<List<Movie>> get movies;
  Stream<Movie?> loadMovie(int movieId);
  Future<bool> isNewValidName(String movie);
  Future<bool> add(String movieName);
  Future<bool> edit(Movie oldMovie, String newMovieName);
  Future<void> remove(Movie movie);
  Future<void> update(Movie movie);
  Future<void> addSerie(Movie movie);
  Future<void> removeSerie(Movie movie);
  Future<void> addEpisode(Movie movie, {required int serieIndex});
  Future<void> removeEpisode(Movie movie, {required int serieIndex});
  Future<void> toggleEpisode(Movie movie,
      {required int serieIndex, required int episodeIndex});
}
