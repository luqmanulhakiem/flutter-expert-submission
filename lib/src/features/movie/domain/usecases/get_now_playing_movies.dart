import 'package:ditonton/src/features/movie/presentation/blocs/now_playing_movies/now_playing_movies_bloc.dart';

class GetNowPlayingMovies {
  final NowPlayingMoviesBloc bloc;

  GetNowPlayingMovies(this.bloc);

  Future<void> execute() async {
    bloc.add(NowPlayingMoviesDataLoaded());
  }
}
