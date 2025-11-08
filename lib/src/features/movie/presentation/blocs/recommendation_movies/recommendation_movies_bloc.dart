import 'package:bloc/bloc.dart';
import 'package:ditonton/src/features/movie/domain/entities/movie.dart';
import 'package:ditonton/src/features/movie/domain/repositories/movie_repository.dart';

part 'recommendation_movies_event.dart';
part 'recommendation_movies_state.dart';

class RecommendationMoviesBloc
    extends Bloc<RecommendationMoviesEvent, RecommendationMoviesState> {
  final MovieRepository repository;
  RecommendationMoviesBloc(this.repository)
      : super(RecommendationMoviesInitial()) {
    on<RecommendationMoviesDataLoaded>((event, emit) async {
      emit(RecommendationMoviesInProgress());
      final resp = await repository.getMovieRecommendations(event.id);
      emit(resp.fold(
        (l) => RecommendationMoviesFailure(message: l.message),
        (r) => RecommendationMoviesSuccess(data: r),
      ));
    });
  }
}
