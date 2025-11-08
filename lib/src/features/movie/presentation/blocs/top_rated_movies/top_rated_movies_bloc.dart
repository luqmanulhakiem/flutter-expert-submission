import 'package:bloc/bloc.dart';
import 'package:ditonton/src/features/movie/domain/entities/movie.dart';
import 'package:ditonton/src/features/movie/domain/repositories/movie_repository.dart';

part 'top_rated_movies_event.dart';
part 'top_rated_movies_state.dart';

class TopRatedMoviesBloc
    extends Bloc<TopRatedMoviesEvent, TopRatedMoviesState> {
  final MovieRepository repository;
  TopRatedMoviesBloc(this.repository) : super(TopRatedMoviesInitial()) {
    on<TopRatedMoviesDataLoaded>((event, emit) async {
      emit(TopRatedMoviesInProgress());

      final resp = await repository.getTopRatedMovies();

      emit(resp.fold(
        (l) => TopRatedMoviesFailure(message: l.message),
        (r) => TopRatedMoviesSuccess(data: r),
      ));
    });
  }
}
