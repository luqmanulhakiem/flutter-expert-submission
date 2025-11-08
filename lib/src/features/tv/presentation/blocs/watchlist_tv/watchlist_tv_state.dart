part of 'watchlist_tv_bloc.dart';

class WatchlistTvState {}

class WatchlistTvInitial extends WatchlistTvState {}

class WatchlistTvInProgress extends WatchlistTvState {}

class WatchlistTvSuccess extends WatchlistTvState {
  final bool isAddedToWatchlist;

  WatchlistTvSuccess({required this.isAddedToWatchlist});
}

class WatchlistTvFailure extends WatchlistTvState {
  final String message;

  WatchlistTvFailure({required this.message});
}

class WatchlistTvActionInProgress extends WatchlistTvState {}

class WatchlistTvActionSuccess extends WatchlistTvState {
  final String message;

  WatchlistTvActionSuccess({required this.message});
}

class WatchlistTvActionFailure extends WatchlistTvState {
  final String message;

  WatchlistTvActionFailure({required this.message});
}

class WatchlistTvDataInProgress extends WatchlistTvState {}

class WatchlistTvDataSuccess extends WatchlistTvState {
  final List<Tv> data;

  WatchlistTvDataSuccess({required this.data});
}

class WatchlistTvDataFailure extends WatchlistTvState {
  final String message;

  WatchlistTvDataFailure({required this.message});
}
