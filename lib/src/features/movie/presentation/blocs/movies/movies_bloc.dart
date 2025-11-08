import 'package:bloc/bloc.dart';
import 'package:ditonton/src/features/movie/domain/entities/movie.dart';
import 'package:ditonton/src/features/movie/domain/entities/movie_detail.dart';
import 'package:ditonton/src/features/movie/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/src/features/movie/domain/usecases/search_movies.dart';

part 'movies_event.dart';
part 'movies_state.dart';

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  final GetMovieDetail movieDetail;
  final SearchMovies searchMovies;
  MoviesBloc(this.movieDetail, this.searchMovies) : super(MoviesInitial()) {
    on<MoviesDataSearched>((event, emit) async {
      emit(MoviesInProgress());
      final resp = await searchMovies.execute(event.query);
      emit(resp.fold(
        (l) => MoviesFailure(message: l.message),
        (r) => MoviesSuccess(data: r),
      ));
    });

    on<MoviesDataSingleLoaded>((event, emit) async {
      emit(MoviesSingleInProgress());
      final resp = await movieDetail.execute(event.id);
      emit(resp.fold(
        (l) => MoviesSingleFailure(message: l.message),
        (r) => MoviesSingleSuccess(data: r),
      ));
    });
  }
}
