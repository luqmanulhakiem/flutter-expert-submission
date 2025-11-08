import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/src/core/common/constants.dart';
import 'package:ditonton/src/core/common/state_enum.dart';
import 'package:ditonton/src/features/tv/domain/entities/tv.dart';
import 'package:ditonton/src/features/tv/domain/usecases/get_now_playing_tv_series.dart';
import 'package:ditonton/src/features/tv/presentation/blocs/now_playing_tv/now_playing_tv_bloc.dart';
import 'package:ditonton/src/features/tv/presentation/pages/popular_tv_page.dart';
import 'package:ditonton/src/features/tv/presentation/pages/search_tv_page.dart';
import 'package:ditonton/src/features/tv/presentation/pages/top_rated_tv_page.dart';
import 'package:ditonton/src/features/tv/presentation/pages/tv_detail_page.dart';
import 'package:ditonton/src/features/tv/presentation/provider/tv_series_list_notifier.dart';
import 'package:ditonton/src/shared/presentation/widgets/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

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
    Future.microtask(
      () => Provider.of<TvSeriesListNotifier>(context, listen: false)
        // ..fetchNowPlayingTvSeries()
        ..fetchTopRatedTvSeries()
        ..fetchPopularTvSeries(),
    );
  }

  Future<void> _loadData() async {
    // Blocs
    final nowPlayingBloc =
        BlocProvider.of<NowPlayingTvBloc>(context, listen: false);

    // Use cases
    await GetNowPlayingTvSeries(nowPlayingBloc).execute();
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
              Consumer<TvSeriesListNotifier>(builder: (context, data, child) {
                final state = data.popularTvSeriesState;
                if (state == RequestState.Loading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state == RequestState.Loaded) {
                  return TvSeries(data.popularTv);
                } else {
                  return Text('Failed');
                }
              }),
              _buildSubHeading(
                title: 'Top Rated',
                onTap: () =>
                    Navigator.pushNamed(context, TopRatedTvPage.ROUTE_NAME),
              ),
              Consumer<TvSeriesListNotifier>(builder: (context, data, child) {
                final state = data.topRatedTvSeriesState;
                if (state == RequestState.Loading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state == RequestState.Loaded) {
                  return TvSeries(data.topRatedTvSeries);
                } else {
                  return Text('Failed');
                }
              }),
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
