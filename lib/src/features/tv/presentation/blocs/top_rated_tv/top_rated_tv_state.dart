part of 'top_rated_tv_bloc.dart';

class TopRatedTvState {}

class TopRatedTvInitial extends TopRatedTvState {}

class TopRatedTvInProgress extends TopRatedTvState {}

class TopRatedTvSuccess extends TopRatedTvState {
  final List<Tv> data;

  TopRatedTvSuccess({required this.data});
}

class TopRatedTvFailure extends TopRatedTvState {
  final String message;

  TopRatedTvFailure({required this.message});
}
