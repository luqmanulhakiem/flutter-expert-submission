import 'package:ditonton/src/features/tv/data/models/tv_model.dart';
import 'package:ditonton/src/features/tv/data/models/tv_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tTvModel = TvModel(
    type: "tvSeries",
    backdropPath: "/path.jpg",
    genreIds: [1, 2, 3, 4],
    id: 1,
    originalName: "Original Name",
    overview: "Overview",
    popularity: 1.0,
    posterPath: "/path.jpg",
    firstAirDate: "2020-05-05",
    title: "Title",
    originCountry: [],
    originalLanguage: 'en',
    voteAverage: 1.0,
    voteCount: 1,
  );
  final tTvResponseModel = TvResponse(tvList: <TvModel>[tTvModel]);

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tTvResponseModel.toJson();
      // assert
      final expectedJsonMap = {
        "results": [
          {
            "backdrop_path": "/path.jpg",
            "genre_ids": [1, 2, 3, 4],
            "id": 1,
            "original_name": "Original Name",
            "overview": "Overview",
            "popularity": 1.0,
            "poster_path": "/path.jpg",
            "first_air_date": "2020-05-05",
            "title": "Title",
            "vote_average": 1.0,
            "vote_count": 1,
            'origin_country': [],
            'original_language': 'en',
            'type': 'tvSeries'
          }
        ],
      };
      expect(result, expectedJsonMap);
    });
  });
}
