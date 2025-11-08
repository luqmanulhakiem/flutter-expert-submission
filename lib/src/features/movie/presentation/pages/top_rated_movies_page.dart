import 'package:ditonton/src/features/movie/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/src/features/movie/presentation/blocs/top_rated_movies/top_rated_movies_bloc.dart';
import 'package:ditonton/src/features/movie/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopRatedMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/top-rated-movie';

  @override
  _TopRatedMoviesPageState createState() => _TopRatedMoviesPageState();
}

class _TopRatedMoviesPageState extends State<TopRatedMoviesPage> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final bloc = BlocProvider.of<TopRatedMoviesBloc>(context, listen: false);
    await GetTopRatedMovies(bloc).execute();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Rated Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TopRatedMoviesBloc, TopRatedMoviesState>(
          builder: (context, state) {
            if (state is TopRatedMoviesInProgress) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TopRatedMoviesSuccess) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = state.data[index];
                  return MovieCard(movie);
                },
                itemCount: state.data.length,
              );
            } else if (state is TopRatedMoviesFailure) {
              return Center(
                key: Key('error_message'),
                child: Text(state.message),
              );
            }
            return SizedBox();
          },
        ),
      ),
    );
  }
}
