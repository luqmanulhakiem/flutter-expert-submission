import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/src/core/common/constants.dart';
import 'package:ditonton/src/features/tv/domain/entities/tv.dart';
import 'package:ditonton/src/features/tv/domain/usecases/get_now_playing_tv_series.dart';
import 'package:ditonton/src/features/tv/domain/usecases/get_popular_tv_series.dart';
import 'package:ditonton/src/features/tv/domain/usecases/get_top_rated_tv_series.dart';
import 'package:ditonton/src/features/tv/presentation/blocs/now_playing_tv/now_playing_tv_bloc.dart';
import 'package:ditonton/src/features/tv/presentation/blocs/top_rated_tv/top_rated_tv_bloc.dart';
import 'package:ditonton/src/features/tv/presentation/blocs/tv_popular/tv_popular_bloc.dart';
import 'package:ditonton/src/features/tv/presentation/pages/popular_tv_page.dart';
import 'package:ditonton/src/features/tv/presentation/pages/search_tv_page.dart';
import 'package:ditonton/src/features/tv/presentation/pages/top_rated_tv_page.dart';
import 'package:ditonton/src/features/tv/presentation/pages/tv_detail_page.dart';
import 'package:ditonton/src/shared/presentation/widgets/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeTvPage extends StatefulWidget {
  static const ROUTE_NAME = '/home/tv';

  @override
  _HomeTvPageState createState() => _HomeTvPageState();
}

class _HomeTvPageState extends State<HomeTvPage> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Blocs
    final nowPlayingBloc =
        BlocProvider.of<NowPlayingTvBloc>(context, listen: false);
    final popularBloc = BlocProvider.of<TvPopularBloc>(context, listen: false);
    final tvTopRated = BlocProvider.of<TopRatedTvBloc>(context, listen: false);

    // Use cases
    await GetNowPlayingTvSeries(nowPlayingBloc).execute();
    await GetPopularTvSeries(popularBloc).execute();
    await GetTopRatedTvSeries(tvTopRated).execute();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        title: Text('TV Series'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SearchTvPage.ROUTE_NAME);
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
              BlocBuilder<NowPlayingTvBloc, NowPlayingTvState>(
                builder: (context, state) {
                  if (state is NowPlayingTvInProgress) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is NowPlayingTvSuccess) {
                    return TvSeries(state.data);
                  }
                  return Text('Failed');
                },
              ),
              _buildSubHeading(
                title: 'Popular',
                onTap: () =>
                    Navigator.pushNamed(context, PopularTvPage.ROUTE_NAME),
              ),
              BlocBuilder<TvPopularBloc, TvPopularState>(
                builder: (context, state) {
                  if (state is TvPopularInProgress) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is TvPopularSuccess) {
                    return TvSeries(state.data);
                  }
                  return Text('Failed');
                },
              ),
              _buildSubHeading(
                title: 'Top Rated',
                onTap: () =>
                    Navigator.pushNamed(context, TopRatedTvPage.ROUTE_NAME),
              ),
              BlocBuilder<TopRatedTvBloc, TopRatedTvState>(
                builder: (context, state) {
                  if (state is TopRatedTvInProgress) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is TopRatedTvSuccess) {
                    return TvSeries(state.data);
                  }
                  return Text('Failed');
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

class TvSeries extends StatelessWidget {
  final List<Tv> tvSeries;

  TvSeries(this.tvSeries);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final tv = tvSeries[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  TvDetailPage.ROUTE_NAME,
                  arguments: tv.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${tv.posterPath}',
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: tvSeries.length,
      ),
    );
  }
}
