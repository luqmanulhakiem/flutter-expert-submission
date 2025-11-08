import 'package:ditonton/src/core/common/state_enum.dart';
import 'package:ditonton/src/features/tv/domain/entities/tv.dart';
import 'package:ditonton/src/features/tv/domain/entities/tv_detail.dart';
import 'package:ditonton/src/features/tv/domain/usecases/get_detail_tv_series.dart';
import 'package:ditonton/src/features/tv/domain/usecases/get_recommendations_tv_series.dart';
import 'package:ditonton/src/features/tv/domain/usecases/get_watchlist_status_tv_series.dart';
import 'package:ditonton/src/features/tv/domain/usecases/remove_watchlist_tv_series.dart';
import 'package:ditonton/src/features/tv/domain/usecases/save_watchlist_tv_series.dart';
import 'package:flutter/material.dart';

class TvSeriesDetailNotifier extends ChangeNotifier {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetDetailTvSeries getDetailTvSeries;
  final GetRecommendationsTvSeries getRecommendationsTvSeries;
  final GetWatchlistStatusTvSeries getWatchlistStatusTvSeries;
  final SaveWatchlistTvSeries saveWatchlistTvSeries;
  final RemoveWatchlistTvSeries removeWatchlistTvSeries;

  TvSeriesDetailNotifier({
    required this.getDetailTvSeries,
    required this.getRecommendationsTvSeries,
    required this.getWatchlistStatusTvSeries,
    required this.saveWatchlistTvSeries,
    required this.removeWatchlistTvSeries,
  });

  late TvDetail _tvSeries;
  TvDetail get tvSeries => _tvSeries;

  RequestState _tvSeriesState = RequestState.Empty;
  RequestState get tvSeriesState => _tvSeriesState;

  List<Tv> _tvSeriesRecommendations = [];
  List<Tv> get tvSeriesRecommendations => _tvSeriesRecommendations;

  RequestState _recommendationState = RequestState.Empty;
  RequestState get recommendationState => _recommendationState;

  String _message = '';
  String get message => _message;

  bool _isAddedtoWatchlist = false;
  bool get isAddedToWatchlist => _isAddedtoWatchlist;

  // Future<void> fetchMovieDetail(int id) async {
  //   _tvSeriesState = RequestState.Loading;
  //   notifyListeners();
  //   final detailResult = await getDetailTvSeries.execute(id);
  //   final recommendationResult = await getRecommendationsTvSeries.execute(id);
  //   detailResult.fold(
  //     (failure) {
  //       _tvSeriesState = RequestState.Error;
  //       _message = failure.message;
  //       notifyListeners();
  //     },
  //     (tv) {
  //       _recommendationState = RequestState.Loading;
  //       _tvSeries = tv;
  //       notifyListeners();
  //       recommendationResult.fold(
  //         (failure) {
  //           _recommendationState = RequestState.Error;
  //           _message = failure.message;
  //         },
  //         (tvSeries) {
  //           _recommendationState = RequestState.Loaded;
  //           _tvSeriesRecommendations = tvSeries;
  //         },
  //       );
  //       _tvSeriesState = RequestState.Loaded;
  //       notifyListeners();
  //     },
  //   );
  // }

  String _watchlistMessage = '';
  String get watchlistMessage => _watchlistMessage;

  Future<void> addWatchlist(TvDetail tv) async {
    final result = await saveWatchlistTvSeries.execute(tv);

    await result.fold(
      (failure) async {
        _watchlistMessage = failure.message;
      },
      (successMessage) async {
        _watchlistMessage = successMessage;
      },
    );

    await loadWatchlistStatus(tv.id);
  }

  Future<void> removeFromWatchlist(TvDetail movie) async {
    final result = await removeWatchlistTvSeries.execute(movie);

    await result.fold(
      (failure) async {
        _watchlistMessage = failure.message;
      },
      (successMessage) async {
        _watchlistMessage = successMessage;
      },
    );

    await loadWatchlistStatus(movie.id);
  }

  Future<void> loadWatchlistStatus(int id) async {
    final result = await getWatchlistStatusTvSeries.execute(id);
    _isAddedtoWatchlist = result;
    notifyListeners();
  }
}
