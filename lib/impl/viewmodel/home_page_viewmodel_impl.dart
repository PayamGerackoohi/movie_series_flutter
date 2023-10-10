import 'package:movie_series/model/entity/movie.dart';
import 'package:movie_series/model/repository/movie_repository.dart';
import 'package:movie_series/viewmodel/home_page_viewmodel.dart';

class HomePageViewModelImpl implements HomePageViewModel {
  HomePageViewModelImpl({required this.repository}) {
    _loadMovies();
  }

  final MovieRepository repository;

  @override
  HomeState get state => _state;
  HomeState _state = HomeState.loading;
  set state(value) {
    _state = value;
    onChange?.call();
  }

  @override
  void Function()? onChange;

  void _loadMovies() async {
    state = HomeSuccess(movies: await repository.currentMovies);
    repository.movies.listen((movies) => state = HomeSuccess(movies: movies));
  }

  @override
  Future<bool> add(String movieName) => repository.add(movieName);

  @override
  Future<void> remove(Movie movie) => repository.remove(movie);

  @override
  Future<bool> edit(Movie oldMovie, String newMovieName) =>
      repository.edit(oldMovie, newMovieName);
}
