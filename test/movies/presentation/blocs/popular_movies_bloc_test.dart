import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/src/features/movie/data/datasources/db/database_helper.dart';
import 'package:ditonton/src/features/movie/data/datasources/movie_local_data_source.dart';
import 'package:ditonton/src/features/movie/data/datasources/movie_remote_data_source.dart';
import 'package:ditonton/src/features/movie/data/repositories/movie_repository_impl.dart';
import 'package:ditonton/src/features/movie/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/src/features/movie/presentation/blocs/popular_movies/popular_movies_bloc.dart';
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
  late PopularMoviesBloc bloc;
  late GetPopularMovies getPopularMovies;
  final baseURL =
      "https://api.themoviedb.org/3/movie/popular?api_key=2174d146bb9c0eab47529b2e77d6b526";

  setUp(() {
    client = MockHttpClient();
    databaseHelper = DatabaseHelper();
    remoteDataSource = MovieRemoteDataSourceImpl(client: client);
    localDataSource = MovieLocalDataSourceImpl(databaseHelper: databaseHelper);
    repositoryImpl = MovieRepositoryImpl(
        remoteDataSource: remoteDataSource, localDataSource: localDataSource);
    getPopularMovies = GetPopularMovies(repositoryImpl);
    bloc = PopularMoviesBloc(getPopularMovies);
  });

  group("Popular Movies Bloc Test Data", () {
    blocTest<PopularMoviesBloc, PopularMoviesState>(
      'emits [PopularMoviesInProgress, PopularMoviesSuccess] when MyEvent is added.',
      build: () => bloc,
      setUp: () async {
        return mc.when(client.get(Uri.parse(baseURL))).thenAnswer((_) async =>
            Response(readJson("movies/dummy_data/popular.json"), 200));
      },
      act: (bloc) => bloc.add(PopularMoviesDataLoaded()),
      expect: () => [
        isA<PopularMoviesInProgress>(),
        isA<PopularMoviesSuccess>(),
      ],
    );
    blocTest<PopularMoviesBloc, PopularMoviesState>(
      'emits [PopularMoviesInProgress, PopularMoviesFailure] when MyEvent is added.',
      build: () => bloc,
      setUp: () async {
        return mc
            .when(client.get(Uri.parse(baseURL)))
            .thenAnswer((_) async => Response("Not Found", 400));
      },
      act: (bloc) => bloc.add(PopularMoviesDataLoaded()),
      expect: () => [
        isA<PopularMoviesInProgress>(),
        isA<PopularMoviesFailure>(),
      ],
    );
  });
}
