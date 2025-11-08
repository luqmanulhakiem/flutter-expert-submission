import 'package:ditonton/src/features/movie/presentation/blocs/top_rated_movies/top_rated_movies_bloc.dart';

class GetTopRatedMovies {
  final TopRatedMoviesBloc bloc;

  GetTopRatedMovies(this.bloc);

  Future<void> execute() async {
    bloc.add(TopRatedMoviesDataLoaded());
  }
}
