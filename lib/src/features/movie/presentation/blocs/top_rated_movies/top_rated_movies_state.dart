part of 'top_rated_movies_bloc.dart';

class TopRatedMoviesState {}

class TopRatedMoviesInitial extends TopRatedMoviesState {}

class TopRatedMoviesInProgress extends TopRatedMoviesState {}

class TopRatedMoviesSuccess extends TopRatedMoviesState {
  final List<Movie> data;

  TopRatedMoviesSuccess({required this.data});
}

class TopRatedMoviesFailure extends TopRatedMoviesState {
  final String message;

  TopRatedMoviesFailure({required this.message});
}
