import 'package:flutter/material.dart';
import 'package:movie_series/model/entity/movie.dart';
import 'package:movie_series/model/util/ripple.dart';

class AddOrEditMovieDialog extends StatefulWidget {
  final Future<bool> Function(String)? addMovie;
  final Future<bool> Function(Movie, String)? editMovie;
  final Movie? oldMovie;
  final bool isEdit;
  final String movie;
  const AddOrEditMovieDialog(this.movie, this.isEdit,
      {this.addMovie, this.editMovie, this.oldMovie, super.key});

  @override
  State<AddOrEditMovieDialog> createState() => AddOrEditMovieDialogState();
}

class AddOrEditMovieDialogState extends State<AddOrEditMovieDialog>
    with SingleTickerProviderStateMixin {
  final Ripple ripple = const Ripple(peaks: 3, magnitude: .02);
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  late String movie;

  @override
  void initState() {
    movie = widget.movie;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _colorAnimation =
        ColorTween(begin: Colors.blue, end: Colors.red).animate(_controller);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void onNameChanged(String value) {
    movie = value;
  }

  Future<void> applyMovie(BuildContext context) async {
    if (movie.isEmpty) {
      shake();
    } else {
      if (widget.isEdit
          ? await widget.editMovie!(widget.oldMovie!, movie)
          : await widget.addMovie!(movie)) {
        Navigator.pop(context);
      } else {
        shake();
      }
    }
  }

  void shake() async {
    await _controller.forward();
    await _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        // padding: const EdgeInsets.all(0),
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(0),
              child: TextField(
                autofocus: true,
                controller: TextEditingController(text: movie),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(8),
                  hintText: 'Enter the movie name',
                ),
                onChanged: onNameChanged,
                onSubmitted: (_) => applyMovie(context),
              ),
            ),
            AnimatedBuilder(
              animation: _colorAnimation,
              builder: (_, child) => InkWell(
                onTap: () => applyMovie(context),
                child: Ink(
                  color: _colorAnimation.value,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Align(
                      alignment: Alignment(ripple.of(_controller.value), 0.0),
                      child: Text(
                        widget.isEdit ? 'Edit' : 'Add',
                        style: Theme.of(context)
                            .textTheme
                            .button
                            ?.apply(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}

void showAddOrEditMovieDialog(BuildContext context,
        {Future<bool> Function(String)? addMovie,
        Future<bool> Function(Movie, String)? editMovie,
        Movie? oldMovie,
        bool isEdit = false,
        String movie = ''}) =>
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: ((_) => AddOrEditMovieDialog(movie, isEdit,
            addMovie: addMovie, editMovie: editMovie, oldMovie: oldMovie)));
