import 'package:ditonton/src/core/common/state_enum.dart';
import 'package:ditonton/src/core/common/utils.dart';
import 'package:ditonton/src/features/movie/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/src/features/movie/presentation/blocs/watchlist_movies/watchlist_movies_bloc.dart';
import 'package:ditonton/src/features/movie/presentation/widgets/movie_card_list.dart';
import 'package:ditonton/src/features/tv/presentation/provider/watch_list_tv_notifer.dart';
import 'package:ditonton/src/features/tv/presentation/widgets/tv_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

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
    Future.microtask(() =>
        Provider.of<WatchListTvNotifer>(context, listen: false)
            .fetchWatchlistTv());
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<void> _loadData() async {
    final bloc = BlocProvider.of<WatchlistMoviesBloc>(context, listen: false);
    await GetWatchlistMovies(bloc).execute();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  void didPopNext() {
    _loadData();
    Provider.of<WatchListTvNotifer>(context, listen: false).fetchWatchlistTv();
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
                  child: Consumer<WatchListTvNotifer>(
                    builder: (context, data, child) {
                      if (data.watchlistState == RequestState.Loading) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (data.watchlistState == RequestState.Loaded) {
                        print(data.watchlistTv.length);
                        return ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final tv = data.watchlistTv[index];
                            return TvCard(tv);
                          },
                          itemCount: data.watchlistTv.length,
                        );
                      } else {
                        return Center(
                          key: Key('error_message'),
                          child: Text(data.message),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
