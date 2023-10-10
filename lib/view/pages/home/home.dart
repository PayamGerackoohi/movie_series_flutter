import 'package:flutter/material.dart';
import 'package:movie_series/model/di/di.dart';
import 'package:movie_series/view/pages/home/movie_header.dart';
import 'package:movie_series/view/widget/add_or_edit_movie_dialog.dart';
import 'package:movie_series/viewmodel/home_page_viewmodel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late final HomePageViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = di.homePageViewModel;
    viewModel.onChange = () => setState(() {});
  }

  @override
  void dispose() {
    viewModel.onChange = null;
    super.dispose();
  }

  void addNewMovie(BuildContext context) =>
      showAddOrEditMovieDialog(context, addMovie: viewModel.add);

  Widget makeContent() {
    final state = viewModel.state;
    if (state is HomeSuccess) {
      final movies = state.movies;
      final lastIndex = movies.length + 1;
      return (ListView.builder(
        itemCount: lastIndex + 1,
        itemBuilder: (c, i) => i == 0 || i == lastIndex
            ? const SizedBox(height: 8)
            : MovieHeader(movies[i - 1]),
      ));
    } else {
      return const Text('');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Expanded(
              child: makeContent(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addNewMovie(context),
        tooltip: 'Add Movie',
        child: const Icon(Icons.add),
      ),
    );
  }
}
