import 'package:flutter/material.dart';
import 'package:movie_series/view/pages/details/movie_details.dart';

Route detailsRouteOf({required int movieId, required int? lastSerie}) =>
    PageRouteBuilder<SlideTransition>(
      pageBuilder: (context, animation, secondaryAnimation) =>
          MovieDetails(movieId: movieId, lastSerie: lastSerie),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var tween =
            Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero);
        var curveTween = CurveTween(curve: Curves.ease);
        return SlideTransition(
          position: animation.drive(curveTween).drive(tween),
          child: child,
        );
      },
    );
