import 'package:ditonton/src/features/tv/presentation/blocs/recommendation_tv/recommendation_tv_bloc.dart';

class GetRecommendationsTvSeries {
  final RecommendationTvBloc bloc;

  GetRecommendationsTvSeries(this.bloc);

  Future<void> execute(id) async {
    bloc.add(RecommendationTvDataLoaded(id: id));
  }
}
