import 'dart:async';

import 'package:movie_series/model/database/movie_database.dart';
import 'package:movie_series/model/entity/movie.dart';
import 'package:movie_series/model/repository/movie_repository.dart';
import 'package:movie_series/platform/extensions.dart';

class MovieRepositoryImpl implements MovieRepository {
  MovieRepositoryImpl({required this.database}) {
    _moviesStream = _moviesController.stream.asBroadcastStream();
    _movieStream = _movieController.stream.asBroadcastStream();
    _movies = database.then((db) => db.movieDao.getAll());
    _movie = currentMovies.then((cm) => null);
  }

  final Future<MovieDatabase> database;
  final StreamController<List<Movie>> _moviesController = StreamController();
  final StreamController<Movie?> _movieController = StreamController();
  late Stream<List<Movie>> _moviesStream;
  late Stream<Movie?> _movieStream;
  late final Future<List<Movie>> _movies;
  late Future<Movie?> _movie;

  int? _movieId;
  get movieId => _movieId;
  set movieId(value) {
    _movieId = value;
    _movie = currentMovies.then((cm) =>
        _movieId == null ? null : cm.firstWhereSafe((e) => e.id == _movieId));
  }

  @override
  Future<List<Movie>> get currentMovies => _movies;

  @override
  Future<Movie?> get currentMovie => _movie;

  @override
  Stream<List<Movie>> get movies => _moviesStream;

  void _triggerMoviesStream() => _movies.then((m) => _moviesController.add(m));

  void _triggerMovieStream() => _movie.then((m) => _movieController.add(m));

  @override
  Future<bool> isNewValidName(String movie) async {
    if (movie.isEmpty) return false;
    return database.then((db) => db.movieDao.isNewValidName(movie));
  }

  @override
  Future<bool> add(String movieName) async {
    final isValid = await isNewValidName(movieName);
    if (isValid) {
      final movie = Movie(movieName);
      final id = await database.then((db) => db.movieDao.insert(movie));
      (await _movies).add(movie..id = id);
      _triggerMoviesStream();
    }
    return isValid;
  }

  @override
  Future<bool> edit(Movie oldMovie, String newMovieName) async {
    if (oldMovie.name == newMovieName) return true;
    var valid = await isNewValidName(newMovieName);
    if (valid) oldMovie.name = newMovieName;
    database.then((db) => db.movieDao.update(oldMovie, recursive: false));
    _triggerMoviesStream();
    _changeIfRelevant(oldMovie);
    return valid;
  }

  @override
  Future<void> remove(Movie movie) async {
    await database.then((db) => db.movieDao.delete(movie));
    final id = movie.id;
    (await _movies).remove(movie);
    _triggerMoviesStream();
    if (movieId == id) {
      movieId = null;
      _triggerMovieStream();
    }
  }

  @override
  Future<void> update(Movie movie) async {
    await database.then((db) => db.movieDao.update(movie));
    _triggerMoviesStream();
    _changeIfRelevant(movie);
  }

  @override
  Stream<Movie?> loadMovie(int movieId) {
    this.movieId = movieId;
    return _movieStream;
  }

  @override
  Future<void> addSerie(Movie movie) async {
    final serie = movie.addSerie();
    serie.id = await database
        .then((db) => db.serieDao.insert(serie..movieId = movie.id));
    // _triggerMoviesStream();
    _changeIfRelevant(movie);
  }

  @override
  Future<void> removeSerie(Movie movie) async {
    final serie = movie.removeSerie();
    if (serie != null) {
      await database.then((db) => db.serieDao.delete(serie));
      // _triggerMoviesStream();
      _changeIfRelevant(movie);
    }
  }

  @override
  Future<void> addEpisode(Movie movie, {required int serieIndex}) async {
    final serie = movie.series[serieIndex];
    serie.add();
    await database.then((db) => db.serieDao.update(serie));
    // _triggerMoviesStream();
    _changeIfRelevant(movie);
  }

  @override
  Future<void> removeEpisode(Movie movie, {required int serieIndex}) async {
    final serie = movie.series[serieIndex];
    serie.remove();
    await database.then((db) => db.serieDao.update(serie));
    // _triggerMoviesStream();
    _changeIfRelevant(movie);
  }

  @override
  Future<void> toggleEpisode(Movie movie,
      {required int serieIndex, required int episodeIndex}) async {
    final serie = movie.series[serieIndex];
    serie.toggle(episodeIndex);
    await database.then((db) => db.serieDao.update(serie));
    // _triggerMoviesStream();
    _changeIfRelevant(movie);
  }

  void _changeIfRelevant(Movie movie) {
    if (movie.id == movieId) _triggerMovieStream();
  }
}
