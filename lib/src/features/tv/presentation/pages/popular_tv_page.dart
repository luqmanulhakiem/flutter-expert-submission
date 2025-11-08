import 'package:ditonton/src/features/tv/presentation/blocs/tv_popular/tv_popular_bloc.dart';
import 'package:ditonton/src/features/tv/presentation/widgets/tv_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularTvPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-tv';

  @override
  _PopularTvPageState createState() => _PopularTvPageState();
}

class _PopularTvPageState extends State<PopularTvPage> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    BlocProvider.of<TvPopularBloc>(context, listen: false)
        .add(TvPopulaDataLoaded());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular TV Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TvPopularBloc, TvPopularState>(
          builder: (context, state) {
            if (state is TvPopularInProgress) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TvPopularSuccess) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvSeries = state.data[index];
                  return TvCard(tvSeries);
                },
                itemCount: state.data.length,
              );
            } else if (state is TvPopularFailure) {
              return Center(
                key: Key('error_message'),
                child: Text(state.message),
              );
            }
            return Text('Failed');
          },
        ),
      ),
    );
  }
}
