import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/src/features/tv/domain/usecases/get_watchlist_status_tv_series.dart';
import 'package:ditonton/src/features/tv/presentation/blocs/watchlist_tv/watchlist_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mt;

class MockWatchlistTvBloc extends MockBloc<WatchlistTvEvent, WatchlistTvState>
    implements WatchlistTvBloc {}

void main() {
  late MockWatchlistTvBloc bloc;
  setUpAll(() {
    mt.registerFallbackValue(WatchlistTvDataChecked(id: 1));
    bloc = MockWatchlistTvBloc();
  });

  test("GetWatchlistStatusTvSeries call WatchlistTvDataChecked", () async {
    mt.when(() => bloc.state).thenReturn(WatchlistTvInitial());

    final usecase = GetWatchlistStatusTvSeries(bloc);

    await usecase.execute(1);

    mt
        .verify(() => bloc
            .add(mt.any<WatchlistTvEvent>(that: isA<WatchlistTvDataChecked>())))
        .called(1);
  });

  test('execute must success', () async {
    whenListen(bloc, const Stream<WatchlistTvState>.empty(),
        initialState: WatchlistTvInitial());
    await expectLater(GetWatchlistStatusTvSeries(bloc).execute(1), completes);
  });
}
