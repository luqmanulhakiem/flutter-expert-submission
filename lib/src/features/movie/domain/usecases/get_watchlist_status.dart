import 'package:ditonton/src/features/movie/presentation/blocs/watchlist_movies/watchlist_movies_bloc.dart';

class GetWatchListStatus {
  final WatchlistMoviesBloc bloc;

  GetWatchListStatus(this.bloc);

  Future<void> execute(int id) async {
    bloc.add(WatchlistMoviesDataChecked(id: id));
  }
}
