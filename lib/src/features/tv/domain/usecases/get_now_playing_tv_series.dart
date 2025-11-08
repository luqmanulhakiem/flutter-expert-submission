import 'package:ditonton/src/features/tv/presentation/blocs/now_playing_tv/now_playing_tv_bloc.dart';

class GetNowPlayingTvSeries {
  final NowPlayingTvBloc bloc;

  GetNowPlayingTvSeries(this.bloc);

  Future<void> execute() async {
    bloc.add(NowPlayingTvDataLoaded());
  }
}
