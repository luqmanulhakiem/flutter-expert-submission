import 'package:bloc/bloc.dart';
import 'package:ditonton/src/features/movie/domain/entities/movie.dart';
import 'package:ditonton/src/features/movie/domain/repositories/movie_repository.dart';

part 'popular_movies_event.dart';
part 'popular_movies_state.dart';

class PopularMoviesBloc extends Bloc<PopularMoviesEvent, PopularMoviesState> {
  final MovieRepository repository;
  PopularMoviesBloc(this.repository) : super(PopularMoviesInitial()) {
    on<PopularMoviesDataLoaded>((event, emit) async {
      emit(PopularMoviesInProgress());

      final resp = await repository.getPopularMovies();

      emit(resp.fold(
        (l) => PopularMoviesFailure(message: l.message),
        (r) => PopularMoviesSuccess(data: r),
      ));
    });
  }
}
