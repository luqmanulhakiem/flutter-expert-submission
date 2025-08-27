import 'package:ditonton/src/features/tv/data/models/tv_model.dart';
import 'package:ditonton/src/features/tv/domain/entities/tv.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tTvModel = TvModel(
    type: "movies",
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    firstAirDate: 'firstAirDate',
    title: 'title',
    originCountry: [],
    originalLanguage: 'en',
    voteAverage: 1,
    voteCount: 1,
  );

  final tTv = Tv(
    originCountry: [],
    originalLanguage: 'en',
    type: "movies",
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    firstAirDate: 'firstAirDate',
    title: 'title',
    voteAverage: 1,
    voteCount: 1,
  );

  test('should be a subclass of Movie entity', () async {
    final result = tTvModel.toEntity();
    expect(result, tTv);
  });
}
