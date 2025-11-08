import 'package:ditonton/src/features/tv/presentation/blocs/watchlist_tv/watchlist_tv_bloc.dart';

class GetWatchlistStatusTvSeries {
  final WatchlistTvBloc bloc;

  GetWatchlistStatusTvSeries(this.bloc);

  Future<void> execute(int id) async {
    bloc.add(WatchlistTvDataChecked(id: id));
  }
}
