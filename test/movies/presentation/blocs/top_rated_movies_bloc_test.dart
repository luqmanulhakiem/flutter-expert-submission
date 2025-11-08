import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/src/features/movie/data/datasources/db/database_helper.dart';
import 'package:ditonton/src/features/movie/data/datasources/movie_local_data_source.dart';
import 'package:ditonton/src/features/movie/data/datasources/movie_remote_data_source.dart';
import 'package:ditonton/src/features/movie/data/repositories/movie_repository_impl.dart';
import 'package:ditonton/src/features/movie/presentation/blocs/top_rated_movies/top_rated_movies_bloc.dart';
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
  late TopRatedMoviesBloc bloc;
  final baseURL =
      "https://api.themoviedb.org/3/movie/top_rated?api_key=2174d146bb9c0eab47529b2e77d6b526";

  setUp(() {
    client = MockHttpClient();
    databaseHelper = DatabaseHelper();
    remoteDataSource = MovieRemoteDataSourceImpl(client: client);
    localDataSource = MovieLocalDataSourceImpl(databaseHelper: databaseHelper);
    repositoryImpl = MovieRepositoryImpl(
        remoteDataSource: remoteDataSource, localDataSource: localDataSource);
    bloc = TopRatedMoviesBloc(repositoryImpl);
  });

  group("TopRated Movies Bloc Test Data", () {
    blocTest<TopRatedMoviesBloc, TopRatedMoviesState>(
      'emits [TopRatedMoviesInProgress, TopRatedMoviesSuccess] when MyEvent is added.',
      build: () => bloc,
      setUp: () async {
        return mc.when(client.get(Uri.parse(baseURL))).thenAnswer((_) async =>
            Response(readJson("movies/dummy_data/top_rated.json"), 200));
      },
      act: (bloc) => bloc.add(TopRatedMoviesDataLoaded()),
      expect: () => [
        isA<TopRatedMoviesInProgress>(),
        isA<TopRatedMoviesSuccess>(),
      ],
    );
    blocTest<TopRatedMoviesBloc, TopRatedMoviesState>(
      'emits [TopRatedMoviesInProgress, TopRatedMoviesFailure] when MyEvent is added.',
      build: () => bloc,
      setUp: () async {
        return mc
            .when(client.get(Uri.parse(baseURL)))
            .thenAnswer((_) async => Response("Not Found", 400));
      },
      act: (bloc) => bloc.add(TopRatedMoviesDataLoaded()),
      expect: () => [
        isA<TopRatedMoviesInProgress>(),
        isA<TopRatedMoviesFailure>(),
      ],
    );
  });
}
