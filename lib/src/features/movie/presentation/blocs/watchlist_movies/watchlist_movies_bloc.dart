import 'package:bloc/bloc.dart';
import 'package:ditonton/src/features/movie/domain/entities/movie.dart';
import 'package:ditonton/src/features/movie/domain/entities/movie_detail.dart';
import 'package:ditonton/src/features/movie/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/src/features/movie/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/src/features/movie/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/src/features/movie/domain/usecases/save_watchlist.dart';

part 'watchlist_movies_event.dart';
part 'watchlist_movies_state.dart';

class WatchlistMoviesBloc
    extends Bloc<WatchlistMoviesEvent, WatchlistMoviesState> {
  final GetWatchListStatus getWatchListStatus;
  final GetWatchlistMovies getWatchlistMovies;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;
  WatchlistMoviesBloc(this.getWatchListStatus, this.getWatchlistMovies,
      this.saveWatchlist, this.removeWatchlist)
      : super(WatchlistMoviesInitial()) {
    on<WatchlistMoviesDataLoaded>((event, emit) async {
      emit(WatchlistMoviesDataInProgress());

      final resp = await getWatchlistMovies.execute();
      emit(resp.fold(
        (l) => WatchlistMoviesDataFailure(message: l.message),
        (r) => WatchlistMoviesDataSuccess(data: r),
      ));
    });

    on<WatchlistMoviesDataChecked>((event, emit) async {
      emit(WatchlistMoviesInProgress());
      try {
        final resp = await getWatchListStatus.execute(event.id);
        emit(WatchlistMoviesSuccess(isAddedToWatchlist: resp));
      } catch (e) {
        emit(WatchlistMoviesFailure(message: "$e"));
      }
    });

    on<WatchlistMoviesDataStored>((event, emit) async {
      emit(WatchlistMoviesActionInProgress());

      final resp = await saveWatchlist.execute(event.data);
      resp.fold(
        (l) => emit(WatchlistMoviesActionFailure(message: l.message)),
        (r) {
          add(WatchlistMoviesDataChecked(id: event.data.id));
          emit(WatchlistMoviesActionSuccess(message: r));
        },
      );
    });

    on<WatchlistMoviesDataRemoved>((event, emit) async {
      emit(WatchlistMoviesActionInProgress());

      final resp = await removeWatchlist.execute(event.data);
      resp.fold(
        (l) => emit(WatchlistMoviesActionFailure(message: l.message)),
        (r) {
          add(WatchlistMoviesDataChecked(id: event.data.id));
          emit(WatchlistMoviesActionSuccess(message: r));
        },
      );
    });
  }
}
