import 'package:ditonton/src/features/movie/presentation/blocs/recommendation_movies/recommendation_movies_bloc.dart';

class GetMovieRecommendations {
  final RecommendationMoviesBloc bloc;

  GetMovieRecommendations(this.bloc);

  Future<void> execute(id) async {
    bloc.add(RecommendationMoviesDataLoaded(id: id));
  }
}
