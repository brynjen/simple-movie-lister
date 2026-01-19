import 'dart:async';
import 'package:simple_movie_lister/models/movie.dart';

class MovieService {
  // Mock data generation
  Future<List<Movie>> searchMovies(String query, int page) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    if (query.isEmpty) return [];

    // Generate 20 mock movies per page
    return List.generate(20, (index) {
      final id = (page - 1) * 20 + index + 1;
      return Movie(
        title: '$query Movie $id',
        year: '${2020 - (id % 10)}',
        posterUrl: 'https://picsum.photos/seed/movie$id/200/300',
        imdbId: 'tt$id',
      );
    });
  }
}
