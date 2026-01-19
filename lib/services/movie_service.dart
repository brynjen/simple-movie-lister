import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:simple_movie_lister/models/movie.dart';

class MovieService {
  static const String _baseUrl = 'https://api.tvmaze.com/search/shows';

  Future<List<Movie>> searchMovies(String query, int page) async {
    if (query.isEmpty) return [];
    // Note: TVMaze search returns relevant results in one go, usually sorted by score.
    // We ignore the page parameter here as the API doesn't support standard pagination for search.
    if (page > 1) return []; 

    final url = Uri.parse('$_baseUrl?q=$query');
    
    try {
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        return data.map((item) => Movie.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load shows: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching shows: $e');
    }
  }
}
