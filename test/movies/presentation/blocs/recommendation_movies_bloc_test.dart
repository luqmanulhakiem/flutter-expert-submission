import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/src/features/movie/data/datasources/db/database_helper.dart';
import 'package:ditonton/src/features/movie/data/datasources/movie_local_data_source.dart';
import 'package:ditonton/src/features/movie/data/datasources/movie_remote_data_source.dart';
import 'package:ditonton/src/features/movie/data/repositories/movie_repository_impl.dart';
import 'package:ditonton/src/features/movie/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/src/features/movie/presentation/blocs/recommendation_movies/recommendation_movies_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart' as mc;

import '../../../json_reader.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MovieRemoteDataSource remoteDataSource;
  late MovieLocalDataSource localDataSource;
  late Client client;
  late DatabaseHelper databaseHelper;
  late MovieRepositoryImpl repositoryImpl;
  late GetMovieRecommendations getMovieRecommendations;
  late RecommendationMoviesBloc bloc;
  final baseURL =
      "https://api.themoviedb.org/3/movie/1/recommendations?api_key=2174d146bb9c0eab47529b2e77d6b526";
  setUp(() {
    client = MockHttpClient();
    databaseHelper = DatabaseHelper();
    remoteDataSource = MovieRemoteDataSourceImpl(client: client);
    localDataSource = MovieLocalDataSourceImpl(databaseHelper: databaseHelper);
    repositoryImpl = MovieRepositoryImpl(
        remoteDataSource: remoteDataSource, localDataSource: localDataSource);
    getMovieRecommendations = GetMovieRecommendations(repositoryImpl);
    bloc = RecommendationMoviesBloc(getMovieRecommendations);
  });

  group("Get Recommendations Movies", () {
    blocTest<RecommendationMoviesBloc, RecommendationMoviesState>(
      'emits [RecommendationMoviesInProgress, RecommendationMoviesSuccess] when MoviesDataSearched is added.',
      build: () => bloc,
      setUp: () async {
        return mc.when(client.get(Uri.parse(baseURL))).thenAnswer((_) async =>
            Response(
                readJson("movies/dummy_data/movie_recommendations.json"), 200));
      },
      act: (bloc) => bloc.add(RecommendationMoviesDataLoaded(id: 1)),
      expect: () => [
        isA<RecommendationMoviesInProgress>(),
        isA<RecommendationMoviesSuccess>(),
      ],
    );
    blocTest<RecommendationMoviesBloc, RecommendationMoviesState>(
      'emits [RecommendationMoviesInProgress, RecommendationMoviesFailure] when MoviesDataSearched is added.',
      build: () => bloc,
      setUp: () async {
        return mc
            .when(client.get(Uri.parse(baseURL)))
            .thenAnswer((_) async => Response("Not Found", 400));
      },
      act: (bloc) => bloc.add(RecommendationMoviesDataLoaded(id: 1)),
      expect: () => [
        isA<RecommendationMoviesInProgress>(),
        isA<RecommendationMoviesFailure>(),
      ],
    );
  });
}
