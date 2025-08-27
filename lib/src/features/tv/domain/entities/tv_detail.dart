import 'package:ditonton/src/features/tv/domain/entities/seasons.dart';
import 'package:ditonton/src/shared/domain/entities/genre.dart';
import 'package:equatable/equatable.dart';

class TvDetail extends Equatable {
  TvDetail({
    required this.backdropPath,
    required this.firstAirDate,
    required this.lastAirDate,
    required this.genres,
    required this.id,
    required this.title,
    required this.numberOfEpisodes,
    required this.numberOfSeasons,
    required this.overview,
    required this.posterPath,
    required this.seasons,
    required this.runtime,
    required this.tagline,
    required this.voteAverage,
    required this.voteCount,
    required this.type,
  });

  final String? backdropPath;
  final String? firstAirDate;
  final String lastAirDate;
  final List<Genre> genres;
  final int id;
  final String title;
  final int numberOfEpisodes;
  final int numberOfSeasons;
  final String overview;
  final String? posterPath;
  final List<Seasons> seasons;
  final String tagline;
  final double voteAverage;
  final int runtime;
  final int voteCount;
  final String type;

  @override
  List<Object?> get props => [
        backdropPath,
        firstAirDate,
        lastAirDate,
        genres,
        id,
        title,
        numberOfSeasons,
        numberOfEpisodes,
        overview,
        posterPath,
        seasons,
        tagline,
        runtime,
        voteAverage,
        voteCount,
        type,
      ];
}
