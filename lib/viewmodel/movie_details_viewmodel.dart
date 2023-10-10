import 'package:movie_series/model/entity/movie.dart';
import 'package:movie_series/model/entity/serie.dart';

abstract class MovieDetailsViewModel {
  MovieDetailsState get state;
  void Function()? onChange;
  Future<void> deleteMovie(Movie movie);
  Future<bool> edit(Movie movie, String name);
  void addSerie();
  void addEpisode(int index);
  void removeSerie();
  void removeEpisode(int index);
  void toggleEpisode(Serie serie, int index);
}

abstract class MovieDetailsState {
  factory MovieDetailsState.loading() = MovieDetailsLoading;
  factory MovieDetailsState.success({required Movie movie}) =
      MovieDetailsSuccess;
  factory MovieDetailsState.movieNotFound() = MovieNotFound;
  factory MovieDetailsState.exitPage() = MovieDetailsExitPage;
}

class MovieDetailsLoading implements MovieDetailsState {
  const MovieDetailsLoading();
}

class MovieDetailsSuccess implements MovieDetailsState {
  final Movie movie;
  const MovieDetailsSuccess({required this.movie});
}

class MovieDetailsExitPage implements MovieDetailsState {
  const MovieDetailsExitPage();
}

class MovieNotFound implements MovieDetailsState {
  const MovieNotFound();
}
