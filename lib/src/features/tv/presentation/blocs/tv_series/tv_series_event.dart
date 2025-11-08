part of 'tv_series_bloc.dart';

class TvSeriesEvent {}

class TvSeriesDataSearched extends TvSeriesEvent {
  final String query;

  TvSeriesDataSearched({required this.query});
}

class TvSeriesDataSingleLoaded extends TvSeriesEvent {
  final int id;

  TvSeriesDataSingleLoaded({required this.id});
}
