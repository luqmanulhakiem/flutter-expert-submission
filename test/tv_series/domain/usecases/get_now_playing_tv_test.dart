import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/src/features/tv/domain/usecases/get_now_playing_tv_series.dart';
import 'package:ditonton/src/features/tv/presentation/blocs/now_playing_tv/now_playing_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mt;

class MockNowPlayingTvBloc
    extends MockBloc<NowPlayingTvEvent, NowPlayingTvState>
    implements NowPlayingTvBloc {}

void main() {
  late MockNowPlayingTvBloc bloc;
  setUpAll(() {
    mt.registerFallbackValue(NowPlayingTvDataLoaded());
    bloc = MockNowPlayingTvBloc();
  });

  test("GetNowPlayingTvSeries call NowPlayingTvDataLoaded", () async {
    mt.when(() => bloc.state).thenReturn(NowPlayingTvInitial());

    final usecase = GetNowPlayingTvSeries(bloc);

    await usecase.execute();

    mt
        .verify(() => bloc.add(
            mt.any<NowPlayingTvEvent>(that: isA<NowPlayingTvDataLoaded>())))
        .called(1);
  });

  test('execute must success', () async {
    whenListen(bloc, const Stream<NowPlayingTvState>.empty(),
        initialState: NowPlayingTvInitial());
    await expectLater(GetNowPlayingTvSeries(bloc).execute(), completes);
  });
}
