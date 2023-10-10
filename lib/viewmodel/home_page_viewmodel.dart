import 'package:movie_series/model/entity/movie.dart';

abstract class HomePageViewModel {
  HomeState get state;
  void Function()? onChange;
  Future<bool> add(String movieName);
  Future<void> remove(Movie movie);
  Future<bool> edit(Movie oldMovie, String newMovieName);
}

abstract class HomeState {
  static const loading = HomeLoading();
  factory HomeState.success({required List<Movie> movies}) = HomeSuccess;
}

class HomeLoading implements HomeState {
  const HomeLoading();
}

class HomeSuccess implements HomeState {
  final List<Movie> movies;
  const HomeSuccess({required this.movies});
}
