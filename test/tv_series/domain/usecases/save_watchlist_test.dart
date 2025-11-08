import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/src/features/tv/domain/usecases/save_watchlist_tv_series.dart';
import 'package:ditonton/src/features/tv/presentation/blocs/watchlist_tv/watchlist_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mt;

import '../../dummy_data/dummy_objects.dart';

class MockWatchlistTvBloc extends MockBloc<WatchlistTvEvent, WatchlistTvState>
    implements WatchlistTvBloc {}

void main() {
  late MockWatchlistTvBloc bloc;
  setUpAll(() {
    mt.registerFallbackValue(WatchlistTvDataStored(data: testTvDetail));
    bloc = MockWatchlistTvBloc();
  });

  test("SaveWatchlistTvSeries call WatchlistTvDataStored", () async {
    mt.when(() => bloc.state).thenReturn(WatchlistTvInitial());

    final usecase = SaveWatchlistTvSeries(bloc);

    await usecase.execute(testTvDetail);

    mt
        .verify(() => bloc
            .add(mt.any<WatchlistTvEvent>(that: isA<WatchlistTvDataStored>())))
        .called(1);
  });

  test('execute must success', () async {
    whenListen(bloc, const Stream<WatchlistTvState>.empty(),
        initialState: WatchlistTvInitial());
    await expectLater(
        SaveWatchlistTvSeries(bloc).execute(testTvDetail), completes);
  });
}
