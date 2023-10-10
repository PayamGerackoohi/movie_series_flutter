import 'package:movie_series/model/entity/movie.dart';
import 'package:movie_series/model/entity/serie.dart';
import 'package:movie_series/model/repository/movie_repository.dart';
import 'package:movie_series/viewmodel/movie_details_viewmodel.dart';

class MovieDetailsViewModelImpl implements MovieDetailsViewModel {
  MovieDetailsViewModelImpl({required int movieId, required this.repository}) {
    _loadMovie(movieId);
  }

  final MovieRepository repository;
  Movie? _movie;
  set movie(value) {
    _movie = value;
    if (value == null) {
      state = MovieDetailsState.movieNotFound();
    } else {
      state = MovieDetailsState.success(movie: value);
    }
  }

  @override
  MovieDetailsState get state => _state;
  MovieDetailsState _state = MovieDetailsState.loading();
  set state(value) {
    _state = value;
    onChange?.call();
  }

  @override
  void Function()? onChange;

  void _loadMovie(movieId) async {
    repository.loadMovie(movieId).listen((Movie? movie) => this.movie = movie);
    final currentMovie = await repository.currentMovie;
    if (currentMovie != null) movie = currentMovie;
  }

  @override
  void addEpisode(int index) {
    final m = _movie;
    if (m != null) repository.addEpisode(m, serieIndex: index);
  }

  @override
  void addSerie() {
    final m = _movie;
    if (m != null) repository.addSerie(m);
  }

  @override
  Future<void> deleteMovie(Movie movie) async {
    await repository.remove(movie);
    state = MovieDetailsState.exitPage();
  }

  @override
  Future<bool> edit(Movie movie, String name) => repository.edit(movie, name);

  @override
  void removeSerie() {
    final m = _movie;
    if (m != null) repository.removeSerie(m);
  }

  @override
  void removeEpisode(int index) {
    final m = _movie;
    if (m != null) repository.removeEpisode(m, serieIndex: index);
  }

  @override
  void toggleEpisode(Serie serie, int index) {
    final m = _movie;
    if (m != null) {
      repository.toggleEpisode(m, serieIndex: serie.index, episodeIndex: index);
    }
  }
}
