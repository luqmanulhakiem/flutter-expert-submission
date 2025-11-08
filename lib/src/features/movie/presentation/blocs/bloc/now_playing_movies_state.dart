part of 'now_playing_movies_bloc.dart';

class NowPlayingMoviesState {}

class NowPlayingMoviesInitial extends NowPlayingMoviesState {}

class NowPlayingMoviesInProgress extends NowPlayingMoviesState {}

class NowPlayingMoviesSuccess extends NowPlayingMoviesState {
  final List<Movie> data;

  NowPlayingMoviesSuccess({required this.data});
}

class NowPlayingMoviesFailure extends NowPlayingMoviesState {
  final String message;

  NowPlayingMoviesFailure({required this.message});
}
