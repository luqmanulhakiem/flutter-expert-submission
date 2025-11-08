import 'package:ditonton/src/features/tv/presentation/blocs/top_rated_tv/top_rated_tv_bloc.dart';

class GetTopRatedTvSeries {
  final TopRatedTvBloc bloc;

  GetTopRatedTvSeries(this.bloc);

  Future<void> execute() async {
    bloc.add(TopRatedTvDataLoaded());
  }
}
