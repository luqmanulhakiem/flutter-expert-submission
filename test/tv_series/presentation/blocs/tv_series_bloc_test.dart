import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/src/features/movie/data/datasources/db/database_helper.dart';
import 'package:ditonton/src/features/tv/data/datasources/tv_series_local_data_source.dart';
import 'package:ditonton/src/features/tv/data/datasources/tv_series_remote_data_source.dart';
import 'package:ditonton/src/features/tv/data/repositories/tv_series_repository_impl.dart';
import 'package:ditonton/src/features/tv/domain/usecases/get_detail_tv_series.dart';
import 'package:ditonton/src/features/tv/domain/usecases/search_tv_series.dart';
import 'package:ditonton/src/features/tv/presentation/blocs/tv_series/tv_series_bloc.dart';
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
  late TvSeriesBloc bloc;
  late SearchTvSeries searchTvSeries;
  late GetDetailTvSeries getDetailTvSeries;

  setUp(() {
    client = MockHttpClient();
    databaseHelper = DatabaseHelper();
    remoteDataSource = TvSeriesRemoteDataSourceImpl(client: client);
    localDataSource =
        TvSeriesLocalDataSourceImpl(databaseHelper: databaseHelper);
    repositoryImpl = TvSeriesRepositoryImpl(
        remoteDataSource: remoteDataSource, localDataSource: localDataSource);
    searchTvSeries = SearchTvSeries(repositoryImpl);
    getDetailTvSeries = GetDetailTvSeries(repositoryImpl);

    bloc = TvSeriesBloc(searchTvSeries, getDetailTvSeries);
  });

  group("Search Tv", () {
    final baseURL =
        "https://api.themoviedb.org/3/search/tv?api_key=2174d146bb9c0eab47529b2e77d6b526&query=Spiderman";
    blocTest<TvSeriesBloc, TvSeriesState>(
      'emits [TvSeriesInProgress, TvSeriesInProgress] when MoviesDataSearched is added.',
      build: () => bloc,
      setUp: () async {
        return mc.when(client.get(Uri.parse(baseURL))).thenAnswer((_) async =>
            Response(readJson("tv_series/dummy_data/search_spiderman_tv.json"),
                200));
      },
      act: (bloc) => bloc.add(TvSeriesDataSearched(query: "Spiderman")),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        isA<TvSeriesInProgress>(),
        isA<TvSeriesSuccess>(),
      ],
    );
    blocTest<TvSeriesBloc, TvSeriesState>(
      'emits [TvSeriesInProgress, TvSeriesFailure] when TvSeriesDataSearched is added.',
      build: () => bloc,
      setUp: () async {
        return mc
            .when(client.get(Uri.parse(baseURL)))
            .thenAnswer((_) async => Response("Not Found", 400));
      },
      act: (bloc) => bloc.add(TvSeriesDataSearched(query: "Spiderman")),
      expect: () => [
        isA<TvSeriesInProgress>(),
        isA<TvSeriesFailure>(),
      ],
    );
  });

  group("Detail Tv", () {
    final baseURL =
        "https://api.themoviedb.org/3/tv/1?api_key=2174d146bb9c0eab47529b2e77d6b526";

    blocTest<TvSeriesBloc, TvSeriesState>(
      'emits [TvSeriesSingleInProgress, TvSeriesSingleSuccess] when TvSeriesDataSingleLoaded is added.',
      build: () => bloc,
      setUp: () async {
        return mc.when(client.get(Uri.parse(baseURL))).thenAnswer((_) async =>
            Response(readJson("tv_series/dummy_data/tv_detail.json"), 200));
      },
      act: (bloc) => bloc.add(TvSeriesDataSingleLoaded(id: 1)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        isA<TvSeriesSingleInProgress>(),
        isA<TvSeriesSingleSuccess>(),
      ],
    );
    blocTest<TvSeriesBloc, TvSeriesState>(
      'emits [TvSeriesSingleInProgress, TvSeriesSingleFailure] when TvSeriesDataSingleLoaded is added.',
      build: () => bloc,
      setUp: () async {
        return mc
            .when(client.get(Uri.parse(baseURL)))
            .thenAnswer((_) async => Response("Not Found", 400));
      },
      act: (bloc) => bloc.add(TvSeriesDataSingleLoaded(id: 1)),
      expect: () => [
        isA<TvSeriesSingleInProgress>(),
        isA<TvSeriesSingleFailure>(),
      ],
    );
  });
}
