import 'package:bloc/bloc.dart';
import 'package:ditonton/src/features/tv/domain/entities/tv.dart';
import 'package:ditonton/src/features/tv/domain/entities/tv_detail.dart';
import 'package:ditonton/src/features/tv/domain/repositories/tv_series_repository.dart';

part 'watchlist_tv_event.dart';
part 'watchlist_tv_state.dart';

class WatchlistTvBloc extends Bloc<WatchlistTvEvent, WatchlistTvState> {
  final TvSeriesRepository repository;
  WatchlistTvBloc(this.repository) : super(WatchlistTvInitial()) {
    on<WatchlistTvDataLoaded>((event, emit) async {
      emit(WatchlistTvDataInProgress());

      final resp = await repository.getWatchlistTvSeries();
      emit(resp.fold(
        (l) => WatchlistTvDataFailure(message: l.message),
        (r) => WatchlistTvDataSuccess(data: r),
      ));
    });

    on<WatchlistTvDataChecked>((event, emit) async {
      emit(WatchlistTvInProgress());
      try {
        final resp = await repository.isTvSeriesAddedToWatchlist(event.id);
        emit(WatchlistTvSuccess(isAddedToWatchlist: resp));
      } catch (e) {
        emit(WatchlistTvFailure(message: "$e"));
      }
    });

    on<WatchlistTvDataStored>((event, emit) async {
      emit(WatchlistTvActionInProgress());

      final resp = await repository.saveTvSeriesWatchlist(event.data);
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

      final resp = await repository.removeTvSeriesWatchlist(event.data);
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
