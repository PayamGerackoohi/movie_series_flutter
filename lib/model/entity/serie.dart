import 'dart:math';

class Serie {
  int? id;
  int? movieId;
  int index;
  int count;
  int last;

  Serie(this.index, {this.id, this.movieId, this.count = 1, this.last = 0});

  Serie.fromMap(Map<String, dynamic> map)
      : index = map['idx'] as int,
        id = map['id'] as int,
        movieId = map['movie_id'] as int,
        count = map['count'] as int,
        last = map['last'] as int;

  static List<Serie> fromMapList(List<Map<String, dynamic>> map) =>
      List.generate(map.length, (index) => Serie.fromMap(map[index]));

  int get value => index + 1;
  String get name => 'Serie $value';
  bool get isIncomplete => last != count;

  void add() => count++;

  void remove() {
    count = max(1, count - 1);
    last = min(last, count);
  }

  void seen(int episode) => last = episode;
  void unseen(int episode) => seen(max(0, episode - 1));

  void toggle(int episode) {
    if (episode > last) {
      seen(episode);
    } else {
      unseen(episode);
    }
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'movie_id': movieId,
        'idx': index,
        'count': count,
        'last': last,
      };

  @override
  String toString() =>
      'Serie(${toMap().entries.map((e) => '${e.key}: ${e.value}').join(', ')})';
}
