import 'package:bloc/bloc.dart';
import 'package:ditonton/src/features/tv/domain/entities/tv.dart';
import 'package:ditonton/src/features/tv/domain/usecases/get_top_rated_tv_series.dart';

part 'top_rated_tv_event.dart';
part 'top_rated_tv_state.dart';

class TopRatedTvBloc extends Bloc<TopRatedTvEvent, TopRatedTvState> {
  final GetTopRatedTvSeries usecase;
  TopRatedTvBloc(this.usecase) : super(TopRatedTvInitial()) {
    on<TopRatedTvDataLoaded>((event, emit) async {
      emit(TopRatedTvInProgress());

      final resp = await usecase.execute();

      emit(resp.fold(
        (l) => TopRatedTvFailure(message: l.message),
        (r) => TopRatedTvSuccess(data: r),
      ));
    });
  }
}
