part of 'watchlist_movies_bloc.dart';

class WatchlistMoviesEvent {}

class WatchlistMoviesDataLoaded extends WatchlistMoviesEvent {}

class WatchlistMoviesDataChecked extends WatchlistMoviesEvent {
  final int id;

  WatchlistMoviesDataChecked({required this.id});
}

class WatchlistMoviesDataStored extends WatchlistMoviesEvent {
  final MovieDetail data;

  WatchlistMoviesDataStored({required this.data});
}

class WatchlistMoviesDataRemoved extends WatchlistMoviesEvent {
  final MovieDetail data;

  WatchlistMoviesDataRemoved({required this.data});
}
