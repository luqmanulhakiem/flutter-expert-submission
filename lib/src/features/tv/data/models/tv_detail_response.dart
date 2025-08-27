import 'package:ditonton/src/features/tv/data/models/seasons_model.dart';
import 'package:ditonton/src/features/tv/domain/entities/tv_detail.dart';
import 'package:ditonton/src/shared/data/models/genre_model.dart';
import 'package:equatable/equatable.dart';

class TvDetailResponse extends Equatable {
  TvDetailResponse({
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
    required this.tagline,
    required this.voteAverage,
    required this.runtime,
    required this.voteCount,
    required this.type,
  });

  final String? backdropPath;
  final String? firstAirDate;
  final String lastAirDate;
  final List<GenreModel> genres;
  final int id;
  final String title;
  final int numberOfEpisodes;
  final int numberOfSeasons;
  final String overview;
  final String? posterPath;
  final List<SeasonsModel> seasons;
  final String tagline;
  final double voteAverage;
  final int runtime;
  final int voteCount;
  final String type;

  factory TvDetailResponse.fromJson(Map<String, dynamic> json) {
    return TvDetailResponse(
      backdropPath: json['backdrop_path'],
      firstAirDate: json['first_air_date'],
      lastAirDate: json['last_air_date'],
      genres: List<GenreModel>.from(
          json['genres'].map((x) => GenreModel.fromJson(x))),
      id: json['id'],
      title: json['name'],
      numberOfEpisodes: json['number_of_episodes'],
      numberOfSeasons: json['number_of_seasons'],
      overview: json['overview'],
      posterPath: json['poster_path'],
      runtime: json['runtime'] ?? 0,
      seasons: List<SeasonsModel>.from(
          json['seasons'].map((x) => SeasonsModel.fromJson(x))),
      tagline: json['tagline'],
      voteAverage: double.parse(json['vote_average'].toStringAsFixed(2)),
      voteCount: json['vote_count'],
      type: 'tvSeries',
    );
  }

  // Map<String, dynamic> toJson() => {
  //       "adult": adult,
  //       "backdrop_path": backdropPath,
  //       "genres": List<dynamic>.from(genres.map((x) => x.toJson())),
  //       "homepage": homepage,
  //       "id": id,
  //       "original_language": originalLanguage,
  //       "original_name": originalName,
  //       "overview": overview,
  //       "popularity": popularity,
  //       "poster_path": posterPath,
  //       "first_air_date": firstAirDate,
  //       "runtime": runtime,
  //       "status": status,
  //       "tagline": tagline,
  //       "name": name,
  //       "vote_average": voteAverage,
  //       "vote_count": voteCount,
  //     };

  TvDetail toEntity() {
    return TvDetail(
      runtime: runtime,
      backdropPath: backdropPath,
      firstAirDate: firstAirDate,
      lastAirDate: lastAirDate,
      genres: genres.map((x) => x.toEntity()).toList(),
      id: id,
      title: title,
      numberOfEpisodes: numberOfEpisodes,
      numberOfSeasons: numberOfSeasons,
      overview: overview,
      posterPath: posterPath,
      seasons: seasons.map((x) => x.toEntity()).toList(),
      tagline: tagline,
      voteAverage: voteAverage,
      voteCount: voteCount,
      type: 'tvSeries',
    );
  }

  @override
  List<Object?> get props => [
        backdropPath,
        firstAirDate,
        lastAirDate,
        genres,
        runtime,
        id,
        title,
        numberOfEpisodes,
        numberOfSeasons,
        overview,
        posterPath,
        seasons,
        tagline,
        voteAverage,
        voteCount,
        type,
      ];
}
