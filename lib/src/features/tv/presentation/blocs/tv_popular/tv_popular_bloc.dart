import 'package:bloc/bloc.dart';
import 'package:ditonton/src/features/tv/domain/entities/tv.dart';
import 'package:ditonton/src/features/tv/domain/usecases/get_popular_tv_series.dart';

part 'tv_popular_event.dart';
part 'tv_popular_state.dart';

class TvPopularBloc extends Bloc<TvPopularEvent, TvPopularState> {
  final GetPopularTvSeries usecase;
  TvPopularBloc(this.usecase) : super(TvPopularInitial()) {
    on<TvPopulaDataLoaded>((event, emit) async {
      emit(TvPopularInProgress());

      final resp = await usecase.execute();

      emit(resp.fold(
        (l) => TvPopularFailure(message: l.message),
        (r) => TvPopularSuccess(data: r),
      ));
    });
  }
}
