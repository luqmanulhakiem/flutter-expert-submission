import 'package:ditonton/src/features/tv/domain/entities/tv_detail.dart';
import 'package:ditonton/src/features/tv/presentation/blocs/watchlist_tv/watchlist_tv_bloc.dart';

class RemoveWatchlistTvSeries {
  final WatchlistTvBloc bloc;

  RemoveWatchlistTvSeries(this.bloc);

  Future<void> execute(TvDetail tvSeries) async {
    bloc.add(WatchlistTvDataRemoved(data: tvSeries));
  }
}
