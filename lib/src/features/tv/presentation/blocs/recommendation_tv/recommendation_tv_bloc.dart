import 'package:bloc/bloc.dart';
import 'package:ditonton/src/features/tv/domain/entities/tv.dart';
import 'package:ditonton/src/features/tv/domain/usecases/get_recommendations_tv_series.dart';

part 'recommendation_tv_event.dart';
part 'recommendation_tv_state.dart';

class RecommendationTvBloc
    extends Bloc<RecommendationTvEvent, RecommendationTvState> {
  final GetRecommendationsTvSeries usecase;
  RecommendationTvBloc(this.usecase) : super(RecommendationTvInitial()) {
    on<RecommendationTvDataLoaded>((event, emit) async {
      emit(RecommendationTvInProgress());
      final resp = await usecase.execute(event.id);
      emit(resp.fold(
        (l) => RecommendationTvFailure(message: l.message),
        (r) => RecommendationTvSuccess(data: r),
      ));
    });
  }
}
