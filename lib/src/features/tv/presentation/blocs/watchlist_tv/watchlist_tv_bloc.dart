import 'package:bloc/bloc.dart';
import 'package:ditonton/src/features/tv/domain/entities/tv.dart';
import 'package:ditonton/src/features/tv/domain/entities/tv_detail.dart';
import 'package:ditonton/src/features/tv/domain/usecases/get_watchlist_status_tv_series.dart';
import 'package:ditonton/src/features/tv/domain/usecases/get_watchlist_tv_series.dart';
import 'package:ditonton/src/features/tv/domain/usecases/remove_watchlist_tv_series.dart';
import 'package:ditonton/src/features/tv/domain/usecases/save_watchlist_tv_series.dart';

part 'watchlist_tv_event.dart';
part 'watchlist_tv_state.dart';

class WatchlistTvBloc extends Bloc<WatchlistTvEvent, WatchlistTvState> {
  final GetWatchlistTvSeries getWatchlistTvSeries;
  final GetWatchlistStatusTvSeries getWatchlistStatusTvSeries;
  final SaveWatchlistTvSeries saveWatchlistTvSeries;
  final RemoveWatchlistTvSeries removeWatchlistTvSeries;
  WatchlistTvBloc(this.getWatchlistStatusTvSeries, this.getWatchlistTvSeries,
      this.saveWatchlistTvSeries, this.removeWatchlistTvSeries)
      : super(WatchlistTvInitial()) {
    on<WatchlistTvDataLoaded>((event, emit) async {
      emit(WatchlistTvDataInProgress());

      final resp = await getWatchlistTvSeries.execute();
      emit(resp.fold(
        (l) => WatchlistTvDataFailure(message: l.message),
        (r) => WatchlistTvDataSuccess(data: r),
      ));
    });

    on<WatchlistTvDataChecked>((event, emit) async {
      emit(WatchlistTvInProgress());
      try {
        final resp = await getWatchlistStatusTvSeries.execute(event.id);
        emit(WatchlistTvSuccess(isAddedToWatchlist: resp));
      } catch (e) {
        emit(WatchlistTvFailure(message: "$e"));
      }
    });

    on<WatchlistTvDataStored>((event, emit) async {
      emit(WatchlistTvActionInProgress());

      final resp = await saveWatchlistTvSeries.execute(event.data);
      resp.fold(
        (l) => emit(WatchlistTvActionFailure(message: l.message)),
        (r) {
          add(WatchlistTvDataChecked(id: event.data.id));
          emit(WatchlistTvActionSuccess(message: r));
        },
      );
    });

    on<WatchlistTvDataRemoved>((event, emit) async {
      emit(WatchlistTvActionInProgress());

      final resp = await removeWatchlistTvSeries.execute(event.data);
      resp.fold(
        (l) => emit(WatchlistTvActionFailure(message: l.message)),
        (r) {
          add(WatchlistTvDataChecked(id: event.data.id));
          emit(WatchlistTvActionSuccess(message: r));
        },
      );
    });
  }
}
