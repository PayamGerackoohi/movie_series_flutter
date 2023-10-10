import 'package:movie_series/impl/model/database/movie_database_impl.dart';
import 'package:movie_series/impl/model/repository/movie_repository_impl.dart';
import 'package:movie_series/impl/viewmodel/home_page_viewmodel_impl.dart';
import 'package:movie_series/impl/viewmodel/movie_details_viewmodel.dart';
import 'package:movie_series/model/database/movie_database.dart';
import 'package:movie_series/model/di/di.dart';
import 'package:movie_series/model/repository/movie_repository.dart';
import 'package:movie_series/viewmodel/home_page_viewmodel.dart';
import 'package:movie_series/viewmodel/movie_details_viewmodel.dart';

class DiImpl implements DI {
  MovieDatabase? _database;
  MovieRepository? _movieRepository;
  HomePageViewModel? _homePageViewModel;
  int? _movieDetailsId;
  MovieDetailsViewModel? _movieDetailsViewModel;

  @override
  Future<MovieDatabase> get database async {
    _database ??= await MovieDatabaseImpl.create();
    return _database!;
  }

  @override
  MovieRepository get movieRepository =>
      _movieRepository ??= MovieRepositoryImpl(database: database);

  @override
  HomePageViewModel get homePageViewModel =>
      _homePageViewModel ??= HomePageViewModelImpl(repository: movieRepository);

  @override
  MovieDetailsViewModel getMovieDetailsViewModel({required int movieId}) {
    if (movieId == _movieDetailsId) {
      return _movieDetailsViewModel!;
    } else {
      _movieDetailsId = movieId;
      return _movieDetailsViewModel = MovieDetailsViewModelImpl(
          movieId: movieId, repository: movieRepository);
    }
  }
}
