import 'package:bloc/bloc.dart';
import 'package:ditonton/src/features/tv/domain/entities/tv.dart';
import 'package:ditonton/src/features/tv/domain/repositories/tv_series_repository.dart';

part 'recommendation_tv_event.dart';
part 'recommendation_tv_state.dart';

class RecommendationTvBloc
    extends Bloc<RecommendationTvEvent, RecommendationTvState> {
  final TvSeriesRepository repository;
  RecommendationTvBloc(this.repository) : super(RecommendationTvInitial()) {
    on<RecommendationTvDataLoaded>((event, emit) async {
      emit(RecommendationTvInProgress());
      final resp = await repository.getTvSeriesRecommendations(event.id);
      emit(resp.fold(
        (l) => RecommendationTvFailure(message: l.message),
        (r) => RecommendationTvSuccess(data: r),
      ));
    });
  }
}
