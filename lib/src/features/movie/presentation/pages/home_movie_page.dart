import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/src/core/common/constants.dart';
import 'package:ditonton/src/features/movie/domain/entities/movie.dart';
import 'package:ditonton/src/features/movie/presentation/blocs/now_playing_movies/now_playing_movies_bloc.dart';
import 'package:ditonton/src/features/movie/presentation/blocs/popular_movies/popular_movies_bloc.dart';
import 'package:ditonton/src/features/movie/presentation/blocs/top_rated_movies/top_rated_movies_bloc.dart';
import 'package:ditonton/src/features/movie/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/src/features/movie/presentation/pages/popular_movies_page.dart';
import 'package:ditonton/src/features/movie/presentation/pages/search_page.dart';
import 'package:ditonton/src/features/movie/presentation/pages/top_rated_movies_page.dart';
import 'package:ditonton/src/shared/presentation/widgets/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeMoviePage extends StatefulWidget {
  static const ROUTE_NAME = '/home/movie';

  @override
  _HomeMoviePageState createState() => _HomeMoviePageState();
}

class _HomeMoviePageState extends State<HomeMoviePage> {
  late NowPlayingMoviesBloc nowPlayingMoviesBloc;
  late PopularMoviesBloc popularMoviesBloc;
  late TopRatedMoviesBloc topRatedMoviesBloc;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    nowPlayingMoviesBloc =
        BlocProvider.of<NowPlayingMoviesBloc>(context, listen: false);
    popularMoviesBloc =
        BlocProvider.of<PopularMoviesBloc>(context, listen: false);
    topRatedMoviesBloc =
        BlocProvider.of<TopRatedMoviesBloc>(context, listen: false);

    nowPlayingMoviesBloc.add(NowPlayingMoviesDataLoaded());
    popularMoviesBloc.add(PopularMoviesDataLoaded());
    topRatedMoviesBloc.add(TopRatedMoviesDataLoaded());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        title: Text('Movies'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SearchPage.ROUTE_NAME);
            },
            icon: Icon(Icons.search),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Now Playing',
                style: kHeading6,
              ),
              BlocBuilder<NowPlayingMoviesBloc, NowPlayingMoviesState>(
                builder: (context, state) {
                  if (state is NowPlayingMoviesInProgress) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is NowPlayingMoviesSuccess) {
                    return MovieList(state.data);
                  }
                  return Text("Failed");
                },
              ),
              _buildSubHeading(
                title: 'Popular',
                onTap: () =>
                    Navigator.pushNamed(context, PopularMoviesPage.ROUTE_NAME),
              ),
              BlocBuilder<PopularMoviesBloc, PopularMoviesState>(
                builder: (context, state) {
                  if (state is PopularMoviesInProgress) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is PopularMoviesSuccess) {
                    return MovieList(state.data);
                  }
                  return Text("Failed");
                },
              ),
              _buildSubHeading(
                title: 'Top Rated',
                onTap: () =>
                    Navigator.pushNamed(context, TopRatedMoviesPage.ROUTE_NAME),
              ),
              BlocBuilder<TopRatedMoviesBloc, TopRatedMoviesState>(
                builder: (context, state) {
                  if (state is TopRatedMoviesInProgress) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is TopRatedMoviesSuccess) {
                    return MovieList(state.data);
                  }
                  return Text("Failed");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class MovieList extends StatelessWidget {
  final List<Movie> movies;

  MovieList(this.movies);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  MovieDetailPage.ROUTE_NAME,
                  arguments: movie.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${movie.posterPath}',
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: movies.length,
      ),
    );
  }
}
