part of 'tv_series_bloc.dart';

class TvSeriesState {}

class TvSeriesInitial extends TvSeriesState {}

class TvSeriesInProgress extends TvSeriesState {}

class TvSeriesSuccess extends TvSeriesState {
  final List<Tv> data;

  TvSeriesSuccess({required this.data});
}

class TvSeriesFailure extends TvSeriesState {
  final String message;

  TvSeriesFailure({required this.message});
}

class TvSeriesSingleInProgress extends TvSeriesState {}

class TvSeriesSingleSuccess extends TvSeriesState {
  final TvDetail data;

  TvSeriesSingleSuccess({required this.data});
}

class TvSeriesSingleFailure extends TvSeriesState {
  final String message;

  TvSeriesSingleFailure({required this.message});
}
