import 'package:ditonton/src/features/tv/presentation/blocs/tv_series/tv_series_bloc.dart';

class SearchTvSeries {
  final TvSeriesBloc bloc;

  SearchTvSeries(this.bloc);

  Future<void> execute(String query) async {
    bloc.add(TvSeriesDataSearched(query: query));
  }
}
