part of 'recommendation_movies_bloc.dart';

class RecommendationMoviesState {}

class RecommendationMoviesInitial extends RecommendationMoviesState {}

class RecommendationMoviesInProgress extends RecommendationMoviesState {}

class RecommendationMoviesSuccess extends RecommendationMoviesState {
  final List<Movie> data;

  RecommendationMoviesSuccess({required this.data});
}

class RecommendationMoviesFailure extends RecommendationMoviesState {
  final String message;

  RecommendationMoviesFailure({required this.message});
}
