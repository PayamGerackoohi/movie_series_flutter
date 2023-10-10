import 'package:movie_series/model/database/dao/movie_dao.dart';
import 'package:movie_series/model/database/dao/serie_dao.dart';

abstract class MovieDatabase {
  MovieDao get movieDao;
  SerieDao get serieDao;
}
