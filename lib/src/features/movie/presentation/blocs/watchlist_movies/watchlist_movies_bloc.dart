import 'package:bloc/bloc.dart';
import 'package:ditonton/src/features/movie/domain/entities/movie.dart';
import 'package:ditonton/src/features/movie/domain/entities/movie_detail.dart';
import 'package:ditonton/src/features/movie/domain/repositories/movie_repository.dart';

part 'watchlist_movies_event.dart';
part 'watchlist_movies_state.dart';

class WatchlistMoviesBloc
    extends Bloc<WatchlistMoviesEvent, WatchlistMoviesState> {
  final MovieRepository repository;
  WatchlistMoviesBloc(this.repository) : super(WatchlistMoviesInitial()) {
    on<WatchlistMoviesDataLoaded>((event, emit) async {
      emit(WatchlistMoviesDataInProgress());

      final resp = await repository.getWatchlistMovies();
      emit(resp.fold(
        (l) => WatchlistMoviesDataFailure(message: l.message),
        (r) => WatchlistMoviesDataSuccess(data: r),
      ));
    });

    on<WatchlistMoviesDataChecked>((event, emit) async {
      emit(WatchlistMoviesInProgress());
      try {
        final resp = await repository.isAddedToWatchlist(event.id);
        emit(WatchlistMoviesSuccess(isAddedToWatchlist: resp));
      } catch (e) {
        emit(WatchlistMoviesFailure(message: "$e"));
      }
    });

    on<WatchlistMoviesDataStored>((event, emit) async {
      emit(WatchlistMoviesActionInProgress());

      final resp = await repository.saveWatchlist(event.data);
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

      final resp = await repository.removeWatchlist(event.data);
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
