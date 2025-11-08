part of 'recommendation_tv_bloc.dart';

class RecommendationTvEvent {}

class RecommendationTvDataLoaded extends RecommendationTvEvent {
  final int id;

  RecommendationTvDataLoaded({required this.id});
}
