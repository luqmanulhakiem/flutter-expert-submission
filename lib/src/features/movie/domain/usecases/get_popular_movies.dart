import 'package:ditonton/src/features/movie/presentation/blocs/popular_movies/popular_movies_bloc.dart';

class GetPopularMovies {
  final PopularMoviesBloc bloc;

  GetPopularMovies(this.bloc);

  Future<void> execute() async {
    bloc.add(PopularMoviesDataLoaded());
  }
}
