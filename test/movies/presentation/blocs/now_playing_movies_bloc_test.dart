import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/src/features/movie/data/datasources/db/database_helper.dart';
import 'package:ditonton/src/features/movie/data/datasources/movie_local_data_source.dart';
import 'package:ditonton/src/features/movie/data/datasources/movie_remote_data_source.dart';
import 'package:ditonton/src/features/movie/data/repositories/movie_repository_impl.dart';
import 'package:ditonton/src/features/movie/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/src/features/movie/presentation/blocs/now_playing_movies/now_playing_movies_bloc.dart';
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
  late NowPlayingMoviesBloc bloc;
  late GetNowPlayingMovies getNowPlayingMovies;
  final baseURL =
      "https://api.themoviedb.org/3/movie/now_playing?api_key=2174d146bb9c0eab47529b2e77d6b526";

  setUp(() {
    client = MockHttpClient();
    databaseHelper = DatabaseHelper();
    remoteDataSource = MovieRemoteDataSourceImpl(client: client);
    localDataSource = MovieLocalDataSourceImpl(databaseHelper: databaseHelper);
    repositoryImpl = MovieRepositoryImpl(
        remoteDataSource: remoteDataSource, localDataSource: localDataSource);
    getNowPlayingMovies = GetNowPlayingMovies(repositoryImpl);
    bloc = NowPlayingMoviesBloc(getNowPlayingMovies);
  });

  group("Popular Movies Bloc Test Data", () {
    blocTest<NowPlayingMoviesBloc, NowPlayingMoviesState>(
      'emits [NowPlayingMoviesInProgress, NowPlayingMoviesSuccess] when MyEvent is added.',
      build: () => bloc,
      setUp: () async {
        return mc.when(client.get(Uri.parse(baseURL))).thenAnswer((_) async =>
            Response(readJson("movies/dummy_data/now_playing.json"), 200));
      },
      act: (bloc) => bloc.add(NowPlayingMoviesDataLoaded()),
      expect: () => [
        isA<NowPlayingMoviesInProgress>(),
        isA<NowPlayingMoviesSuccess>(),
      ],
    );
    blocTest<NowPlayingMoviesBloc, NowPlayingMoviesState>(
      'emits [NowPlayingMoviesInProgress, NowPlayingMoviesFailure] when MyEvent is added.',
      build: () => bloc,
      setUp: () async {
        return mc
            .when(client.get(Uri.parse(baseURL)))
            .thenAnswer((_) async => Response("Not Found", 400));
      },
      act: (bloc) => bloc.add(NowPlayingMoviesDataLoaded()),
      expect: () => [
        isA<NowPlayingMoviesInProgress>(),
        isA<NowPlayingMoviesFailure>(),
      ],
    );
  });
}
