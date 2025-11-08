import 'package:dartz/dartz.dart';
import 'package:ditonton/src/features/tv/domain/entities/tv.dart';
import 'package:ditonton/src/features/tv/domain/usecases/get_popular_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetPopularTvSeries usecase;
  late MockTvSeriesRepository mockMovieRpository;

  setUp(() {
    mockMovieRpository = MockTvSeriesRepository();
    usecase = GetPopularTvSeries(mockMovieRpository);
  });

  final tTv = <Tv>[];

  group('GetPopularTvSeries Tests', () {
    group('execute', () {
      test(
          'should get list of tv series from the repository when execute function is called',
          () async {
        // arrange
        when(mockMovieRpository.getPopularTvSeries())
            .thenAnswer((_) async => Right(tTv));
        // act
        final result = await usecase.execute();
        // assert
        expect(result, Right(tTv));
      });
    });
  });
}
