import 'package:flutter/material.dart';
import 'package:movie_series/model/di/di.dart';
import 'package:movie_series/model/entity/movie.dart';
import 'package:movie_series/platform/util.dart';
import 'package:movie_series/view/pages/details/remove_dialog.dart';
import 'package:movie_series/view/pages/details/serie_card.dart';
import 'package:movie_series/view/widget/add_or_edit_movie_dialog.dart';
import 'package:movie_series/viewmodel/movie_details_viewmodel.dart';

class MovieDetails extends StatefulWidget {
  final int movieId;
  final int? lastSerie;

  const MovieDetails(
      {required this.movieId, required this.lastSerie, super.key});

  @override
  State<MovieDetails> createState() => MovieDetailsState();
}

class MovieDetailsState extends State<MovieDetails> {
  late final MovieDetailsViewModel viewModel;
  late ScrollController _scrollController;
  int? _selected;
  GlobalKey firstItemkey = GlobalKey();
  double? headerHeight;
  late bool isFirstScrollDone;
  double? _height;

  @override
  void initState() {
    isFirstScrollDone = false;
    _scrollController = ScrollController();
    _selected = widget.lastSerie;
    viewModel = di.getMovieDetailsViewModel(movieId: widget.movieId);
    viewModel.onChange = () => setState(() {});
    super.initState();
  }

  @override
  void dispose() {
    viewModel.onChange = null;
    super.dispose();
  }

  void onSerieToggled(int index, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selected = index;
      } else {
        _selected = null;
      }
    });
  }

  void add() => _selected == null
      ? viewModel.addSerie()
      : viewModel.addEpisode(_selected!);

  void remove() => _selected == null
      ? viewModel.removeSerie()
      : viewModel.removeEpisode(_selected!);

  void requestDeleteMovie(BuildContext context, Movie movie) =>
      showRemoveDialog(context, movie, viewModel.deleteMovie);

  void edit(BuildContext context, Movie movie) =>
      showAddOrEditMovieDialog(context,
          isEdit: true,
          movie: movie.name,
          oldMovie: movie,
          editMovie: viewModel.edit);

  Widget makeSerieCard(Movie movie, int index, {Key? key}) => SerieCard(
        serie: movie.series[index],
        onSelectionChanged: onSerieToggled,
        toggleEpisode: viewModel.toggleEpisode,
        selected: _selected == index,
        key: key,
      );

  Widget infoPage(String text) => Scaffold(appBar: AppBar(title: Text(text)));

  Future<void> scrollToSelectedSerie({int tries = 10}) async {
    if (isFirstScrollDone || tries <= 1) return;
    await Future.delayed(const Duration(milliseconds: 100));
    headerHeight ??= firstItemkey.currentContext?.size?.height;
    if (_selected == null || headerHeight == null || _height == null) {
      return scrollToSelectedSerie(tries: tries - 1);
    }
    if (isFirstScrollDone) return;
    isFirstScrollDone = true;
    final index = _selected ?? 0;
    final margin = index == 0 ? 0 : 8;
    final target = headerHeight! * index + margin;
    if (target > _height! - 4 * headerHeight!) {
      _scrollController.animateTo(target,
          duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    scrollToSelectedSerie();
    final state = viewModel.state;
    if (state is MovieDetailsSuccess) {
      final movie = state.movie;
      final lastIndex = movie.series.length + 1;
      return Scaffold(
        appBar: AppBar(
          title: Text(movie.name),
          actions: [
            IconButton(
              tooltip: 'Edit',
              onPressed: () => edit(context, movie),
              icon: const Icon(Icons.edit),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: ListView.builder(
            controller: _scrollController,
            itemCount: lastIndex + 1,
            itemBuilder: (_, index) => (index == 0 || index == lastIndex)
                ? const SizedBox(height: 8)
                : makeSerieCard(movie, index - 1,
                    key: index == 1 ? firstItemkey : null),
          ),
        ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              onPressed: add,
              heroTag: 'Add',
              tooltip: 'Add',
              child: const Icon(Icons.add),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: FloatingActionButton(
                onPressed: remove,
                heroTag: 'Remove',
                tooltip: 'Remove',
                child: const Icon(Icons.remove),
              ),
            ),
            FloatingActionButton(
              backgroundColor: Colors.red,
              onPressed: () => requestDeleteMovie(context, movie),
              tooltip: 'Delete Serie',
              child: const Icon(Icons.delete),
            ),
          ],
        ),
      );
    } else if (state is MovieDetailsLoading) {
      return infoPage('Loading...');
    } else if (state is MovieNotFound || state is MovieDetailsExitPage) {
      exitWidget(context);
      return infoPage('Movie Not Found.');
    } else {
      throw Exception('Unknown MoiveDetailsState: $state');
    }
  }
}
