import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/src/features/tv/domain/usecases/get_detail_tv_series.dart';
import 'package:ditonton/src/features/tv/presentation/blocs/tv_series/tv_series_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mt;

class MockTvSeriesBloc extends MockBloc<TvSeriesEvent, TvSeriesState>
    implements TvSeriesBloc {}

void main() {
  late MockTvSeriesBloc bloc;
  setUpAll(() {
    mt.registerFallbackValue(TvSeriesDataSingleLoaded(id: 1));
    bloc = MockTvSeriesBloc();
  });

  test("GetDetailTvSeries call TvSeriesDataSingleLoaded", () async {
    mt.when(() => bloc.state).thenReturn(TvSeriesInitial());

    final usecase = GetDetailTvSeries(bloc);

    await usecase.execute(1);

    mt
        .verify(() => bloc
            .add(mt.any<TvSeriesEvent>(that: isA<TvSeriesDataSingleLoaded>())))
        .called(1);
  });

  test('execute must success', () async {
    whenListen(bloc, const Stream<TvSeriesState>.empty(),
        initialState: TvSeriesInitial());
    await expectLater(GetDetailTvSeries(bloc).execute(1), completes);
  });
}
