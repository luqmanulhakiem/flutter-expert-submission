part of 'tv_popular_bloc.dart';

class TvPopularState {}

class TvPopularInitial extends TvPopularState {}

class TvPopularInProgress extends TvPopularState {}

class TvPopularSuccess extends TvPopularState {
  final List<Tv> data;

  TvPopularSuccess({required this.data});
}

class TvPopularFailure extends TvPopularState {
  final String message;

  TvPopularFailure({required this.message});
}
