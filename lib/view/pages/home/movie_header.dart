import 'package:flutter/material.dart';
import 'package:movie_series/model/entity/movie.dart';
import 'package:movie_series/view/routes/routes.dart';
import 'package:movie_series/view/widget/error_dialog.dart';

class MovieHeader extends StatelessWidget {
  final Movie movie;

  const MovieHeader(this.movie, {super.key});

  void showDetails(BuildContext context) {
    if (movie.id == null) {
      showErrorDialog(context, error: 'Movie id is null!');
    } else {
      Navigator.of(context)
          .push(detailsRouteOf(movieId: movie.id!, lastSerie: movie.lastSerie));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: ElevatedButton(
            onPressed: () => showDetails(context),
            child: Padding(
                padding: const EdgeInsets.all(16), child: Text(movie.name))));
  }
}
