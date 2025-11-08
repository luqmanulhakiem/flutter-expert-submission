import 'package:bloc/bloc.dart';
import 'package:ditonton/src/features/movie/domain/entities/movie.dart';
import 'package:ditonton/src/features/movie/domain/repositories/movie_repository.dart';

part 'movies_event.dart';
part 'movies_state.dart';

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  final MovieRepository repository;
  MoviesBloc(this.repository) : super(MoviesInitial()) {
    on<MoviesDataSearched>((event, emit) async {
      emit(MoviesInProgress());
      final resp = await repository.searchMovies(event.query);
      emit(resp.fold(
        (l) => MoviesFailure(message: l.message),
        (r) => MoviesSuccess(data: r),
      ));
    });
  }
}
