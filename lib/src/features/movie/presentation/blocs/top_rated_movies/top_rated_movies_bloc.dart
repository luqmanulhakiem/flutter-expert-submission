import 'package:bloc/bloc.dart';
import 'package:ditonton/src/features/movie/domain/entities/movie.dart';
import 'package:ditonton/src/features/movie/domain/usecases/get_top_rated_movies.dart';

part 'top_rated_movies_event.dart';
part 'top_rated_movies_state.dart';

class TopRatedMoviesBloc
    extends Bloc<TopRatedMoviesEvent, TopRatedMoviesState> {
  final GetTopRatedMovies usecase;
  TopRatedMoviesBloc(this.usecase) : super(TopRatedMoviesInitial()) {
    on<TopRatedMoviesDataLoaded>((event, emit) async {
      emit(TopRatedMoviesInProgress());

      final resp = await usecase.execute();

      emit(resp.fold(
        (l) => TopRatedMoviesFailure(message: l.message),
        (r) => TopRatedMoviesSuccess(data: r),
      ));
    });
  }
}
