part of 'movies_bloc.dart';

class MoviesState {}

class MoviesInitial extends MoviesState {}

class MoviesInProgress extends MoviesState {}

class MoviesSuccess extends MoviesState {
  final List<Movie> data;

  MoviesSuccess({required this.data});
}

class MoviesFailure extends MoviesState {
  final String message;

  MoviesFailure({required this.message});
}

class MoviesSingleInProgress extends MoviesState {}

class MoviesSingleSuccess extends MoviesState {
  final MovieDetail data;

  MoviesSingleSuccess({required this.data});
}

class MoviesSingleFailure extends MoviesState {
  final String message;

  MoviesSingleFailure({required this.message});
}
