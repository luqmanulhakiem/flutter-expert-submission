import 'package:ditonton/src/features/movie/presentation/blocs/movies/movies_bloc.dart';

class GetMovieDetail {
  final MoviesBloc bloc;

  GetMovieDetail(this.bloc);

  Future<void> execute(int id) async {
    bloc.add(MoviesDataSingleLoaded(id: id));
  }
}
