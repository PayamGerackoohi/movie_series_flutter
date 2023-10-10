import 'package:movie_series/impl/model/di/di_impl.dart';
import 'package:movie_series/model/database/movie_database.dart';
import 'package:movie_series/model/repository/movie_repository.dart';
import 'package:movie_series/viewmodel/home_page_viewmodel.dart';
import 'package:movie_series/viewmodel/movie_details_viewmodel.dart';

abstract class DI {
  Future<MovieDatabase> get database;
  MovieRepository get movieRepository;
  HomePageViewModel get homePageViewModel;
  MovieDetailsViewModel getMovieDetailsViewModel({required int movieId});
}

final DI di = DiImpl();
