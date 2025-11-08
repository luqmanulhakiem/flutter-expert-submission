import 'package:ditonton/src/features/movie/presentation/blocs/bloc/now_playing_movies_bloc.dart';

class GetNowPlayingMovies {
  final NowPlayingMoviesBloc bloc;

  GetNowPlayingMovies(this.bloc);

  Future<void> execute() async {
    bloc.add(NowPlayingMoviesDataLoaded());
  }
}
