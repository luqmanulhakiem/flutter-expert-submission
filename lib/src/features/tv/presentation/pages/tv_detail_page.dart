import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/src/core/common/constants.dart';
import 'package:ditonton/src/features/tv/domain/entities/tv_detail.dart';
import 'package:ditonton/src/features/tv/domain/usecases/get_detail_tv_series.dart';
import 'package:ditonton/src/features/tv/domain/usecases/get_recommendations_tv_series.dart';
import 'package:ditonton/src/features/tv/presentation/blocs/recommendation_tv/recommendation_tv_bloc.dart';
import 'package:ditonton/src/features/tv/presentation/blocs/tv_series/tv_series_bloc.dart';
import 'package:ditonton/src/features/tv/presentation/provider/tv_series_detail_notifier.dart';
import 'package:ditonton/src/shared/domain/entities/genre.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class TvDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/detail-tv';

  final int id;
  TvDetailPage({required this.id});

  @override
  _TvDetailPageState createState() => _TvDetailPageState();
}

class _TvDetailPageState extends State<TvDetailPage> {
  @override
  void initState() {
    super.initState();
    _loadData();
    Future.microtask(() {
      // Provider.of<TvSeriesDetailNotifier>(context, listen: false)
      //     .fetchMovieDetail(widget.id);
      Provider.of<TvSeriesDetailNotifier>(context, listen: false)
          .loadWatchlistStatus(widget.id);
    });
  }

  Future<void> _loadData() async {
    // Blocs
    final tvBloc = BlocProvider.of<TvSeriesBloc>(context, listen: false);
    final recommendationBloc =
        BlocProvider.of<RecommendationTvBloc>(context, listen: false);

    // Usecases
    await GetDetailTvSeries(tvBloc).execute(widget.id);
    await GetRecommendationsTvSeries(recommendationBloc).execute(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: BlocBuilder<TvSeriesBloc, TvSeriesState>(
      builder: (context, state) {
        if (state is TvSeriesSingleInProgress) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is TvSeriesSingleSuccess) {
          final movie = state.data;
          return SafeArea(
            child: DetailContent(
              movie,
              false,
            ),
          );
        } else if (state is TvSeriesSingleFailure) {}
        return Container();
      },
    ));
  }
}

class DetailContent extends StatelessWidget {
  final TvDetail movie;
  final bool isAddedWatchlist;

  DetailContent(this.movie, this.isAddedWatchlist);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              movie.title,
                              style: kHeading5,
                            ),
                            FilledButton(
                              onPressed: () async {
                                if (!isAddedWatchlist) {
                                  await Provider.of<TvSeriesDetailNotifier>(
                                          context,
                                          listen: false)
                                      .addWatchlist(movie);
                                } else {
                                  await Provider.of<TvSeriesDetailNotifier>(
                                          context,
                                          listen: false)
                                      .removeFromWatchlist(movie);
                                }

                                final message =
                                    Provider.of<TvSeriesDetailNotifier>(context,
                                            listen: false)
                                        .watchlistMessage;

                                if (message ==
                                        TvSeriesDetailNotifier
                                            .watchlistAddSuccessMessage ||
                                    message ==
                                        TvSeriesDetailNotifier
                                            .watchlistRemoveSuccessMessage) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(message)));
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: Text(message),
                                        );
                                      });
                                }
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  isAddedWatchlist
                                      ? Icon(Icons.check)
                                      : Icon(Icons.add),
                                  Text('Watchlist'),
                                ],
                              ),
                            ),
                            Text(
                              _showGenres(movie.genres),
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: movie.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${movie.voteAverage}')
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              movie.overview,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            BlocBuilder<RecommendationTvBloc,
                                RecommendationTvState>(
                              builder: (context, state) {
                                if (state is RecommendationTvInProgress) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (state is RecommendationTvSuccess) {
                                  return Container(
                                    height: 150,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final movie = state.data[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pushReplacementNamed(
                                                context,
                                                TvDetailPage.ROUTE_NAME,
                                                arguments: movie.id,
                                              );
                                            },
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                                placeholder: (context, url) =>
                                                    Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: state.data.length,
                                    ),
                                  );
                                } else if (state is RecommendationTvFailure) {
                                  return Text(state.message);
                                }
                                return Container();
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            // initialChildSize: 0.5,
            minChildSize: 0.25,
            // maxChildSize: 1.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += genre.name + ', ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }
}
