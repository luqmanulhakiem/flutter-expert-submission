import 'package:bloc/bloc.dart';
import 'package:ditonton/src/features/tv/domain/entities/tv.dart';
import 'package:ditonton/src/features/tv/domain/entities/tv_detail.dart';
import 'package:ditonton/src/features/tv/domain/usecases/get_detail_tv_series.dart';
import 'package:ditonton/src/features/tv/domain/usecases/search_tv_series.dart';

part 'tv_series_event.dart';
part 'tv_series_state.dart';

class TvSeriesBloc extends Bloc<TvSeriesEvent, TvSeriesState> {
  final SearchTvSeries searchTvSeries;
  final GetDetailTvSeries getDetailTvSeries;
  TvSeriesBloc(this.searchTvSeries, this.getDetailTvSeries)
      : super(TvSeriesInitial()) {
    on<TvSeriesDataSearched>((event, emit) async {
      emit(TvSeriesInProgress());
      final resp = await searchTvSeries.execute(event.query);
      emit(resp.fold(
        (l) => TvSeriesFailure(message: l.message),
        (r) => TvSeriesSuccess(data: r),
      ));
    });

    on<TvSeriesDataSingleLoaded>((event, emit) async {
      emit(TvSeriesSingleInProgress());
      final resp = await getDetailTvSeries.execute(event.id);
      emit(resp.fold(
        (l) => TvSeriesSingleFailure(message: l.message),
        (r) => TvSeriesSingleSuccess(data: r),
      ));
    });
  }
}
