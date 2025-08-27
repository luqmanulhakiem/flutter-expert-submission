import 'package:ditonton/src/core/common/exception.dart';
import 'package:ditonton/src/features/movie/data/datasources/db/database_helper.dart';
import 'package:ditonton/src/features/tv/data/models/tv_table.dart';

abstract class TvSeriesLocalDataSource {
  Future<String> insertWatchList(TvTable tvSeries);
  Future<String> removeWatchList(TvTable tvSeries);
  Future<TvTable?> getTvSeriesId(int id);
  Future<List<TvTable>> getTvSeriesWatchlist();
}

class TvSeriesLocalDataSourceImpl implements TvSeriesLocalDataSource {
  final DatabaseHelper databaseHelper;

  TvSeriesLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<String> insertWatchList(TvTable tvSeries) async {
    try {
      await databaseHelper.insertTvSeriesWatchlist(tvSeries);
      return 'Added to Watchlist';
    } catch (e) {
      print(e.toString());
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeWatchList(TvTable tvSeries) async {
    try {
      await databaseHelper.removeTvSeriesWatchlist(tvSeries);
      return 'Removed from Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<TvTable?> getTvSeriesId(int id) async {
    final result = await databaseHelper.getContentById(id);
    if (result != null) {
      return TvTable.fromJson(result);
    } else {
      return null;
    }
  }

  @override
  Future<List<TvTable>> getTvSeriesWatchlist() async {
    final result = await databaseHelper.getWatchlistTv();
    return result.map((data) => TvTable.fromJson(data)).toList();
  }
}
