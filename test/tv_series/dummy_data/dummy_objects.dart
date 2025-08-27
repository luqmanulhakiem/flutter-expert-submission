import 'package:ditonton/src/features/tv/data/models/tv_table.dart';
import 'package:ditonton/src/features/tv/domain/entities/tv.dart';
import 'package:ditonton/src/features/tv/domain/entities/tv_detail.dart';
import 'package:ditonton/src/shared/domain/entities/genre.dart';

final testTv = Tv(
  type: "tvSeries",
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: [14, 28],
  id: 557,
  originalName: 'Spider-Man',
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  popularity: 60.441,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  firstAirDate: '2002-05-01',
  title: 'Spider-Man',
  originCountry: [],
  originalLanguage: 'english',
  voteAverage: 7.2,
  voteCount: 13507,
);

//generate dummy bawah berdasarkan diatas

final testTvList = [testTv];

final testTvDetail = TvDetail(
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  numberOfEpisodes: 10,
  seasons: [],
  tagline: "",
  type: "tvSeries",
  numberOfSeasons: 2,
  overview: 'overview',
  posterPath: 'posterPath',
  firstAirDate: 'firstAirDate',
  lastAirDate: 'lastAirDate',
  runtime: 120,
  title: 'title',
  voteAverage: 1,
  voteCount: 1,
);

final testWatchlistTv = Tv.watchlist(
  type: "tvSeries",
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testTvTable = TvTable(
  type: "tvSeries",
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testTvMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'title': 'title',
};
