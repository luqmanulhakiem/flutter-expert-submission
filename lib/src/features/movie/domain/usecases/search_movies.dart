import 'package:ditonton/src/features/movie/presentation/blocs/movies/movies_bloc.dart';

class SearchMovies {
  final MoviesBloc bloc;

  SearchMovies(this.bloc);

  Future<void> execute(String query) async {
    bloc.add(MoviesDataSearched(query: query));
  }
}
