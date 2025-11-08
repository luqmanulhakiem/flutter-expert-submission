import 'package:bloc/bloc.dart';
import 'package:ditonton/src/features/movie/domain/entities/movie.dart';
import 'package:ditonton/src/features/movie/domain/repositories/movie_repository.dart';

part 'now_playing_movies_event.dart';
part 'now_playing_movies_state.dart';

class NowPlayingMoviesBloc
    extends Bloc<NowPlayingMoviesEvent, NowPlayingMoviesState> {
  final MovieRepository repository;
  NowPlayingMoviesBloc(this.repository) : super(NowPlayingMoviesInitial()) {
    on<NowPlayingMoviesDataLoaded>((event, emit) async {
      emit(NowPlayingMoviesInProgress());
      final resp = await repository.getNowPlayingMovies();

      emit(resp.fold(
        (l) => NowPlayingMoviesFailure(message: l.message),
        (r) => NowPlayingMoviesSuccess(data: r),
      ));
    });
  }
}
