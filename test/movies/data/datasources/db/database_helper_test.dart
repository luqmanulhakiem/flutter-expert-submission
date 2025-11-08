import 'package:ditonton/src/features/movie/data/datasources/db/database_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../../../tv_series/dummy_data/dummy_objects.dart';
import '../../../dummy_data/dummy_objects.dart';

void main() {
  late DatabaseHelper databaseHelper;

  // Setup environment sqlite untuk testing di memory
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    databaseHelper = DatabaseHelper();
    final db = await databaseHelper.database;
    await db!.execute('DELETE FROM watchlist');
  });

  group('DatabaseHelper', () {
    final testMovie = testMovieTable;

    final testTv = testTvTable;

    test('should insert movie to watchlist', () async {
      final result = await databaseHelper.insertWatchlist(testMovie);

      expect(result, isNonZero);
      final content = await databaseHelper.getContentById(1);
      expect(content, isNotNull);
      expect(content!['title'], 'title');
    });

    test('should insert TV series to watchlist', () async {
      final result = await databaseHelper.insertTvSeriesWatchlist(testTv);

      expect(result, isNonZero);
      final content = await databaseHelper.getContentById(1);
      expect(content, isNotNull);
      expect(content!['title'], 'title');
    });

    test('should remove movie from watchlist', () async {
      await databaseHelper.insertWatchlist(testMovie);

      final result = await databaseHelper.removeWatchlist(testMovie);
      expect(result, 1);

      final content = await databaseHelper.getContentById(1);
      expect(content, isNull);
    });

    test('should remove TV series from watchlist', () async {
      await databaseHelper.insertTvSeriesWatchlist(testTv);

      final result = await databaseHelper.removeTvSeriesWatchlist(testTv);
      expect(result, 1);

      final content = await databaseHelper.getContentById(101);
      expect(content, isNull);
    });

    test('should return list of movies from watchlist', () async {
      await databaseHelper.insertWatchlist(testMovie);

      final results = await databaseHelper.getWatchlistMovies();
      expect(results.length, 1);
      expect(results.first['type'], 'movies');
    });

    test('should return list of tvSeries from watchlist', () async {
      await databaseHelper.insertTvSeriesWatchlist(testTv);

      final results = await databaseHelper.getWatchlistTv();
      expect(results.length, 1);
      expect(results.first['type'], 'tvSeries');
    });

    test('should return null when content not found by id', () async {
      final result = await databaseHelper.getContentById(999);
      expect(result, isNull);
    });
  });
}
