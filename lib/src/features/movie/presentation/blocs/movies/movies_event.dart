part of 'movies_bloc.dart';

class MoviesEvent {}

class MoviesDataSearched extends MoviesEvent {
  final String query;

  MoviesDataSearched({required this.query});
}

class MoviesDataSingleLoaded extends MoviesEvent {
  final int id;

  MoviesDataSingleLoaded({required this.id});
}
