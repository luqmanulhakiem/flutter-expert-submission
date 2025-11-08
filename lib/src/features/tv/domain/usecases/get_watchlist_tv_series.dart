import 'package:ditonton/src/features/tv/presentation/blocs/watchlist_tv/watchlist_tv_bloc.dart';

class GetWatchlistTvSeries {
  final WatchlistTvBloc bloc;

  GetWatchlistTvSeries(this.bloc);

  Future<void> execute() async {
    bloc.add(WatchlistTvDataLoaded());
  }
}
