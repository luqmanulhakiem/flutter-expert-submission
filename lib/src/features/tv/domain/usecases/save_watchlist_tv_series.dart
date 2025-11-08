import 'package:ditonton/src/features/tv/domain/entities/tv_detail.dart';
import 'package:ditonton/src/features/tv/presentation/blocs/watchlist_tv/watchlist_tv_bloc.dart';

class SaveWatchlistTvSeries {
  final WatchlistTvBloc bloc;

  SaveWatchlistTvSeries(this.bloc);

  Future<void> execute(TvDetail tvSeries) async {
    bloc.add(WatchlistTvDataStored(data: tvSeries));
  }
}
