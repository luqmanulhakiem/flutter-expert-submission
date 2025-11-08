part of 'recommendation_tv_bloc.dart';

class RecommendationTvState {}

class RecommendationTvInitial extends RecommendationTvState {}

class RecommendationTvInProgress extends RecommendationTvState {}

class RecommendationTvSuccess extends RecommendationTvState {
  final List<Tv> data;

  RecommendationTvSuccess({required this.data});
}

class RecommendationTvFailure extends RecommendationTvState {
  final String message;

  RecommendationTvFailure({required this.message});
}
