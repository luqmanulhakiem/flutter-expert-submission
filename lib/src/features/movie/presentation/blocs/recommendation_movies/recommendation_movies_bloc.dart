import 'package:bloc/bloc.dart';
import 'package:ditonton/src/features/movie/domain/entities/movie.dart';
import 'package:ditonton/src/features/movie/domain/usecases/get_movie_recommendations.dart';

part 'recommendation_movies_event.dart';
part 'recommendation_movies_state.dart';

class RecommendationMoviesBloc
    extends Bloc<RecommendationMoviesEvent, RecommendationMoviesState> {
  final GetMovieRecommendations usecase;
  RecommendationMoviesBloc(this.usecase)
      : super(RecommendationMoviesInitial()) {
    on<RecommendationMoviesDataLoaded>((event, emit) async {
      emit(RecommendationMoviesInProgress());
      final resp = await usecase.execute(event.id);
      emit(resp.fold(
        (l) => RecommendationMoviesFailure(message: l.message),
        (r) => RecommendationMoviesSuccess(data: r),
      ));
    });
  }
}
