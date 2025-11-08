import 'package:bloc/bloc.dart';
import 'package:ditonton/src/features/tv/domain/entities/tv.dart';
import 'package:ditonton/src/features/tv/domain/repositories/tv_series_repository.dart';

part 'tv_popular_event.dart';
part 'tv_popular_state.dart';

class TvPopularBloc extends Bloc<TvPopularEvent, TvPopularState> {
  final TvSeriesRepository repository;
  TvPopularBloc(this.repository) : super(TvPopularInitial()) {
    on<TvPopulaDataLoaded>((event, emit) async {
      emit(TvPopularInProgress());

      final resp = await repository.getPopularTvSeries();

      emit(resp.fold(
        (l) => TvPopularFailure(message: l.message),
        (r) => TvPopularSuccess(data: r),
      ));
    });
  }
}
