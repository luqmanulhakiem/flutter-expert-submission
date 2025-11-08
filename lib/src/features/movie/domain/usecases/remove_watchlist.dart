import 'package:ditonton/src/features/movie/domain/entities/movie_detail.dart';
import 'package:ditonton/src/features/movie/presentation/blocs/watchlist_movies/watchlist_movies_bloc.dart';

class RemoveWatchlist {
  final WatchlistMoviesBloc bloc;

  RemoveWatchlist(this.bloc);

  Future<void> execute(MovieDetail movie) async {
    bloc.add(WatchlistMoviesDataRemoved(data: movie));
  }
}
