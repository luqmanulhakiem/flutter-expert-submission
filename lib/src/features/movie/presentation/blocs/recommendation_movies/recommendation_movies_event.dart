part of 'recommendation_movies_bloc.dart';

class RecommendationMoviesEvent {}

class RecommendationMoviesDataLoaded extends RecommendationMoviesEvent {
  final int id;

  RecommendationMoviesDataLoaded({required this.id});
}
