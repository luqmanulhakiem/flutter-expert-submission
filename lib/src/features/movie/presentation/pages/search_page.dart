import 'package:ditonton/src/core/common/constants.dart';
import 'package:ditonton/src/features/movie/domain/usecases/search_movies.dart';
import 'package:ditonton/src/features/movie/presentation/blocs/movies/movies_bloc.dart';
import 'package:ditonton/src/features/movie/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatelessWidget {
  static const ROUTE_NAME = '/search';

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
              onSubmitted: (query) {
                final bloc =
                    BlocProvider.of<MoviesBloc>(context, listen: false);
                SearchMovies(bloc).execute(query);
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
            BlocBuilder<MoviesBloc, MoviesState>(
              builder: (context, state) {
                if (state is MoviesInProgress) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is MoviesSuccess) {
                  final result = state.data;
                  return Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (context, index) {
                        final movie = result[index];
                        return MovieCard(movie);
                      },
                      itemCount: result.length,
                    ),
                  );
                }
                return Expanded(
                  child: Container(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
