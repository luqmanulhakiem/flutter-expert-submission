import 'package:ditonton/src/features/tv/presentation/blocs/tv_popular/tv_popular_bloc.dart';

class GetPopularTvSeries {
  final TvPopularBloc bloc;

  GetPopularTvSeries(this.bloc);

  Future<void> execute() async {
    bloc.add(TvPopulaDataLoaded());
  }
}
