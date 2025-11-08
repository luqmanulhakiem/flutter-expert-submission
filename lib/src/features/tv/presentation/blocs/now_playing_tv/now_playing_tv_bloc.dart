import 'package:bloc/bloc.dart';
import 'package:ditonton/src/features/tv/domain/entities/tv.dart';
import 'package:ditonton/src/features/tv/domain/repositories/tv_series_repository.dart';

part 'now_playing_tv_event.dart';
part 'now_playing_tv_state.dart';

class NowPlayingTvBloc extends Bloc<NowPlayingTvEvent, NowPlayingTvState> {
  final TvSeriesRepository repository;
  NowPlayingTvBloc(this.repository) : super(NowPlayingTvInitial()) {
    on<NowPlayingTvDataLoaded>((event, emit) async {
      emit(NowPlayingTvInProgress());
      final resp = await repository.getNowPlayingTvSeries();
      emit(resp.fold(
        (l) => NowPlayingTvFailure(message: l.message),
        (r) => NowPlayingTvSuccess(data: r),
      ));
    });
  }
}
