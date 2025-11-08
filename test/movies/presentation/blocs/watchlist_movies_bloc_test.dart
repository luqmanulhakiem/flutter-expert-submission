import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/src/features/movie/data/datasources/movie_local_data_source.dart';
import 'package:ditonton/src/features/movie/data/datasources/movie_remote_data_source.dart';
import 'package:ditonton/src/features/movie/data/models/movie_table.dart';
import 'package:ditonton/src/features/movie/data/repositories/movie_repository_impl.dart';
import 'package:ditonton/src/features/movie/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/src/features/movie/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/src/features/movie/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/src/features/movie/domain/usecases/save_watchlist.dart';
import 'package:ditonton/src/features/movie/presentation/blocs/watchlist_movies/watchlist_movies_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart' as mc;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

class MockMovieLocalDataSource extends mc.Mock
    implements MovieLocalDataSource {}

void main() {
  late MovieRemoteDataSource remoteDataSource;
  late MovieLocalDataSource localDataSource;
  late Client client;
  late MovieRepositoryImpl repositoryImpl;
  late WatchlistMoviesBloc bloc;
  late GetWatchListStatus getWatchListStatus;
  late GetWatchlistMovies getWatchlistMovies;
  late SaveWatchlist saveWatchlist;
  late RemoveWatchlist removeWatchlist;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() {
    client = MockHttpClient();
    remoteDataSource = MovieRemoteDataSourceImpl(client: client);
    localDataSource = MockMovieLocalDataSource();
    repositoryImpl = MovieRepositoryImpl(
        remoteDataSource: remoteDataSource, localDataSource: localDataSource);
    getWatchlistMovies = GetWatchlistMovies(repositoryImpl);
    getWatchListStatus = GetWatchListStatus(repositoryImpl);
    saveWatchlist = SaveWatchlist(repositoryImpl);
    removeWatchlist = RemoveWatchlist(repositoryImpl);

    bloc = WatchlistMoviesBloc(
        getWatchListStatus, getWatchlistMovies, saveWatchlist, removeWatchlist);
  });

  blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
    'Get Watchlist Movies Success',
    build: () => bloc,
    setUp: () async {
      final testMovieTableList = [MovieTable.fromEntity(testMovieDetail)];
      return mc
          .when(() => localDataSource.getWatchlistMovies())
          .thenAnswer((_) async => testMovieTableList);
    },
    act: (bloc) => bloc.add(WatchlistMoviesDataLoaded()),
    expect: () => [
      isA<WatchlistMoviesDataInProgress>(),
      isA<WatchlistMoviesDataSuccess>(),
    ],
  );

  group("Store Movie to Watchlist", () {
    blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
      'Get Watchlist Movies Success',
      build: () => bloc,
      setUp: () async {
        return mc
            .when(() => localDataSource.insertWatchlist(testMovieTable))
            .thenAnswer((_) async => "Success");
      },
      act: (bloc) => bloc.add(WatchlistMoviesDataStored(data: testMovieDetail)),
      expect: () => [
        isA<WatchlistMoviesActionInProgress>(),
        isA<WatchlistMoviesActionSuccess>(),
        isA<WatchlistMoviesInProgress>(),
        isA<WatchlistMoviesFailure>(),
      ],
    );
  });

  group("Remove Movie to Watchlist", () {
    blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
      'Get Watchlist Movies Success',
      build: () => bloc,
      setUp: () async {
        return mc
            .when(() => localDataSource.removeWatchlist(testMovieTable))
            .thenAnswer((_) async => "Success");
      },
      act: (bloc) =>
          bloc.add(WatchlistMoviesDataRemoved(data: testMovieDetail)),
      expect: () => [
        isA<WatchlistMoviesActionInProgress>(),
        isA<WatchlistMoviesActionSuccess>(),
        isA<WatchlistMoviesInProgress>(),
        isA<WatchlistMoviesFailure>(),
      ],
    );
  });
}
