import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/src/features/movie/data/datasources/db/database_helper.dart';
import 'package:ditonton/src/features/movie/data/datasources/movie_local_data_source.dart';
import 'package:ditonton/src/features/movie/data/datasources/movie_remote_data_source.dart';
import 'package:ditonton/src/features/movie/data/repositories/movie_repository_impl.dart';
import 'package:ditonton/src/features/movie/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/src/features/movie/domain/usecases/search_movies.dart';
import 'package:ditonton/src/features/movie/presentation/blocs/movies/movies_bloc.dart';
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
  late MoviesBloc bloc;
  late GetMovieDetail getMovieDetail;
  late SearchMovies searchMovies;

  setUp(() {
    client = MockHttpClient();
    databaseHelper = DatabaseHelper();
    remoteDataSource = MovieRemoteDataSourceImpl(client: client);
    localDataSource = MovieLocalDataSourceImpl(databaseHelper: databaseHelper);
    repositoryImpl = MovieRepositoryImpl(
        remoteDataSource: remoteDataSource, localDataSource: localDataSource);
    getMovieDetail = GetMovieDetail(repositoryImpl);
    searchMovies = SearchMovies(repositoryImpl);
    bloc = MoviesBloc(getMovieDetail, searchMovies);
  });

  group("Search Movie", () {
    final baseURL =
        "https://api.themoviedb.org/3/search/movie?api_key=2174d146bb9c0eab47529b2e77d6b526&query=Spiderman";
    blocTest<MoviesBloc, MoviesState>(
      'emits [MoviesInProgress, MoviesSuccess] when MoviesDataSearched is added.',
      build: () => bloc,
      setUp: () async {
        return mc.when(client.get(Uri.parse(baseURL))).thenAnswer((_) async =>
            Response(readJson("movies/dummy_data/search_spiderman_movie.json"),
                200));
      },
      act: (bloc) => bloc.add(MoviesDataSearched(query: "Spiderman")),
      expect: () => [
        isA<MoviesInProgress>(),
        isA<MoviesSuccess>(),
      ],
    );
    blocTest<MoviesBloc, MoviesState>(
      'emits [MoviesInProgress, MoviesFailure] when MoviesDataSearched is added.',
      build: () => bloc,
      setUp: () async {
        return mc
            .when(client.get(Uri.parse(baseURL)))
            .thenAnswer((_) async => Response("Not Found", 400));
      },
      act: (bloc) => bloc.add(MoviesDataSearched(query: "Spiderman")),
      expect: () => [
        isA<MoviesInProgress>(),
        isA<MoviesFailure>(),
      ],
    );
  });

  group("Detail Movie", () {
    final baseURL =
        "https://api.themoviedb.org/3/movie/1?api_key=2174d146bb9c0eab47529b2e77d6b526";

    blocTest<MoviesBloc, MoviesState>(
      'emits [MoviesSingleInProgress, MoviesSingleSuccess] when MoviesDataSingleLoaded is added.',
      build: () => bloc,
      setUp: () async {
        return mc.when(client.get(Uri.parse(baseURL))).thenAnswer((_) async =>
            Response(readJson("movies/dummy_data/movie_detail.json"), 200));
      },
      act: (bloc) => bloc.add(MoviesDataSingleLoaded(id: 1)),
      expect: () => [
        isA<MoviesSingleInProgress>(),
        isA<MoviesSingleSuccess>(),
      ],
    );
    blocTest<MoviesBloc, MoviesState>(
      'emits [MoviesSingleInProgress, MoviesSingleFailure] when MoviesDataSingleLoaded is added.',
      build: () => bloc,
      setUp: () async {
        return mc
            .when(client.get(Uri.parse(baseURL)))
            .thenAnswer((_) async => Response("Not Found", 400));
      },
      act: (bloc) => bloc.add(MoviesDataSingleLoaded(id: 1)),
      expect: () => [
        isA<MoviesSingleInProgress>(),
        isA<MoviesSingleFailure>(),
      ],
    );
  });
}
