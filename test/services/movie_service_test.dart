import 'package:flutter_test/flutter_test.dart';
import 'package:simple_movie_lister/services/movie_service.dart';

void main() {
  group('MovieService', () {
    test('searchMovies can be instantiated', () {
      final service = MovieService();
      expect(service, isNotNull);
    });
  });
}
