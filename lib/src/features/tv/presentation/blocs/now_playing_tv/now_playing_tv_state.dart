part of 'now_playing_tv_bloc.dart';

class NowPlayingTvState {}

class NowPlayingTvInitial extends NowPlayingTvState {}

class NowPlayingTvInProgress extends NowPlayingTvState {}

class NowPlayingTvSuccess extends NowPlayingTvState {
  final List<Tv> data;

  NowPlayingTvSuccess({required this.data});
}

class NowPlayingTvFailure extends NowPlayingTvState {
  final String message;

  NowPlayingTvFailure({required this.message});
}
