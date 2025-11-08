import 'package:ditonton/src/core/common/utils.dart';
import 'package:ditonton/src/features/movie/presentation/blocs/watchlist_movies/watchlist_movies_bloc.dart';
import 'package:ditonton/src/features/movie/presentation/widgets/movie_card_list.dart';
import 'package:ditonton/src/features/tv/domain/usecases/get_watchlist_tv_series.dart';
import 'package:ditonton/src/features/tv/presentation/blocs/watchlist_tv/watchlist_tv_bloc.dart';
import 'package:ditonton/src/features/tv/presentation/widgets/tv_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WatchlistPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist';

  const WatchlistPage({Key? key}) : super(key: key);

  @override
  State<WatchlistPage> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage>
    with SingleTickerProviderStateMixin, RouteAware {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _loadData();
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<void> _loadData() async {
    final bloc = BlocProvider.of<WatchlistMoviesBloc>(context, listen: false);
    final blocTv = BlocProvider.of<WatchlistTvBloc>(context, listen: false);
    bloc.add(WatchlistMoviesDataLoaded());
    await GetWatchlistTvSeries(blocTv).execute();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  void didPopNext() {
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Watchlist'),
          bottom: TabBar(controller: _tabController, tabs: [
            Tab(text: "Movies"),
            Tab(text: "Tv Series"),
          ]),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.sizeOf(context).height,
            width: MediaQuery.sizeOf(context).width,
            child: TabBarView(
              controller: _tabController,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BlocBuilder<WatchlistMoviesBloc, WatchlistMoviesState>(
                    builder: (context, state) {
                      if (state is WatchlistMoviesDataInProgress) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state is WatchlistMoviesDataSuccess) {
                        return ListView.builder(
                          itemBuilder: (context, index) {
                            final movie = state.data[index];
                            return MovieCard(movie);
                          },
                          itemCount: state.data.length,
                        );
                      } else if (state is WatchlistMoviesDataFailure) {
                        return Center(
                          key: Key('error_message'),
                          child: Text(state.message),
                        );
                      }
                      return SizedBox();
                    },
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: BlocBuilder<WatchlistTvBloc, WatchlistTvState>(
                      builder: (context, state) {
                        if (state is WatchlistTvDataInProgress) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is WatchlistTvDataSuccess) {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final tv = state.data[index];
                              return TvCard(tv);
                            },
                            itemCount: state.data.length,
                          );
                        } else if (state is WatchlistTvDataFailure) {
                          return Center(
                            key: Key('error_message'),
                            child: Text(state.message),
                          );
                        }
                        return Container();
                      },
                    )),
              ],
            ),
          ),
        ));
  }
}
