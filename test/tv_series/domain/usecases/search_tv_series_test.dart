import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/src/features/tv/domain/usecases/search_tv_series.dart';
import 'package:ditonton/src/features/tv/presentation/blocs/tv_series/tv_series_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mt;

class MockTvSeriesBloc extends MockBloc<TvSeriesEvent, TvSeriesState>
    implements TvSeriesBloc {}

void main() {
  late MockTvSeriesBloc bloc;
  setUpAll(() {
    mt.registerFallbackValue(TvSeriesDataSearched(query: "Spiderman"));
    bloc = MockTvSeriesBloc();
  });

  test("SearchTvSeries call TvSeriesDataSearched", () async {
    mt.when(() => bloc.state).thenReturn(TvSeriesInitial());

    final usecase = SearchTvSeries(bloc);

    await usecase.execute("Spiderman");

    mt
        .verify(() =>
            bloc.add(mt.any<TvSeriesEvent>(that: isA<TvSeriesDataSearched>())))
        .called(1);
  });

  test('execute must success', () async {
    whenListen(bloc, const Stream<TvSeriesState>.empty(),
        initialState: TvSeriesInitial());
    await expectLater(SearchTvSeries(bloc).execute("Spiderman"), completes);
  });
}
