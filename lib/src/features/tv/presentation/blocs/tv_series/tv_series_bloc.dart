import 'package:bloc/bloc.dart';
import 'package:ditonton/src/features/tv/domain/entities/tv.dart';
import 'package:ditonton/src/features/tv/domain/entities/tv_detail.dart';
import 'package:ditonton/src/features/tv/domain/repositories/tv_series_repository.dart';

part 'tv_series_event.dart';
part 'tv_series_state.dart';

class TvSeriesBloc extends Bloc<TvSeriesEvent, TvSeriesState> {
  final TvSeriesRepository repository;
  TvSeriesBloc(this.repository) : super(TvSeriesInitial()) {
    on<TvSeriesDataSearched>((event, emit) async {
      emit(TvSeriesInProgress());
      final resp = await repository.searchTvSeries(event.query);
      emit(resp.fold(
        (l) => TvSeriesFailure(message: l.message),
        (r) => TvSeriesSuccess(data: r),
      ));
    });

    on<TvSeriesDataSingleLoaded>((event, emit) async {
      emit(TvSeriesSingleInProgress());
      final resp = await repository.getTvSeriesDetail(event.id);
      emit(resp.fold(
        (l) => TvSeriesSingleFailure(message: l.message),
        (r) => TvSeriesSingleSuccess(data: r),
      ));
    });
  }
}
