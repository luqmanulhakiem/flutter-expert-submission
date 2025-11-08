import 'package:bloc/bloc.dart';
import 'package:ditonton/src/features/tv/domain/entities/tv.dart';
import 'package:ditonton/src/features/tv/domain/usecases/get_now_playing_tv_series.dart';

part 'now_playing_tv_event.dart';
part 'now_playing_tv_state.dart';

class NowPlayingTvBloc extends Bloc<NowPlayingTvEvent, NowPlayingTvState> {
  final GetNowPlayingTvSeries usecases;
  NowPlayingTvBloc(this.usecases) : super(NowPlayingTvInitial()) {
    on<NowPlayingTvDataLoaded>((event, emit) async {
      emit(NowPlayingTvInProgress());
      final resp = await usecases.execute();
      emit(resp.fold(
        (l) => NowPlayingTvFailure(message: l.message),
        (r) => NowPlayingTvSuccess(data: r),
      ));
    });
  }
}
