part of 'popular_movies_bloc.dart';

class PopularMoviesState {}

class PopularMoviesInitial extends PopularMoviesState {}

class PopularMoviesInProgress extends PopularMoviesState {}

class PopularMoviesSuccess extends PopularMoviesState {
  final List<Movie> data;

  PopularMoviesSuccess({required this.data});
}

class PopularMoviesFailure extends PopularMoviesState {
  final String message;

  PopularMoviesFailure({required this.message});
}
