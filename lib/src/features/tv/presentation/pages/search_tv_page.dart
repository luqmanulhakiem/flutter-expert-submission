import 'package:ditonton/src/core/common/constants.dart';
import 'package:ditonton/src/features/tv/domain/usecases/search_tv_series.dart';
import 'package:ditonton/src/features/tv/presentation/blocs/tv_series/tv_series_bloc.dart';
import 'package:ditonton/src/features/tv/presentation/widgets/tv_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchTvPage extends StatelessWidget {
  static const ROUTE_NAME = '/search-tv';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onSubmitted: (query) async {
                final bloc =
                    BlocProvider.of<TvSeriesBloc>(context, listen: false);
                await SearchTvSeries(bloc).execute(query);
              },
              decoration: InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            SizedBox(height: 16),
            Text(
              'Search Result',
              style: kHeading6,
            ),
            BlocBuilder<TvSeriesBloc, TvSeriesState>(
              builder: (context, state) {
                if (state is TvSeriesInProgress) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is TvSeriesSuccess) {
                  final result = state.data;
                  return Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (context, index) {
                        final tv = state.data[index];
                        return TvCard(tv);
                      },
                      itemCount: result.length,
                    ),
                  );
                }
                return Expanded(
                  child: Container(),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
