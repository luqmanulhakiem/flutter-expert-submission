part of 'watchlist_movies_bloc.dart';

class WatchlistMoviesState {}

class WatchlistMoviesInitial extends WatchlistMoviesState {}

class WatchlistMoviesInProgress extends WatchlistMoviesState {}

class WatchlistMoviesSuccess extends WatchlistMoviesState {
  final bool isAddedToWatchlist;

  WatchlistMoviesSuccess({required this.isAddedToWatchlist});
}

class WatchlistMoviesFailure extends WatchlistMoviesState {
  final String message;

  WatchlistMoviesFailure({required this.message});
}

class WatchlistMoviesActionInProgress extends WatchlistMoviesState {}

class WatchlistMoviesActionSuccess extends WatchlistMoviesState {
  final String message;

  WatchlistMoviesActionSuccess({required this.message});
}

class WatchlistMoviesActionFailure extends WatchlistMoviesState {
  final String message;

  WatchlistMoviesActionFailure({required this.message});
}

class WatchlistMoviesDataInProgress extends WatchlistMoviesState {}

class WatchlistMoviesDataSuccess extends WatchlistMoviesState {
  final List<Movie> data;

  WatchlistMoviesDataSuccess({required this.data});
}

class WatchlistMoviesDataFailure extends WatchlistMoviesState {
  final String message;

  WatchlistMoviesDataFailure({required this.message});
}
