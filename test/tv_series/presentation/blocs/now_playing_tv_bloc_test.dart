import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/src/features/movie/data/datasources/db/database_helper.dart';
import 'package:ditonton/src/features/tv/data/datasources/tv_series_local_data_source.dart';
import 'package:ditonton/src/features/tv/data/datasources/tv_series_remote_data_source.dart';
import 'package:ditonton/src/features/tv/data/repositories/tv_series_repository_impl.dart';
import 'package:ditonton/src/features/tv/presentation/blocs/now_playing_tv/now_playing_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart' as mc;

import '../../../json_reader.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvSeriesRemoteDataSourceImpl remoteDataSource;
  late TvSeriesLocalDataSourceImpl localDataSource;
  late Client client;
  late DatabaseHelper databaseHelper;
  late TvSeriesRepositoryImpl repositoryImpl;
  late NowPlayingTvBloc bloc;
  final baseURL =
      "https://api.themoviedb.org/3/tv/on_the_air?api_key=2174d146bb9c0eab47529b2e77d6b526";

  setUp(() {
    client = MockHttpClient();
    databaseHelper = DatabaseHelper();
    remoteDataSource = TvSeriesRemoteDataSourceImpl(client: client);
    localDataSource =
        TvSeriesLocalDataSourceImpl(databaseHelper: databaseHelper);
    repositoryImpl = TvSeriesRepositoryImpl(
        remoteDataSource: remoteDataSource, localDataSource: localDataSource);
    bloc = NowPlayingTvBloc(repositoryImpl);
  });

  group("Popular Tv Bloc Test Data", () {
    blocTest<NowPlayingTvBloc, NowPlayingTvState>(
      'emits [NowPlayingTvInProgress, NowPlayingTvSuccess] when MyEvent is added.',
      build: () => bloc,
      setUp: () async {
        return mc.when(client.get(Uri.parse(baseURL))).thenAnswer((_) async =>
            Response(readJson("tv_series/dummy_data/now_playing.json"), 200));
      },
      act: (bloc) => bloc.add(NowPlayingTvDataLoaded()),
      expect: () => [
        isA<NowPlayingTvInProgress>(),
        isA<NowPlayingTvSuccess>(),
      ],
    );
    blocTest<NowPlayingTvBloc, NowPlayingTvState>(
      'emits [NowPlayingTvInProgress, NowPlayingTvFailure] when MyEvent is added.',
      build: () => bloc,
      setUp: () async {
        return mc
            .when(client.get(Uri.parse(baseURL)))
            .thenAnswer((_) async => Response("Not Found", 400));
      },
      act: (bloc) => bloc.add(NowPlayingTvDataLoaded()),
      expect: () => [
        isA<NowPlayingTvInProgress>(),
        isA<NowPlayingTvFailure>(),
      ],
    );
  });
}
