import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/src/core/common/constants.dart';
import 'package:ditonton/src/features/movie/domain/entities/movie.dart';
import 'package:ditonton/src/features/movie/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/src/features/movie/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// NavigatorObserver sederhana utk menangkap route & argumen saat push.
class CapturingNavigatorObserver extends NavigatorObserver {
  Route<dynamic>? lastPushed;
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    lastPushed = route;
    super.didPush(route, previousRoute);
  }
}

/// Buat MaterialApp pembungkus agar Navigator & Theme tersedia.
Widget _makeTestable(Widget child, {NavigatorObserver? observer}) {
  return MaterialApp(
    home: Scaffold(body: child),
    routes: {
      MovieDetailPage.ROUTE_NAME: (_) =>
          const Scaffold(body: Center(child: Text('Detail Page'))),
    },
    navigatorObservers: [
      if (observer != null) observer,
    ],
  );
}

void main() {
  group('MovieCard', () {
    final testMovie = Movie(
      id: 1,
      title: 'Inception',
      overview: 'A mind-bending heist.',
      posterPath: '/inception.jpg',
      originalTitle: "Original Title",
      backdropPath: "/path.jpg",
      popularity: 1.0,
      releaseDate: "2020-05-05",
      video: false,
      voteAverage: 1.0,
      type: "movie",
      voteCount: 1,
      genreIds: [1, 2, 3, 4],
      adult: false,
    );

    testWidgets('menampilkan judul, overview, dan CachedNetworkImage',
        (tester) async {
      await tester.pumpWidget(_makeTestable(MovieCard(testMovie)));

      expect(find.text('Inception'), findsOneWidget);
      expect(find.text('A mind-bending heist.'), findsOneWidget);

      final imageFinder = find.byType(CachedNetworkImage);
      expect(imageFinder, findsOneWidget);

      final cached = tester.widget<CachedNetworkImage>(imageFinder);
      expect(cached.width, 80);
      expect(cached.placeholder, isNotNull);
      expect(cached.errorWidget, isNotNull);

      final titleText = tester.widget<Text>(find.text('Inception'));
      expect(titleText.style, kHeading6);
    });

    testWidgets('navigasi ke detail saat card di-tap', (tester) async {
      final observer = CapturingNavigatorObserver();

      await tester.pumpWidget(
        _makeTestable(MovieCard(testMovie), observer: observer),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      expect(find.text('Detail Page'), findsOneWidget);

      expect(observer.lastPushed, isNotNull);
      expect(observer.lastPushed!.settings.name, MovieDetailPage.ROUTE_NAME);
      expect(observer.lastPushed!.settings.arguments, testMovie.id);
    });

    testWidgets('fallback "-" ketika title/overview null', (tester) async {
      final movieWithNulls = Movie(
        id: 99,
        title: null,
        overview: null,
        posterPath: '/x.jpg',
        originalTitle: "Original Title",
        backdropPath: "/path.jpg",
        popularity: 1.0,
        releaseDate: "2020-05-05",
        video: false,
        voteAverage: 1.0,
        type: "movie",
        voteCount: 1,
        genreIds: [1, 2, 3, 4],
        adult: false,
      );

      await tester.pumpWidget(_makeTestable(MovieCard(movieWithNulls)));

      expect(find.text('-'), findsNWidgets(2));
    });
  });
}
