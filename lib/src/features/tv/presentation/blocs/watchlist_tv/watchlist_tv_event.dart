part of 'watchlist_tv_bloc.dart';

class WatchlistTvEvent {}

class WatchlistTvDataLoaded extends WatchlistTvEvent {}

class WatchlistTvDataChecked extends WatchlistTvEvent {
  final int id;

  WatchlistTvDataChecked({required this.id});
}

class WatchlistTvDataStored extends WatchlistTvEvent {
  final TvDetail data;

  WatchlistTvDataStored({required this.data});
}

class WatchlistTvDataRemoved extends WatchlistTvEvent {
  final TvDetail data;

  WatchlistTvDataRemoved({required this.data});
}
