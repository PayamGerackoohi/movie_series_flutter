import 'package:movie_series/model/entity/serie.dart';
import 'package:movie_series/platform/extensions.dart';

class Movie {
  int? id;
  String name;
  final List<Serie> series = [];

  Movie(this.name, {this.id});

  Movie.fromMap(Map<String, dynamic> map)
      : name = map['name'] as String,
        id = map['id'] as int;

  static List<Movie> fromMapList(List<Map<String, dynamic>> list) =>
      List.generate(list.length, (index) => Movie.fromMap(list[index]));

  int? get lastSerie => series.isEmpty
      ? null
      : series.firstWhereSafe((serie) => serie.isIncomplete)?.index;

  Serie addSerie() {
    final serie = Serie(series.length, count: serieCountSuggestion());
    series.add(serie);
    return serie;
  }

  Serie? removeSerie() => series.removeLastSafe();

  int serieCountSuggestion() {
    if (series.isEmpty) return 1;
    return series.last.count;
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
      };

  @override
  String toString() => 'Movie(id: $id, name: $name, series: $series)';
}
