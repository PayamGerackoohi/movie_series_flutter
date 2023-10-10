import 'package:flutter/material.dart';
import 'package:movie_series/model/entity/movie.dart';

class RemoveDialog extends StatelessWidget {
  final Movie movie;
  final Future<void> Function(Movie) remove;
  final textStyle = const TextStyle(color: Colors.black, fontSize: 16);

  const RemoveDialog(this.movie, this.remove, {super.key});

  void confirm(BuildContext context) {
    remove(movie);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: Center(
                child: Text(
              'Remove Movie',
              style: Theme.of(context).textTheme.headlineSmall,
            ))),
        Padding(
            padding: const EdgeInsets.all(8),
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: 'Are you sure, you want to remove the ',
                  style: textStyle,
                ),
                TextSpan(
                    text: '"${movie.name}"',
                    style: textStyle.copyWith(
                        color: Colors.red, fontWeight: FontWeight.bold)),
                TextSpan(
                  text: ' movie?',
                  style: textStyle,
                ),
              ]),
            )),
        InkWell(
          autofocus: true,
          onTap: () => confirm(context),
          child: Ink(
            color: Colors.red,
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                    child: Text(
                  'Remove',
                  style: Theme.of(context)
                      .textTheme
                      .button
                      ?.apply(color: Colors.white),
                ))),
          ),
        )
      ],
    );
  }
}

void showRemoveDialog(BuildContext context, Movie movie,
        Future<void> Function(Movie) remove) =>
    showModalBottomSheet(
        context: context, builder: (_) => RemoveDialog(movie, remove));
