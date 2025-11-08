import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/src/core/common/constants.dart';
import 'package:ditonton/src/features/movie/presentation/blocs/movies/movies_bloc.dart';
import 'package:ditonton/src/features/movie/presentation/blocs/recommendation_movies/recommendation_movies_bloc.dart';
import 'package:ditonton/src/features/movie/presentation/blocs/watchlist_movies/watchlist_movies_bloc.dart';
import 'package:ditonton/src/shared/domain/entities/genre.dart';
import 'package:ditonton/src/features/movie/domain/entities/movie_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class MovieDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/detail';

  final int id;
  MovieDetailPage({required this.id});

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  bool isAddedToWatchlist = false;
  late WatchlistMoviesBloc watchlistMoviesBloc;
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    //  BLocs
    final moviesBloc = BlocProvider.of<MoviesBloc>(context, listen: false);
    final recommendationMoviesBloc =
        BlocProvider.of<RecommendationMoviesBloc>(context, listen: false);
    watchlistMoviesBloc =
        BlocProvider.of<WatchlistMoviesBloc>(context, listen: false);

    moviesBloc.add(MoviesDataSingleLoaded(id: widget.id));
    recommendationMoviesBloc.add(RecommendationMoviesDataLoaded(id: widget.id));
    watchlistMoviesBloc.add(WatchlistMoviesDataChecked(id: widget.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MoviesBloc, MoviesState>(
        buildWhen: (previous, current) {
          return current is MoviesSingleInProgress ||
              current is MoviesSingleSuccess ||
              current is MoviesSingleFailure;
        },
        builder: (context, state) {
          if (state is MoviesSingleInProgress) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is MoviesSingleSuccess) {
            final movie = state.data;
            return SafeArea(
              child: DetailContent(movie, watchlistMoviesBloc),
            );
          } else if (state is MoviesSingleFailure) {
            return Text(state.message);
          }
          return SizedBox();
        },
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final MovieDetail movie;
  final WatchlistMoviesBloc bloc;
  DetailContent(this.movie, this.bloc);

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
                            BlocConsumer<WatchlistMoviesBloc,
                                WatchlistMoviesState>(
                              listener: (context, state) {
                                if (state is WatchlistMoviesActionSuccess) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(state.message)));
                                } else if (state
                                    is WatchlistMoviesActionFailure) {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: Text(state.message),
                                        );
                                      });
                                }
                              },
                              buildWhen: (previous, current) {
                                return current is WatchlistMoviesSuccess;
                              },
                              builder: (context, state) {
                                if (state is WatchlistMoviesSuccess) {
                                  return ElevatedButton(
                                    onPressed: () async {
                                      final bloc =
                                          BlocProvider.of<WatchlistMoviesBloc>(
                                              context,
                                              listen: false);
                                      if (!state.isAddedToWatchlist) {
                                        bloc.add(WatchlistMoviesDataStored(
                                            data: movie));
                                      } else {
                                        bloc.add(WatchlistMoviesDataRemoved(
                                            data: movie));
                                      }
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        state.isAddedToWatchlist
                                            ? Icon(Icons.check)
                                            : Icon(Icons.add),
                                        Text('Watchlist'),
                                      ],
                                    ),
                                  );
                                }
                                return SizedBox();
                              },
                            ),
                            Text(
                              _showGenres(movie.genres),
                            ),
                            Text(
                              _showDuration(movie.runtime),
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
                            BlocBuilder<RecommendationMoviesBloc,
                                RecommendationMoviesState>(
                              builder: (context, state) {
                                if (state is RecommendationMoviesInProgress) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (state
                                    is RecommendationMoviesSuccess) {
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
                                                MovieDetailPage.ROUTE_NAME,
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
                                } else if (state
                                    is RecommendationMoviesFailure) {
                                  return Text(state.message);
                                }
                                return SizedBox();
                              },
                            ),
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
            minChildSize: 0.25,
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

  String _showDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}
