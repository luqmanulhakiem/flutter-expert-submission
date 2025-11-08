import 'package:ditonton/src/features/movie/presentation/blocs/watchlist_movies/watchlist_movies_bloc.dart';

class GetWatchlistMovies {
  final WatchlistMoviesBloc bloc;

  GetWatchlistMovies(this.bloc);

  Future<void> execute() async {
    bloc.add(WatchlistMoviesDataLoaded());
  }
}
