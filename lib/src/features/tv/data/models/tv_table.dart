import 'package:ditonton/src/features/tv/domain/entities/tv.dart';
import 'package:ditonton/src/features/tv/domain/entities/tv_detail.dart';
import 'package:equatable/equatable.dart';

class TvTable extends Equatable {
  TvTable({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.overview,
    required this.type,
  });

  final int id;
  final String title;
  final String? posterPath;
  final String overview;
  final String type;

  factory TvTable.fromEntity(TvDetail tvSeries) => TvTable(
        id: tvSeries.id,
        title: tvSeries.title,
        posterPath: tvSeries.posterPath,
        overview: tvSeries.overview,
        type: 'tvSeries',
      );

  /// from Database
  factory TvTable.fromJson(Map<String, dynamic> map) => TvTable(
        id: map['id'],
        title: map['title'],
        posterPath: map['posterPath'],
        overview: map['overview'],
        type: 'tvSeries',
      );

  /// used by [DatabaseHelper]
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'posterPath': posterPath,
        'overview': overview,
        'type': 'tvSeries',
      };

  Tv toEntity() => Tv.watchlist(
        id: id,
        posterPath: posterPath,
        overview: overview,
        title: title,
        type: 'tvSeries',
      );

  @override
  List<Object?> get props => [
        id,
        title,
        posterPath,
        overview,
        type,
      ];
}
