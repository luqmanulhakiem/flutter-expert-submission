import 'package:bloc/bloc.dart';
import 'package:ditonton/src/features/movie/domain/entities/movie.dart';
import 'package:ditonton/src/features/movie/domain/usecases/get_popular_movies.dart';

part 'popular_movies_event.dart';
part 'popular_movies_state.dart';

class PopularMoviesBloc extends Bloc<PopularMoviesEvent, PopularMoviesState> {
  final GetPopularMovies getPopularMovies;

  PopularMoviesBloc(this.getPopularMovies) : super(PopularMoviesInitial()) {
    on<PopularMoviesDataLoaded>((event, emit) async {
      emit(PopularMoviesInProgress());

      final resp = await getPopularMovies.execute();

      emit(resp.fold(
        (l) => PopularMoviesFailure(message: l.message),
        (r) => PopularMoviesSuccess(data: r),
      ));
    });
  }
}
