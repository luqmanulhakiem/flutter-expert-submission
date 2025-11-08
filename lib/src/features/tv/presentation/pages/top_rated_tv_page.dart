import 'package:ditonton/src/features/tv/presentation/blocs/top_rated_tv/top_rated_tv_bloc.dart';
import 'package:ditonton/src/features/tv/presentation/widgets/tv_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopRatedTvPage extends StatefulWidget {
  static const ROUTE_NAME = '/top-rated-tv';

  @override
  _TopRatedTvPageState createState() => _TopRatedTvPageState();
}

class _TopRatedTvPageState extends State<TopRatedTvPage> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    BlocProvider.of<TopRatedTvBloc>(context, listen: false)
        .add(TopRatedTvDataLoaded());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Rated Tv'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TopRatedTvBloc, TopRatedTvState>(
          builder: (context, state) {
            if (state is TopRatedTvInProgress) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TopRatedTvSuccess) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = state.data[index];
                  return TvCard(tv);
                },
                itemCount: state.data.length,
              );
            } else if (state is TopRatedTvFailure) {
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
