import 'package:bloc/bloc.dart';
import 'package:ditonton/src/features/tv/domain/entities/tv.dart';
import 'package:ditonton/src/features/tv/domain/repositories/tv_series_repository.dart';

part 'top_rated_tv_event.dart';
part 'top_rated_tv_state.dart';

class TopRatedTvBloc extends Bloc<TopRatedTvEvent, TopRatedTvState> {
  final TvSeriesRepository repository;
  TopRatedTvBloc(this.repository) : super(TopRatedTvInitial()) {
    on<TopRatedTvDataLoaded>((event, emit) async {
      emit(TopRatedTvInProgress());

      final resp = await repository.getTopRatedTvSeries();

      emit(resp.fold(
        (l) => TopRatedTvFailure(message: l.message),
        (r) => TopRatedTvSuccess(data: r),
      ));
    });
  }
}
