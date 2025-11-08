import 'package:ditonton/src/features/tv/presentation/blocs/tv_series/tv_series_bloc.dart';

class GetDetailTvSeries {
  final TvSeriesBloc bloc;

  GetDetailTvSeries(this.bloc);

  Future<void> execute(int id) async {
    bloc.add(TvSeriesDataSingleLoaded(id: id));
  }
}
