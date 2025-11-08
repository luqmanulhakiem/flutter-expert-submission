import 'package:bloc/bloc.dart';
import 'package:ditonton/src/features/movie/domain/entities/movie.dart';
import 'package:ditonton/src/features/movie/domain/usecases/get_now_playing_movies.dart';

part 'now_playing_movies_event.dart';
part 'now_playing_movies_state.dart';

class NowPlayingMoviesBloc
    extends Bloc<NowPlayingMoviesEvent, NowPlayingMoviesState> {
  final GetNowPlayingMovies getNowPlayingMovies;
  NowPlayingMoviesBloc(this.getNowPlayingMovies)
      : super(NowPlayingMoviesInitial()) {
    on<NowPlayingMoviesDataLoaded>((event, emit) async {
      emit(NowPlayingMoviesInProgress());
      final resp = await getNowPlayingMovies.execute();

      emit(resp.fold(
        (l) => NowPlayingMoviesFailure(message: l.message),
        (r) => NowPlayingMoviesSuccess(data: r),
      ));
    });
  }
}
